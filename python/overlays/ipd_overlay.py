import sys
import pandas as pd
import numpy as np
import geopandas as gpd
from sqlalchemy import create_engine

sys.path.insert(
    0, "C:/Users/bcarney/Documents/GitHub/housing_initiative_submarkets/python"
)
from settings import postgres_pw

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)

sql = """
    select sr."GEOID", CAST(sr."Class" as char(1)), sr.geometry, ipd.ipd_score
    from submarkets.submarket_results sr
    left join public.ipd_2021 ipd
    on sr."GEOID" = ipd.geoid20
    """

# gdf = gpd.read_postgis(sql, engine, geom_col="geometry")
"""gdf.to_file(
    "U:\\FY2022\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\shapefiles\\overlays\\submarkets_ipd.shp",
    driver="ESRI Shapefile",
)
"""


ipd = pd.read_sql(
    """
    select CAST(sr."Class" as char(1)), ipd.ipd_score
    from submarkets.submarket_results sr
    left join public.ipd_2021 ipd
    on sr."GEOID" = ipd.geoid20
    """,
    engine,
)

ipd_summary = ipd.groupby("Class")["ipd_score"].describe()
ipd_summary.to_excel(
    "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\overlays\\submarkets_ipd_summary.xlsx"
)
