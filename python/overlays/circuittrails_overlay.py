import sys
import pandas as pd
import geopandas as gpd
from sqlalchemy import create_engine

sys.path.insert(0, "C:/Users/bcarney/Documents/GitHub/housing_initiative_submarkets/python")
from settings import postgres_pw

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)

# Join Submarket Results and Circuit Trails
sql = """
with a as (select
    sr."GEOID",
    ct.circuit,
    sum(st_length(st_intersection(sr.geometry, ct.shape))) as submarket_trail_length
from
    submarkets.submarket_results sr,
    public.circuittrails ct
group by
    sr."GEOID",
    ct.circuit),
b as (
select
    "GEOID",
    sum(case when "circuit" = 'Existing' then "submarket_trail_length" end) as existing,
    sum(case when "circuit" = 'In Progress' then "submarket_trail_length" end) as in_progress,
    sum(case when "circuit" = 'Pipeline' then "submarket_trail_length" end) as pipeline,
    sum(case when "circuit" = 'Planned' then "submarket_trail_length" end) as planned
from
    a
group by
    "GEOID")
select
    sr."GEOID",
    sr."Class",
    sr."geometry",
    b.existing,
    b.in_progress,
    b.pipeline,
    b.planned
from
    b
left join submarkets.submarket_results sr on
    b."GEOID" = sr."GEOID"
"""


gdf = gpd.read_postgis(sql, engine, geom_col="geometry")
gdf.to_file(
    "U:\\FY2022\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\shapefiles\\overlays\\submarkets_circuittrails.shp",
    driver="ESRI Shapefile",
)


# Summarize Circuit Trails by Submarket and Circuit Phase
submarkets_circuittrails_byclass = pd.read_sql(
    """with a as (
select
    sr."Class",
    c."circuit",
    sum(c.length) as submarket_trail_length
from
    submarkets.submarket_results sr
join public.circuittrails c on
    st_intersects(sr.geometry,
    c.shape)
group by
    sr."Class",
    c."circuit")
select
    "Class",
    sum(case when "circuit" = 'Existing' then "submarket_trail_length" end) as existing,
    sum(case when "circuit" = 'In Progress' then "submarket_trail_length" end) as in_progress,
    sum(case when "circuit" = 'Pipeline' then "submarket_trail_length" end) as pipeline,
    sum(case when "circuit" = 'Planned' then "submarket_trail_length" end) as planned
from
    a
group by
    "Class"
order by
    "Class";""",
    engine,
)

submarkets_circuittrails_byclass["Class"] = submarkets_circuittrails_byclass["Class"].astype(int)
submarkets_circuittrails_byclass = submarkets_circuittrails_byclass.set_index("Class")
