# Author: Brian Carney
# Purpose: This script evaluates a sample deeds dataset from Estated.

import pandas as pd

# Import dataset
parcels = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\Estated Sample Data\Montgomery County\parcels.csv",
    dtype={"fips": str, "apn": str},
    low_memory=False,
)
print(list(parcels))

parcels["total"] = ""

parcels = parcels[["standardized_land_use_category", "total"]]
grouped = parcels.groupby("standardized_land_use_category").count()
print(grouped)
