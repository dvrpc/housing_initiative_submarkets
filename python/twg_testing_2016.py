# Author: Brian Carney
# Purpose: This script evaluates sample property sale prices and transactions in 2016.

import pandas as pd
import openpyxl
import seaborn as sns
import matplotlib.pyplot as plt

# Transactions
twg_transactions = pd.read_csv(
    "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\TWG Sample Data\Montgomery County\\DVRPCTransactions.txt",
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

# Select 2016 transactions
twg_transactions_2016 = twg_transactions.loc[
    (twg_transactions["DATE"] >= "2016-01-01")
    & (twg_transactions["DATE"] <= "2016-12-31")
]

twg_total_transactions_2016 = len(twg_transactions_2016)


# Select particular PROPUSE
twg_residential_propuse_2016 = twg_transactions_2016.loc[
    twg_transactions_2016["PROPUSE"].isin(
        ["1000", "1001", "1002", "1003", "1004", "1005", "1006", "1007", "1008"]
    )
]

twg_total_residential_propuse_2016 = len(twg_residential_propuse_2016)
# print(twg_total_residential_propuse_2016)
# print("36,048 records in 2016 with PROPUSE from "1000" to "1008")

# Figure out DEEDTYPE
twg_deedtype_grouped_df = twg_residential_propuse_2016[["DEEDTYPE"]]
twg_deedtype_grouped_df["Total"] = ""
twg_deedtype_grouped = (
    twg_deedtype_grouped_df.groupby("DEEDTYPE")
    .count()
    .sort_values(by="Total", ascending=False)
)

twg_residential_TRANID = twg_residential_propuse_2016[["TRANID", "SALETYPE"]]
twg_residential_null_SALETYPE = twg_residential_TRANID.loc[
    twg_residential_TRANID["SALETYPE"].isnull()
]
# print(len(twg_residential_null_SALETYPE))
# Of the 36,048 records, 19,115 (53 percent) do not have a SALETYPE value.


# Testing DFs
standalone = twg_residential_propuse_2016.loc[
    twg_residential_propuse_2016["DEEDTYPE"] == "93"
]
print(len(standalone))
no_sale_price = twg_residential_propuse_2016.loc[
    (twg_residential_propuse_2016["PRICE"].isnull())
    & (twg_residential_propuse_2016["DEEDTYPE"] == "93")
]
print(no_sale_price[["MORTGAGE"]])
