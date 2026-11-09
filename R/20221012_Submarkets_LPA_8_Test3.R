# Last updated: 09/22/2026
# Purpose: This script runs a Latent Profile Analysis clustering algorithm on data inputs used for the Regional Housing Initiative submarkets.

# Set working directory
setwd("C:\\Users\\bcarney\\Documents\\GitHub\\housing_initiative_submarkets\\R")

# Install Packages
# install.packages("tidyLPA")
# install.packages("magrittr")
# install.packages("matrixStats")
# install.packages("textshape")
# install.packages("tidyr")
# install.packages("mclust")
# install.packages("sf")
# install.packages("terra")
install.packages("tigris")


# Import libraries
library(tidyLPA)
library(mclust)
library(dplyr)
library(magrittr)
library(matrixStats)
library(textshape)
library(tidyr)
library(sf)
library(terra)
library(tigris)

# Disable scientific notation
options(scipen = 999)

# Import data
acs2024_raw <- read.csv("U:\\FY2027\\Planning\\HousingSubmarkets\\project_input\\acs5_2024_variables.csv", colClasses = c("GEOID"="character"))

mediansaleprice_subsidizedhousing <- read.csv("U:\\FY2027\\Planning\\HousingSubmarkets\\project_input\\region_tracts_mediansaleprice_subsidizedhousingunits_20212025.csv", colClasses = c("geoid"="character", "med25"="numeric")) %>%
  rename(subsidizedunits = Total.Subsidized.Units) %>%
  mutate(subsidizedunits = ifelse(is.na(subsidizedunits), 0, subsidizedunits)) %>%
  select(geoid, subsidizedunits, med25, pct_diff)

# Join dataframes
joined_df <- merge(acs2024_raw, mediansaleprice_subsidizedhousing, by.x="GEOID", by.y="geoid") %>%
  # drop_na(med21) %>%
  filter(HH_TOT >= 50) %>%
  mutate(pct_subsidized = round((subsidizedunits/UNITS_TOT) * 100, 2)) %>%
  column_to_rownames(., "GEOID")


myVars <- c("HHINC_MED", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "pct_subsidized", "med25", "pct_diff", "HHS_1", "HHS_2to4", "HHS_5P", "hu_acre")
myVars_model <- c("HHINC_MED", "RENT_MED", "TEN_OWN", "VCY", "YB_59E", "YB_00L", "UNIT_1", "UNIT_2to4", "pct_subsidized", "med25", "pct_diff", "HHS_2to4", "HHS_5P", "hu_acre", "Class")
myVars_all <- c("GEOID", "HHINC_MED", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "pct_subsidized", "med25", "pct_diff", "HHS_1", "HHS_2to4", "HHS_5P", "hu_acre", "Class")

tracts <- row.names(joined_df)

joined_df_clean <- joined_df %>%
  select(all_of(myVars)) %>%
  mutate_if(is.numeric, function(x) ifelse(is.na(x), median(x, na.rm = T), x))

joined_df_clean_medians <- joined_df_clean %>%
  apply(., 2, median)

# Export 1
e1 <- joined_df_clean %>%
  select(-TEN_RENT, -HHI_150P, -YB_6099, -UNIT_5P, -HHS_1) %>%
   estimate_profiles(8)


export_1 <- get_data(e1)
 
# Dropped column df
dropped_fields <- joined_df_clean %>%
  tibble::rownames_to_column("GEOID") %>%
  select(GEOID, TEN_RENT, HHI_150P, YB_6099, UNIT_5P, HHS_1)

# Subset columns
reduced_df <- export_1[myVars_model]

# Append index
rownames(reduced_df) <- tracts

final_table <- reduced_df %>%
  tibble::rownames_to_column("GEOID") %>%
  left_join(., dropped_fields, by="GEOID") %>%
  .[,myVars_all]

# Create table with tracts and submarkets
tract_submarket_table <- final_table %>%
  select("Class")

rownames(tract_submarket_table) <- tracts

pa_tracts <- tracts("42", c("017", "029", "045", "091", "101"))
nj_tracts <- tracts("34", c("005", "007", "015", "021"))

region_tracts <- bind_rows(pa_tracts, nj_tracts) %>% st_transform(26918)

submarkets_table <- region_tracts %>%
  left_join(., final_table, by="GEOID") %>%
  select(-STATEFP, -COUNTYFP, -TRACTCE, -NAMELSAD, -MTFCC, -FUNCSTAT, -ALAND, -AWATER, -INTPTLAT, -INTPTLON)

vect_shapefile <- vect(submarkets_table)
writeVector(
  vect_shapefile,
  file.path("U:\\FY2027\\Planning\\HousingSubmarkets\\project_input\\submarkets.shp"),
  filetype = "ESRI Shapefile",
  overwrite = TRUE
)

# Write csv
write.csv(final_table, "U:\\FY2027\\Planning\\HousingSubmarkets\\project_input\\lpa_results_submarkets.csv", row.names = FALSE)

write.csv(tract_submarket_table, "U:\\FY2027\\Planning\\HousingSubmarkets\\project_input\\tracts_submarkets.csv", row.names = TRUE)


# Group by cluster and get median
submarket_medians <- aggregate(final_table, by = list(final_table$Class), FUN = "median")%>%
  subset(select = -c(Group.1)) %>%
  select(-GEOID)

# Export cluster medians
write.csv(submarket_medians, "U:\\FY2027\\Planning\\HousingSubmarkets\\project_input\\cluster_medians.csv")

# compare_solutions(etest, statistics= c("AIC", "BIC"))


#suppressMessages(mod_1c_v1 <- estimate_profiles(df = joined_df_clean[1:19], n_profiles = 1:20,
#                                               models = 1))