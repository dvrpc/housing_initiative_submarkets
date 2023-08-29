import pandas as pd
import geopandas as gp
import os
from dotenv import load_dotenv, find_dotenv
from sqlalchemy import create_engine
import psycopg2
import geoalchemy2

load_dotenv(find_dotenv())

pg_password = os.environ.get("postgres_password")

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(pg_password)
)


submarkets = gp.read_file(
    "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\shapefiles\\v1\\v1_submarket_outputs_scaled.shp"
)

submarkets.to_postgis("submarket_results", engine, schema="submarkets")
