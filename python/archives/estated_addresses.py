# Author: Brian Carney
# Purpose: This script evaluates a sample addresses dataset from Estated.

import pandas as pd

# Import dataset
estated_addresses = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\Estated Sample Data\Montgomery County\addresses.csv",
    dtype={"fips": str, "apn": str, "census_tract": str},
    low_memory=False,
)

estated_addresses = estated_addresses[["fips", "apn", "census_tract"]]


estated_addresses["fips_left"] = estated_addresses["census_tract"].str.slice(stop=9)
estated_addresses["fips_right"] = estated_addresses["census_tract"].str.slice(start=10, stop=12)

"""
print(
    len(
        estated_addresses.loc[
            (estated_addresses["fips_left"].isnull()) | (estated_addresses["fips_right"].isnull())
        ]
    )
)
# 456 records where the FIPS code is null
"""

# Check for bad FIPS/tract values
estated_bad_addresses = estated_addresses.loc[
    ~estated_addresses["census_tract"].str.startswith("42091", na=False)
]
print(estated_bad_addresses)
# 4,538 records with bad census tract (does not start with "42091")

# Create tract_full column
estated_addresses["tract_full"] = estated_addresses["fips_left"] + estated_addresses["fips_right"]
estated_addresses = estated_addresses.loc[estated_addresses["tract_full"].notnull()]
estated_addresses = estated_addresses.set_index("apn")
