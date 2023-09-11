import geopandas as gp
from dotenv import load_dotenv, find_dotenv
from sqlalchemy import create_engine
from settings import postgres_pw

load_dotenv(find_dotenv())

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)


submarkets = gp.read_file(
    "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\shapefiles\\v1\\v1_submarket_outputs_scaled.shp"
)

submarkets.to_postgis("submarket_results", engine, schema="submarkets")
