import os
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

postgres_pw = os.environ.get("postgres_password")
gis_pw = os.environ.get("gis_pw")
census_api = os.environ.get("CENSUS_API_KEY")
