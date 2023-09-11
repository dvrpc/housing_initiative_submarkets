import os
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

postgres_pw = os.environ.get("postgres_password")
gis_db = os.environ.get("gis_db")
census_api = os.environ.get("CENSUS_API_KEY")

print(postgres_pw, gis_db, census_api)
