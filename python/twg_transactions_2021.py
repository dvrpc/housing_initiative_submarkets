# Author: Brian Carney
# Purpose: This script evaluates sample property sale prices and transactions in 2021.

import pandas as pd
import openpyxl
import seaborn as sns
import matplotlib.pyplot as plt

# Transactions
twg_transactions = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt",
    dtype={
        "PROPID": str,
        "DEEDTYPE": str,
        "SALETYPE": str,
        "PROPUSE": str,
        "MTGTYPE": str,
        "PROPUSE": str,
        "DATE": str,
        "FIPS": str,
    },
    sep="\t",
    low_memory=False,
)

twg_transactions["DATE"] = pd.to_datetime(twg_transactions["DATE"], format="%Y%m%d")

twg_transactions["PROPID"] = twg_transactions["PROPID"].str.replace("TRAN", "PROP")

# Select 2021 transactions
twg_transactions_2021 = twg_transactions.loc[
    (twg_transactions["DATE"] >= "2021-01-01") & (twg_transactions["DATE"] <= "2021-12-31")
]

"""
# Summary stats for 2021 universe
twg_transactions_2021 = twg_transactions_2021[["FIPS", "PRICE", "PROPUSE", "DATE", "MORTGAGE"]]
print(twg_transactions_2021["MORTGAGE"].describe().apply(lambda x: format(x, "f")))
print(twg_transactions_2021["PRICE"].describe().apply(lambda x: format(x, "f")))
# Note: There are massive outliers here. Non-residential transactions (most likely).
"""

"""
# Identifying most common PROPUSE in 2021 dataset
twg_PROPUSE_2021 = twg_transactions_2021[["PROPUSE"]]
twg_PROPUSE_2021["COUNT"] = ""
twg_PROPUSE_grouped_2021 = twg_PROPUSE_2021.groupby("PROPUSE").count()
print(twg_PROPUSE_grouped_2021.sort_values(by=["COUNT"], ascending=False))
# Note: Found the most common PROPUSE codes
"""

"""
twg_transactions_2021 = twg_transactions_2021[["MORTGAGE"]]
twg_transactions_2021["COUNT"] = ""
twg_mortgage_2021_grouped = twg_transactions_2021.groupby("MORTGAGE").count()
print(twg_mortgage_2021_grouped)
# Note: Ran this groupby to get the number of records where "MORTGAGE" = 0.0
"""


# Select particular PROPUSE
twg_residential_propuse_2021 = twg_transactions_2021.loc[
    twg_transactions_2021["PROPUSE"].isin(["1001", "8001", "1004", "1002", "1101"])
]

"""
print(twg_residential_propuse_2021["PRICE"].describe().apply(lambda x: format(x, "f")))
print(twg_residential_propuse_2021["MORTGAGE"].describe().apply(lambda x: format(x, "f")))
"""

"""
sns.boxplot(x=twg_residential_propuse_2021["MORTGAGE"])
plt.show()
# Note: will get back to this later once outliers have been dealt with.
"""

"""
# High Values
print(len(twg_residential_propuse_2021.loc[(twg_residential_propuse_2021["PRICE"] >= 5000000) | (twg_residential_propuse_2021["MORTGAGE"] >= 5000000)]))
# Note: To know how many high "MORTGAGE" or "PRICE" values there are
"""


# Summary stats when dropping high values
twg_residential_propuse_2021_drop_outliers = twg_residential_propuse_2021.loc[
    (twg_residential_propuse_2021["PRICE"] <= 5000000)
    & (twg_residential_propuse_2021["MORTGAGE"] <= 5000000)
]

"""
print(
    twg_residential_propuse_2021_drop_outliers["PRICE"].describe().apply(lambda x: format(x, "f"))
)
print(
    twg_residential_propuse_2021_drop_outliers["MORTGAGE"]
    .describe()
    .apply(lambda x: format(x, "f"))
)
"""

"""
# Group by FIPS and then get summary stats
twg_residential_2021_mortgage_grouping = twg_residential_propuse_2021_drop_outliers[
    ["FIPS", "MORTGAGE"]
]
twg_mortgage_2021_grouped_tract = twg_residential_2021_mortgage_grouping.groupby("FIPS").median()
print(twg_mortgage_2021_grouped_tract)
"""

# Import property dataset
properties = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCProperties.txt",
    dtype={"PROPID": str, "CNSSTRACT": str, "FIPS": str},
    sep="\t",
    index_col="PROPID",
)


# Join two datasets
properties = properties[["CNSSTRACT"]]
twg_residential_propuse_2021_drop_outliers = twg_residential_propuse_2021_drop_outliers.set_index(
    "PROPID"
)
twg_residential_2021_properties = twg_residential_propuse_2021_drop_outliers.merge(
    properties, how="inner", left_index=True, right_index=True
)


twg_residential_2021_properties["TRACT_FULL"] = (
    twg_residential_2021_properties["FIPS"] + twg_residential_2021_properties["CNSSTRACT"]
)
twg_residential_2021_properties = twg_residential_2021_properties[
    ["TRACT_FULL", "MORTGAGE", "PRICE"]
]
twg_residential_2021_properties_grouped = twg_residential_2021_properties.groupby(
    "TRACT_FULL"
).median()

twg_residential_2021_properties_grouped.to_csv(
    r"C:\Users\bcarn\OneDrive\Desktop\test_results\twg_median_by_tract_2021.csv"
)


twg_residential_2021_properties_counted = twg_residential_2021_properties.groupby(
    "TRACT_FULL"
).count()
twg_residential_2021_properties_counted.to_csv(
    r"C:\Users\bcarn\OneDrive\Desktop\test_results\twg_count_by_tract_2021.csv"
)
