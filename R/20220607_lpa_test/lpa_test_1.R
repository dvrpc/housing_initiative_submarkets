# Last updated: 06/10/2022
# Purpose: This script runs a Latent Profile Analysis clustering algorithm on ACS 2016-2020 5-Year Estimates as a test run for the Regional Housing Initiative.


# Install Packages
# install.packages("tidyLPA")
# install.packages("magrittr")
# install.packages("matrixStats")


# Import libraries
library(tidyLPA)
library(dplyr)
library(magrittr)
library(matrixStats)


# Import data
acs2020_raw <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\ACS5_2020\\acs5_2020_variables.csv", row.names = 1, header = TRUE)
acs2020$GEOID <- row.names(acs2020_raw)


myVars <- c("HHINC_MED", "MED_HVAL", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P")
myVars2 <- c("HHINC_MED", "MED_HVAL", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "Class")


acs2020 <- acs2020_raw[myVars]
tracts <- row.names(acs2020)


# Create dataframe with the median value for each field 
median <- apply(acs2020, 2, median, na.rm=TRUE)

acs2020_medians <- data.frame(median)

# Export dataframe
write.csv(acs2020_medians, "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\lpa_test_1\\acs2020_medians.csv")


# Imputing median value with NA 
for(i in colnames(acs2020))
  acs2020[,i][is.na(acs2020[,i])] <- all_column_median[i]

# Export 1
e1 <- acs2020 %>%
  estimate_profiles(8)

export_1 <- get_data(e1)


# Subset columns
reduced_df <- export_1[myVars2]

# Append index
rownames(reduced_df) <- tracts

# Write csv
write.csv(reduced_df, "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\lpa_test_1\\lpa_results_1.csv")

# Group by cluster and get median
acs2020_cluster_medians <- aggregate(reduced_df, by = list(reduced_df$Class), FUN = "median")%>%
  subset(select = -c(Group.1))

# Export cluster medians
write.csv(acs2020_cluster_medians, "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\lpa_test_1\\cluster_medians.csv")


# ----
# Test to see if the clusters are the same with another run through. they were the same.
# Export 2
m4 <- acs2020 %>%
  estimate_profiles(8)

export_2 <- get_data(m4)

# write.csv(export_2, "G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\lpa_test_1\\lpa_results_2.csv")
