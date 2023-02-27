# Import packages
import pandas as pd

from clustering import clusters_df

# Import ACS Estimates Dataframe
acs2020 = pd.read_csv(
    "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\ACS5_2020\\acs5_2020_variables.csv",
    dtype={"GEOID": str},
    index_col="GEOID",
)

acs2020 = acs2020.drop(
    ["year", "POP_TOT", "HH_TOT", "UNIT_MIS", "HHI_U35", "HHI_75100", "HHI_100P", "THREE_BR"],
    axis=1,
)

# Join Dataframes
acs2020_joined = acs2020.merge(clusters_df, how="inner", left_index=True, right_index=True)


# Calculate Median
acs2020_median = acs2020_joined.groupby("cluster").median()


print(acs2020_median)

# Export Median Dataframe to CSV
acs2020_median.to_csv(
    "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\kmedoid_test_1\\acs2020_median.csv"
)
