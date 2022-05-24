# Author: Brian Carney
# Purpose: This script evaluates sample transactions dataset from The Warren Group.

from numpy import index_exp
import pandas as pd
import openpyxl

# Transactions
twg_transactions = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt",
    dtype={
        "SOURCE": str,
        "DEEDTYPE": str,
        "SALETYPE": str,
        "PROPUSE": str,
        "MTGTYPE": str,
        "PROPUSE": str,
        "FIPS": str,
    },
    sep="\t",
    low_memory=False,
)


# Convert to datetime
twg_transactions["DATE"] = pd.to_datetime(twg_transactions["DATE"], format="%Y%m%d")


# Convert PROPID
twg_transactions["PROPID"] = twg_transactions["PROPID"].str.replace("TRAN", "PROP")

# Select 2021 transactions
twg_transactions_2021 = twg_transactions.loc[
    (twg_transactions["DATE"] >= "2021-01-01")
    & (twg_transactions["DATE"] <= "2021-12-31")
]


# Select only DEEDTYPE = "27" (Deed)
transactions_deeds_only_2021 = twg_transactions_2021.loc[
    twg_transactions_2021["DEEDTYPE"] == "27"
]

# Select particular PROPUSE
twg_residential_propuse_2021 = transactions_deeds_only_2021.loc[
    transactions_deeds_only_2021["PROPUSE"].isin(
        ["1001", "8001", "1004", "1002", "1101"]
    )
]


# Import property dataset
properties = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCProperties.txt",
    dtype={"PROPID": str, "CNSSTRACT": str, "FIPS": str},
    sep="\t",
    index_col="PROPID",
)


# Join two datasets
properties = properties[["CNSSTRACT"]]
twg_residential_propuse_2021 = twg_residential_propuse_2021.set_index("PROPID")
twg_residential_2021_properties = twg_residential_propuse_2021.merge(
    properties, how="inner", left_index=True, right_index=True
)


# Add TRACT_FULL (11 characters) field
twg_residential_2021_properties["TRACT_FULL"] = (
    twg_residential_2021_properties["FIPS"]
    + twg_residential_2021_properties["CNSSTRACT"]
)
twg_residential_2021_properties = twg_residential_2021_properties[
    ["TRACT_FULL", "MORTGAGE", "PRICE"]
]

# MEDIAN
twg_residential_2021_properties_grouped = twg_residential_2021_properties.groupby(
    "TRACT_FULL"
).median()


# Export to csv
twg_residential_2021_properties_grouped.to_csv(
    r"C:\Users\bcarn\OneDrive\Desktop\test_results_0519\twg_deeds_by_tract_median_2021.csv"
)

# COUNT
twg_residential_2021_properties_counted = twg_residential_2021_properties.groupby(
    "TRACT_FULL"
).count()


# Export to csv
twg_residential_2021_properties_counted.to_csv(
    r"C:\Users\bcarn\OneDrive\Desktop\test_results_0519\twg_deeds_by_tract_count_2021.csv"
)


print(
    twg_residential_2021_properties["MORTGAGE"]
    .describe()
    .apply(lambda x: format(x, "f"))
)
print(
    twg_residential_2021_properties["PRICE"].describe().apply(lambda x: format(x, "f"))
)
