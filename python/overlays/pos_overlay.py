import sys
import pandas as pd
import numpy as np
import geopandas as gpd
from sqlalchemy import create_engine

sys.path.insert(0, "C:/Users/bcarney/Documents/GitHub/housing_initiative_submarkets/python")
from settings import postgres_pw

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)

pos_submarkets = pd.read_sql(
    """
    select sr."Class", pos.acres
    from submarkets.submarket_results sr
    join public.dvrpc_protectedopenspace2020 pos
    on st_intersects(sr.geometry, pos.shape)""",
    engine,
)

print(pos_submarkets)
