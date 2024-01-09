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
    "U:/FY2022/Planning/RegionalHousingInitiative/SubmarketAnalysis/data/submarket_inputs_countysummary.csv"
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

# TWG 2021
twg_2021 = pd.read_sql(
    """select "FIPS", "STATE", "COUNTY", "PRICE" from twg.twg_deeds_2021 where "PRICE" > 50000 and "DEEDTYPE" in ('14', '15', '27', '55') and "PROPUSE" in (1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009);
                       """,
    housing_engine,
)

twg_2021 = twg_2021[["FIPS", "PRICE"]]
twg_2021 = twg_2021.rename(columns={"PRICE": "PRICE_21"})
twg_2021["FIPS"] = twg_2021["FIPS"].astype(str)

twg_2021_county_medians = twg_2021.groupby("FIPS").median()

# TWG 2016
twg_2016 = pd.read_sql(
    """select "FIPS", "STATE", "COUNTY", "PRICE" from twg.twg_deeds_2016 where "PRICE" > 50000 and "DEEDTYPE" in ('14', '15', '27', '55') and "PROPUSE" in (1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009);
                       """,
    housing_engine,
)

twg_2016 = twg_2016[["FIPS", "PRICE"]]
twg_2016 = twg_2016.rename(columns={"PRICE": "PRICE_16"})
twg_2016["FIPS"] = twg_2016["FIPS"].astype(str)

twg_2016_county_medians = twg_2016.groupby("FIPS").median()
twg_2016_county_medians["PRICE_IA"] = twg_2016_county_medians["PRICE_16"] * 1.1273

# Join TWG Data
twg = pd.merge(
    twg_2021_county_medians, twg_2016_county_medians, left_index=True, right_index=True
)

twg["PRICE_IA_CHG"] = round((twg["PRICE_21"] - twg["PRICE_IA"]) / twg["PRICE_IA"], 3)
twg["PRICE_CHG"] = round((twg["PRICE_21"] - twg["PRICE_16"]) / twg["PRICE_16"], 3)

# NHPD Data
nhpd = pd.read_sql(
    """select "County Code", "Total Units", "S8_1_AssistedUnits", "S8_2_AssistedUnits", "LIHTC_1_AssistedUnits", "LIHTC_2_AssistedUnits", "PH_1_AssistedUnits", "PH_2_AssistedUnits" from nhpd.region_properties_ph_s8_lihtc;
                       """,
    housing_engine,
)


nhpd["County Code"] = nhpd["County Code"].astype(str)
nhpd["County Code"] = nhpd["County Code"].str.slice(0, 5)

nhpd = nhpd.fillna(value=0)

nhpd["S8_1_AssistedUnits"] = nhpd["S8_1_AssistedUnits"].astype(int)


columns = [
    "S8_1_AssistedUnits",
    "S8_2_AssistedUnits",
    "LIHTC_1_AssistedUnits",
    "LIHTC_2_AssistedUnits",
    "PH_1_AssistedUnits",
    "PH_2_AssistedUnits",
]


def column_types(column):
    for column in columns:
        nhpd[column] = nhpd[column].astype(int)


column_types(columns)

nhpd["subsidized_units"] = (
    nhpd["S8_1_AssistedUnits"]
    + nhpd["S8_2_AssistedUnits"]
    + nhpd["LIHTC_1_AssistedUnits"]
    + nhpd["LIHTC_2_AssistedUnits"]
    + nhpd["PH_1_AssistedUnits"]
    + nhpd["PH_2_AssistedUnits"]
)

nhpd = nhpd.groupby("County Code").sum()

nhpd = nhpd[["subsidized_units"]]

subsidized = pd.merge(nhpd, housing_density, left_index=True, right_on="fips")

subsidized["pct_subsidized"] = round(
    subsidized["subsidized_units"] / subsidized["UNITS_TOT"], 3
)

subsidized = subsidized.drop(columns=["UNITS_TOT"])

# Join subsidized and twg
sub_twg = pd.merge(subsidized, twg, left_on="fips", right_index=True)


# Join with housing density
density = housing_density_join[["fips", "hu_acre"]]

sub_twg_density = pd.merge(sub_twg, density, left_on="fips", right_on="fips")

# Join with census
submarket_inputs_counties = pd.merge(
    census, sub_twg_density, left_on="county", right_on="county"
)

submarket_inputs_counties.set_index("county", inplace=True)

# Import spatial data
county_shape = pd.read_sql(
    """select geoid, shape from demographics.census_counties_2020 where geoid in ('34005', '34007', '34015', '34021', '42017', '42029', '42045', '42091', '42101')
                    """,
    gis_engine,
)


submarket_inputs_counties.to_csv(
    "U:/FY2022/Planning/RegionalHousingInitiative/SubmarketAnalysis/data/v1/submarkets_inputs_counties.csv"
)
