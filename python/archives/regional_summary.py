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

regional_summary = pd.read_csv(
    "U:/FY2022/Planning/RegionalHousingInitiative/SubmarketAnalysis/data/v1/submarket_inputs_regionalsummary.csv"
)

regional_totals = regional_summary[
    [
        "POP_TOT",
        "HH_TOT",
        "UNITS_TOT",
        "UNITS_OCC",
        "UNITS_VAC",
        "TEN_TOT",
        "TEN_O",
        "TEN_R",
        "UNITS_STR",
        "UNIT_1DET",
        "UNIT_1ATT",
        "UNIT_2",
        "UNIT_3or4",
        "UNIT_5to9",
        "UNIT_1019",
        "UNIT_2049",
        "UNIT_50P",
        "UNIT_MOB",
        "YB_39E",
        "YB_40to49",
        "YB_50to59",
        "YB_60to69",
        "YB_70to79",
        "YB_80to89",
        "YB_90to99",
        "YB_00to09",
        "YB_10to13",
        "YB_14L",
    ]
]

regional_totals = regional_totals.sum(axis=0)


pct_owner = round(regional_totals["TEN_O"] / regional_totals["TEN_TOT"], 3)
pct_renter = round(regional_totals["TEN_R"] / regional_totals["TEN_TOT"], 3)

vcy_rate = round(regional_totals["UNITS_VAC"] / regional_totals["UNITS_TOT"], 3)

unit_1det = round(regional_totals["UNIT_1DET"] / regional_totals["UNITS_STR"], 3)
unit_1att = round(regional_totals["UNIT_1ATT"] / regional_totals["UNITS_STR"], 3)
unit_2 = round(regional_totals["UNIT_2"] / regional_totals["UNITS_STR"], 3)
unit_3or4 = round(regional_totals["UNIT_3or4"] / regional_totals["UNITS_STR"], 3)
unit_5to9 = round(regional_totals["UNIT_5to9"] / regional_totals["UNITS_STR"], 3)
unit_1019 = round(regional_totals["UNIT_1019"] / regional_totals["UNITS_STR"], 3)
unit_2049 = round(regional_totals["UNIT_2049"] / regional_totals["UNITS_STR"], 3)
unit_50p = round(regional_totals["UNIT_50P"] / regional_totals["UNITS_STR"], 3)
unit_mob = round(regional_totals["UNIT_MOB"] / regional_totals["UNITS_STR"], 3)

"""
print(unit_1det)
print(unit_1att)
print(unit_2)
print(unit_3or4)
print(unit_5to9)
print(unit_1019)
print(unit_2049)
print(unit_50p)
print(unit_mob)
"""


region_area = county_area["acres"].sum()

region_housing_density = round(regional_totals["UNITS_TOT"] / region_area, 2)

print(region_housing_density)
print(region_area)
