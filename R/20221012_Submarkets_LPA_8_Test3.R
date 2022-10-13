# Last updated: 10/12/2022
# Purpose: This script runs a Latent Profile Analysis clustering algorithm on data inputs used for the Regional Housing Initiative submarkets.

# Set working directory
setwd("C:\\Users\\bcarney\\Documents\\GitHub\\housing_initiative_submarkets\\R")

# Install Packages
# install.packages("tidyLPA")
# install.packages("magrittr")
# install.packages("matrixStats")
# install.packages("textshape")
# install.packages("tidyr")


# Import libraries
library(tidyLPA)
library(dplyr)
library(magrittr)
library(matrixStats)
library(textshape)
library(tidyr)


# Import data
acs2020_raw <- read.csv("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\acs5_2020_variables.csv", colClasses = c("GEOID"="character"))

mediansaleprice_subsidizedhousing <- read.csv("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\region_tracts_mediansaleprice_subsidizedhousingunits.csv", colClasses = c("geoid"="character")) %>%
  rename(subsidizedunits = region_subsidizedhousing_unitsbytract_Total.Subsidized.Units) %>%
  mutate(subsidizedunits = ifelse(is.na(subsidizedunits), 0, subsidizedunits))

# Join dataframes
joined_df <- merge(acs2020_raw, mediansaleprice_subsidizedhousing, by.x="GEOID", by.y="geoid") %>%
  drop_na(med16, med21) %>%
  filter(HH_TOT > 0) %>%
  mutate(pct_subsidized = round((subsidizedunits/UNITS_TOT) * 100, 2)) %>%
  column_to_rownames(., "GEOID")


myVars <- c("HHINC_MED", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "pct_subsidized", "med21", "pct_diff", "HHS_1", "HHS_2to4", "HHS_5P", "hu_acre")
myVars_Class <- c("HHINC_MED", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "pct_subsidized", "med21", "pct_diff", "HHS_1", "HHS_2to4", "HHS_5P", "hu_acre", "Class")

tracts <- row.names(joined_df_clean)

joined_df_clean <- joined_df %>%
  select(all_of(myVars)) %>%
  mutate_if(is.numeric, function(x) ifelse(is.na(x), median(x, na.rm = T), x))

joined_df_clean_medians <- joined_df_clean %>%
  apply(., 2, median)


print(joined_df_clean_medians)

# Export 1
e1 <- joined_df_clean %>%
  estimate_profiles(8)

export_1 <- get_data(e1)


# Subset columns
reduced_df <- export_1[myVars_Class]

# Append index
rownames(reduced_df) <- tracts

# Write csv
write.csv(reduced_df, "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\LPA_Test3_Submarkets\\lpa_results_3_submarkets.csv", row.names = TRUE)

# Group by cluster and get median
submarket_medians <- aggregate(reduced_df, by = list(reduced_df$Class), FUN = "median")%>%
  subset(select = -c(Group.1))

# Export cluster medians
write.csv(submarket_medians, "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\LPA_Test3_Submarkets\\cluster_medians.csv")
