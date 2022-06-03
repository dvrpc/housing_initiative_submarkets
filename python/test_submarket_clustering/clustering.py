# Import packages
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from sklearn_extra.cluster import KMedoids
from sklearn.preprocessing import MinMaxScaler
from sklearn.impute import SimpleImputer


# Import data
acs2020 = pd.read_csv(
    "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\ACS5_2020\\acs5_2020_variables.csv",
    dtype={"GEOID": str},
    index_col="GEOID",
)


index = acs2020.index.astype(str)


acs2020 = acs2020.drop(["year", "POP_TOT", "HH_TOT", "UNIT_MIS"], axis=1)

nan = np.nan
imp = SimpleImputer(missing_values=np.nan, strategy="median")
imp.fit(acs2020)
acs2020_imp = imp.transform(acs2020)


min_max_scaler = MinMaxScaler()
acs2020_minmax = min_max_scaler.fit_transform(acs2020_imp)


# Cluster
kmedoids = KMedoids(n_clusters=8, init="build", method="pam").fit(acs2020_minmax)


# Convert back to df
df = pd.DataFrame(
    acs2020_minmax,
    columns=[
        "HHINC_MED",
        "MED_HVAL",
        "RENT_MED",
        "TEN_RENT",
        "TEN_OWN",
        "VCY",
        "HHI_U35",
        "HHI_3575",
        "HHI_75100",
        "HHI_100P",
        "HHI_150P",
        "THREE_BR",
        "YB_59E",
        "YB_6099",
        "YB_00L",
        "UNIT_1",
        "UNIT_2to4",
        "UNIT_5P",
    ],
)

cluster = kmedoids.labels_
df["cluster"] = cluster.tolist()
df = df.set_index(index)


# Rename Clusters
df["cluster"] = df["cluster"].replace(
    [0, 1, 2, 3, 4, 5, 6, 7], [1, 2, 3, 4, 5, 6, 7, 8]
)
print(df)

df.to_csv(
    "G:\\Shared drives\\FY22 Regional Housing Initiative\\SubmarketAnalysis\\test_submarket_clustering\data\\acs2020_clusters.csv"
)

clusters_df = df[["cluster"]]

# Join clusters back with original ACS data
acs2020_clusters = clusters_df.merge(
    acs2020, how="inner", left_index=True, right_index=True
)
acs2020_clusters.to_csv(
    "U:\\FY2022\\Planning\\RegionalHousingInitiative\\data\\acs2020_clusters.csv"
)
