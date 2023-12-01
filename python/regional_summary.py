import pandas as pd
import numpy as np
import geopandas
from sqlalchemy import create_engine
from settings import postgres_pw, gis_pw


gis_engine = create_engine(
    "postgresql://dvrpc_viewer:{}@gis-db:5432/gis".format(gis_pw)
)

housing_engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)


# Import county summary file (Census)
census = pd.read_csv(
    "U:/FY2022/Planning/RegionalHousingInitiative/SubmarketAnalysis/data/v1/submarket_inputs_countysummary.csv"
)


# Import county area
county_area = pd.read_sql(
    """select geoid, aland from demographics.census_counties_2020 where geoid in ('34005', '34007', '34015', '34021', '42017', '42029', '42045', '42091', '42101')
                    """,
    gis_engine,
)

county_area["acres"] = round(county_area["aland"] * 0.000247105, 1)

county_lookup = {
    "fips": [
        "34005",
        "34007",
        "34015",
        "34021",
        "42017",
        "42029",
        "42045",
        "42091",
        "42101",
    ],
    "fips_name": [
        "Burlington",
        "Camden",
        "Gloucester",
        "Mercer",
        "Bucks",
        "Chester",
        "Delaware",
        "Montgomery",
        "Philadelphia",
    ],
}
county_lookup_table = pd.DataFrame(data=county_lookup)

# Calculate Housing Unit Density
census_housing = census[["county", "UNITS_TOT"]]

housing_density = pd.merge(
    census_housing, county_lookup_table, left_on="county", right_on="fips_name"
)

housing_density = housing_density[["county", "fips", "UNITS_TOT"]]

housing_density_join = pd.merge(
    housing_density, county_area, left_on="fips", right_on="geoid"
)


housing_density_join["hu_acre"] = round(
    (housing_density_join["UNITS_TOT"] / housing_density_join["acres"]), 2
)

print(housing_density_join)
