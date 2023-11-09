import pandas as pd
from sqlalchemy import create_engine
from settings import census_api, postgres_pw, gis_pw

gis_engine = create_engine(
    "postgresql://dvrpc_viewer:{}@gis-db:5432/gis".format(gis_pw)
)

twg_engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)


# Import county summary file (Census)
census = pd.read_csv(
    "U:/FY2022/Planning/RegionalHousingInitiative/SubmarketAnalysis/data/submarket_inputs_countysummary.csv"
)
print(census)


# Import aland
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


twg_2021 = pd.read_sql(
    """select * from twg.twg_deeds_2021;
                       """,
    twg_engine,
)

print(twg_2021)
