# Author: Brian Carney
# Purpose: This script evaluates sample property sale prices and transactions in 2021.

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

# Select 2021 transactions
twg_transactions_2021 = twg_transactions.loc[
    (twg_transactions["DATE"] >= "2021-01-01")
    & (twg_transactions["DATE"] <= "2021-12-31")
]

twg_total_transactions_2021 = len(twg_transactions_2021)


# Select particular PROPUSE
twg_residential_propuse_2021 = twg_transactions_2021.loc[
    twg_transactions_2021["PROPUSE"].isin(
        ["1000", "1001", "1002", "1003", "1004", "1005", "1006", "1007", "1008"]
    )
]

twg_total_residential_propuse_2021 = len(twg_residential_propuse_2021)
print(twg_total_residential_propuse_2021)
# print("50,461 records in 2021 with PROPUSE from "1000" to "1008")

# Figure out DEEDTYPE
twg_deedtype_grouped_df = twg_residential_propuse_2021[["DEEDTYPE"]]
twg_deedtype_grouped_df["Total"] = ""
twg_deedtype_grouped = (
    twg_deedtype_grouped_df.groupby("DEEDTYPE")
    .count()
    .sort_values(by="Total", ascending=False)
)
print(twg_deedtype_grouped)
