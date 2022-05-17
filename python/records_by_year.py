# Author: Brian Carney
# Purpose: This script evaluates a sample deeds dataset from Estated.

from ast import parse
import pandas as pd


# TWG
twg_transactions = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt",
    dtype={
        "DEEDTYPE": str,
        "SALETYPE": str,
        "PROPUSE": str,
        "MTGTYPE": str,
        "DATE": str,
    },
    sep="\t",
    low_memory=False,
)


twg_transactions = twg_transactions[["DATE"]]


twg_transactions["DATE"] = pd.to_datetime(twg_transactions["DATE"], format="%Y%m%d")
twg_grouped = twg_transactions.groupby(twg_transactions.DATE.dt.year).count()
twg_grouped = twg_grouped.rename(columns={"DATE": "COUNT"})
print(twg_grouped)

# Estated
estated_deeds = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\Estated Sample Data\Montgomery County\deeds.csv",
    dtype={"fips": str, "apn": str, "document_type": str, "recording_date": str},
    low_memory=False,
)


estated_deeds = estated_deeds[["recording_date"]]


estated_deeds["recording_date"] = pd.to_datetime(
    estated_deeds["recording_date"], format="%Y-%m-%d"
)


estated_grouped = estated_deeds.groupby(estated_deeds.recording_date.dt.year).count()
estated_grouped = estated_grouped.rename(columns={"recording_date": "COUNT"})
print(estated_grouped)
