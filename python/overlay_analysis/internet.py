import pandas as pd
import os
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

api_key = os.environ.get("CENSUS_API_KEY")

api_url = "https://api.census.gov/data/2021/acs/acs5?get=NAME,B28002_001E,B28002_002E&for=tract:*&in=state:34,42&in=county:*&key={}".format(
    api_key
)

df = pd.read_json(api_url)

df = df.rename(columns=df.iloc[0]).loc[1:]

df["fips"] = df["state"] + df["county"]

region_fips = ["34005", "34007", "34015", "34021", "42017", "42029", "42045", "42091", "42101"]

region_df = df.loc[df["fips"].isin(region_fips)]

print(region_df)
