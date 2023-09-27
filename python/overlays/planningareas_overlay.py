import sys
import pandas as pd
import geopandas as gpd
from sqlalchemy import create_engine

sys.path.insert(0, "C:/Users/bcarney/Documents/GitHub/housing_initiative_submarkets/python")
from settings import postgres_pw

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)

submarkets_planningareas = pd.read_sql(
    """
    select sr."GEOID", sr."Class", sr.geometry, lrp.pa_2050
    from submarkets.submarket_results sr
    join public.lrp_2050_planningareas lrp
    on ST_Intersects(st_centroid(sr.geometry), lrp.shape)
    """,
    engine,
)


submarkets_planningareas = submarkets_planningareas[["Class", "pa_2050"]]
submarkets_planningareas["count"] = ""

test = submarkets_planningareas.groupby("Class", "pa_2050").count()
print(test)
