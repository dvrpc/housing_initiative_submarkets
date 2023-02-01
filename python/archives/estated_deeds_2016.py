# Author: Brian Carney
# Purpose: This script evaluates sample property sale prices and transactions in 2016.

import pandas as pd
import openpyxl
import seaborn as sns
import matplotlib.pyplot as plt

# Transactions
estated_transactions = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\Estated Sample Data\Montgomery County\deeds.csv",
    dtype={"fips": str, "apn": str, "document_type": str, "sale_price": float},
    low_memory=False,
)


estated_transactions["recording_date"] = pd.to_datetime(
    estated_transactions["recording_date"], format="%Y-%m-%d"
)


# Select 2016 transactions
estated_transactions_2016 = estated_transactions.loc[
    (estated_transactions["recording_date"] >= "2016-01-01")
    & (estated_transactions["recording_date"] <= "2016-12-31")
]


estated_transactions_2016 = estated_transactions_2016[
    ["fips", "apn", "sale_price", "recording_date", "document_type"]
]
estated_transactions_2016 = estated_transactions_2016.set_index("apn")

estated_transactions_2016["sale_price"].describe().apply(lambda x: format(x, "f"))
# Note: Massive outliers.


estated_null_sale_price = estated_transactions_2016.loc[
    estated_transactions_2016["sale_price"].isnull()
]
# print(len(estated_null_sale_price))
# Note: "sale_price" is null for 4,145 records.

"""
sns.boxplot(x=estated_transactions_2016["sale_price"])
plt.show()
# Note: will get back to this later once outliers have been dealt with.
"""


# High Values
# print(len(estated_transactions_2016.loc[estated_transactions_2016["sale_price"] >= 5000000]))
# Note: To know how many high "MORTGAGE" or "PRICE" values there are. 8 records where the sale price is greater than or equal to $5M.


# Summary stats when dropping high values
estated_2016_drop_outliers = estated_transactions_2016.loc[
    estated_transactions_2016["sale_price"] < 5000000
]
# print(estated_2016_drop_outliers["sale_price"].describe().apply(lambda x: format(x, "f")))


# Import property dataset
addresses = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\Estated Sample Data\Montgomery County\addresses.csv",
    dtype={"apn": str, "census_tract": str, "fips": str},
    index_col="apn",
)
addresses = addresses[["census_tract"]]

estated_residential_2016_properties = estated_2016_drop_outliers.merge(
    addresses, how="inner", left_index=True, right_index=True
)


estated_2016_properties = estated_residential_2016_properties[["census_tract", "sale_price"]]
estated_2016_properties_grouped = estated_residential_2016_properties.groupby(
    "census_tract"
).median()

estated_2016_properties_grouped.to_csv(
    r"C:\Users\bcarn\OneDrive\Desktop\test_results\estated_median_by_tract_2016.csv"
)


estated_2016_properties_counted = estated_residential_2016_properties.groupby(
    "census_tract"
).count()
estated_2016_properties_counted.to_csv(
    r"C:\Users\bcarn\OneDrive\Desktop\test_results\estated_count_by_tract_2016.csv"
)
# Census Tracts are a mess. Have to fix to get a proper groupby.
