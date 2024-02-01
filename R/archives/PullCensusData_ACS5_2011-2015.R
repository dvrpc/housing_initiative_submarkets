# Author: Brian Carney
# Last updated: 06/13/2023
# Prepared for: Region Housing Initiative - Submarket Clustering Analysis

# Set working directory
setwd("C:\\Users\\bcarney\\Documents\\GitHub\\housing_initiative_submarkets\\R")

#remove.packages("tidycensus")
#install.packages("tidycensus", dependencies = TRUE)

#remove.packages("dplyr")
#install.packages("dplyr", dependencies = TRUE)

# Install necessary packages
#install.packages("censusapi")
#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("rgdal")
#install.packages("tidycensus")
#update.packages("tidycensus")


# Load packages
library(tidyverse)
library(dplyr)
library(rgdal)
library(tidycensus)
library(censusapi)

# Load Census API key
census_api <- Sys.getenv("CENSUS_API_KEY")


# Region FIPS
fips_region <- c("34005", "34007", "34015", "34021", "42017", "42029", "42045", "42091", "42101")

# Variable List - For Reference
acs5_varlist_2015 <- load_variables(year = 2015,
                                    dataset = "acs5",
                                    cache = TRUE)


# ---- Define Variables ----
acs5_15_vars_tot <- c(
  ### POPULATION AND UNITS ###
  # Total Population (Total Population)
  POP_TOT = "B01003_001",
  # Total Households
  HH_TOT = "B11001_001",
  # Median Household Income
  HHINC_MED = "B19013_001",
  # Household Income Tiers,
  HHI_U10 = "B19001_002",
  HHI_1015 = "B19001_003",
  HHI_1520 = "B19001_004",
  HHI_2025 = "B19001_005",
  HHI_2530 = "B19001_006",
  HHI_3035 = "B19001_007",
  HHI_3540 = "B19001_008",
  HHI_4045 = "B19001_009",
  HHI_4550 = "B19001_010",
  HHI_5060 = "B19001_011",
  HHI_6075 = "B19001_012",
  HHI_75100 = "B19001_013",
  HHI_100125 = "B19001_014",
  HHI_125150 = "B19001_015",
  HHI_150200 = "B19001_016",
  HHI_200P = "B19001_017",
  # Occupancy Status (Housing Units)
  UNITS_TOT = "B25002_001",
  UNITS_OCC = "B25002_002",
  UNITS_VAC = "B25002_003",
  # Tenure (Occupied Housing Units)
  TEN_TOT = "B25003_001",
  TEN_O = "B25003_002",
  TEN_R = "B25003_003",
  ### HOUSING STOCK ###
  # Units in Structure (Occupied Housing Units)
  UNITS_STR = "B25024_001",
  UNIT_1DET = "B25024_002",
  UNIT_1ATT = "B25024_003",
  UNIT_2 = "B25024_004",
  UNIT_3or4 = "B25024_005",
  UNIT_5to9 = "B25024_006",
  UNIT_1019 = "B25024_007",
  UNIT_2049 = "B25024_008",
  UNIT_50P = "B25024_009",
  UNIT_MOB = "B25024_010",
  UNIT_OTH = "B25024_011",
  # Units in Structure (by Tenure)
  # Note: Must tabulate by tenure IOT return occupied (not total) housing units
  O_1DET = "B25032_003",
  O_1ATT = "B25032_004",
  O_2 = "B25032_005",
  O_3to4 = "B25032_006",
  O_5to9 = "B25032_007",
  O_10to19 = "B25032_008",
  O_20to49 = "B25032_009",
  O_50more = "B25032_010",
  R_1DET = "B25032_014",
  R_1ATT = "B25032_015",
  R_2 = "B25032_016",
  R_3to4 = "B25032_017",
  R_5to9 = "B25032_018",
  R_10to19 = "B25032_019",
  R_20to49 = "B25032_020",
  R_50more = "B25032_021",
  # Bedrooms (Occupied Housing Units)
  BED_OWN_0 = "B25042_003",
  BED_OWN_1 = "B25042_004",
  BED_OWN_2 = "B25042_005",
  BED_OWN_3 = "B25042_006",
  BED_OWN_4 = "B25042_007",
  BED_OWN_5more = "B25042_008",
  BED_RENT_0 = "B25042_010",
  BED_RENT_1 = "B25042_011",
  BED_RENT_2 = "B25042_012",
  BED_RENT_3 = "B25042_013",
  BED_RENT_4 = "B25042_014",
  BED_RENT_5more = "B25042_015",
  # Year Built
  YB_MED = "B25035_001",
  YB_14L = "B25034_002",
  YB_10to13 = "B25034_003",
  YB_00to09 = "B25034_004",
  YB_90to99 = "B25034_005",
  YB_80to89 = "B25034_006",
  YB_70to79 = "B25034_007",
  YB_60to69 = "B25034_008",
  YB_50to59 = "B25034_009",
  YB_40to49 = "B25034_010",
  YB_39E = "B25034_011",
  ### HOUSING MARKET ###
  # Median Gross Rent (Renter-Occupied Housing Units Paying Cash Rent)
  RENT_MED = "B25064_001",
  # Gross Rent as a Percentage of Household Income (Renter-Occupied Housing Units)
  RPI_00to09 = "B25070_002",
  RPI_10to14 = "B25070_003",
  RPI_15to19 = "B25070_004",
  RPI_20to24 = "B25070_005",
  RPI_25to29 = "B25070_006",
  RPI_30to34 = "B25070_007",
  RPI_35to39 = "B25070_008",
  RPI_40to49 = "B25070_009",
  RPI_50more = "B25070_010",
  RPI_NA = "B25070_011",
  # Median Selected Monthly Owner Costs (Owner-Occupied Housing Units)
  COST_OWN_MED = "B25088_001",
  # Selected Monthly Owner Costs by Mortgage Status (Owner-Occupied Housing Units)
  OPI_00to09 = "B25091_003",
  OPI_10to14 = "B25091_004",
  OPI_15to19 = "B25091_005",
  OPI_20to24 = "B25091_006",
  OPI_25to29 = "B25091_007",
  OPI_30to34 = "B25091_008",
  OPI_35to39 = "B25091_009",
  OPI_40to49 = "B25091_010",
  OPI_50more = "B25091_011",
  OPI_NA = "B25091_012",
  # Median Monthly Housing Costs (Occupied Housing Units with Monthly Housing Costs)
  COST_MED = "B25105_001",
  # Value by Quartile (Owner-Occupied Housing Units)
  OVAL_Q1 = "B25076_001",
  MED_HVAL = "B25077_001",
  OVAL_Q3 = "B25078_001",
  # Tenure by HH Size
  TOT_HHSize = "B25009_001",
  HHS_1O = "B25009_003",
  HHS_1R = "B25009_011",
  HHS_2O = "B25009_004",
  HHS_3O = "B25009_005",
  HHS_4O = "B25009_006",
  HHS_2R = "B25009_012",
  HHS_3R = "B25009_013",
  HHS_4R = "B25009_014",
  HHS_5O = "B25009_007",
  HHS_6O = "B25009_008",
  HHS_7O = "B25009_009",
  HHS_5R = "B25009_015",
  HHS_6R = "B25009_016",
  HHS_7R = "B25009_017"
)

dvrpc_states <- c(34, 42)
dvrpc_fips <- c('^34005|^34007|^34015|^34021|^42017|^42029|^42045|^42091|^42101')

raw_data_15 <- get_acs(geography = "block group",
                    variables = acs5_15_vars_tot,
                    year = 2015,
                    state = dvrpc_states,
                    survey = "acs5",
                    output = "wide"
) %>%
  mutate(year = 2015) %>%
  filter(str_detect(GEOID, dvrpc_fips)) %>%
  select(GEOID, year, ends_with("E"), -NAME)%>%
  rename("GEOID_10" = "GEOID") %>%
  `colnames<-`(str_replace(colnames(.),"E$",""))

# Import crosswalk
crosswalk <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\NHGIS\\nhgis_bg2010_tr2020.csv", colClasses = c("bg2010gj" = "character", "bg2010ge" = "character",	"tr2020gj" = "character",	"tr2020ge" = "character"))


# Join 2015 data with crosswalk
raw_data_15_crosswalk <- merge(raw_data_15, crosswalk, by.x="GEOID_10", by.y="bg2010ge")


# Summarize data to 2020 tracts
acs5_15_2020tracts <- raw_data_15_crosswalk %>%
  mutate(POP_TOT_15 = round(POP_TOT * wt_pop, 0)) %>%
  mutate(HH_TOT_15 = round(HH_TOT * wt_hh, 0)) %>%
  mutate(UNITS_TOT_15 = round(UNITS_TOT * wt_hu, 0)) %>%
  mutate(UNIT_1DET_15 = round(UNIT_1DET * wt_hu, 0)) %>%
  mutate(UNIT_1ATT_15 = round(UNIT_1ATT * wt_hu, 0)) %>%
  mutate(UNIT_2_15 = round(UNIT_2 * wt_hu, 0)) %>%
  mutate(UNIT_3or4_15 = round(UNIT_3or4 * wt_hu, 0)) %>%
  mutate(UNIT_5to9_15 = round(UNIT_5to9 * wt_hu, 0)) %>%
  mutate(UNIT_1019_15 = round(UNIT_1019 * wt_hu, 0)) %>%
  mutate(UNIT_2049_15 = round(UNIT_2049 * wt_hu, 0)) %>%
  mutate(UNIT_50P_15 = round(UNIT_50P * wt_hu, 0)) %>%
  select(tr2020ge, POP_TOT_15, HH_TOT_15, UNITS_TOT_15, UNIT_1DET_15, UNIT_1ATT_15, UNIT_2_15, UNIT_3or4_15, UNIT_5to9_15, UNIT_1019_15, UNIT_2049_15, UNIT_50P_15) %>%
  group_by(tr2020ge) %>%
  summarise(across(everything(), sum)) %>%
  rename("GEOID" = "tr2020ge")


# Import 2020 data
raw_data_20 <- get_acs(geography = "tract",
                       variables = acs5_15_vars_tot,
                       year = 2020,
                       state = dvrpc_states,
                       survey = "acs5",
                       output = "wide"
) %>%
  mutate(year = 2020) %>%
  filter(str_detect(GEOID, dvrpc_fips)) %>%
  select(GEOID, year, ends_with("E"), -NAME)%>%
  `colnames<-`(str_replace(colnames(.),"E$","")) 

# Join datasets
check_df <- left_join(raw_data_20, acs5_15_2020tracts, by="GEOID")


# Import tracts with submarkets
tracts_submarkets <- read.csv("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\v1\\tracts_class.csv", colClasses = c("GEOID" = "character")) %>%
  select(GEOID, Class)

# Join datasets
change_df <- left_join(tracts_submarkets, check_df, by="GEOID") %>%
  select(Class, POP_TOT, POP_TOT_15, HH_TOT, HH_TOT_15, UNITS_TOT, UNITS_TOT_15, UNIT_1DET, UNIT_1DET_15, UNIT_1ATT, UNIT_1ATT_15, UNIT_2, UNIT_2_15, UNIT_3or4, UNIT_3or4_15, UNIT_5to9, UNIT_5to9_15, UNIT_1019, UNIT_1019_15, UNIT_2049, UNIT_2049_15, UNIT_50P, UNIT_50P_15) %>%
  group_by(Class) %>%
  summarise(across(everything(), sum)) %>%
  mutate(POP_TOT_CHG = round(100 * ((POP_TOT - POP_TOT_15)/POP_TOT_15), 1)) %>%
  mutate(HH_TOT_CHG = round(100 * ((HH_TOT - HH_TOT_15)/HH_TOT_15), 1)) %>%
  mutate(UNIT_1DET_CHG = round(100 * ((UNIT_1DET - UNIT_1DET_15)/UNIT_1DET_15), 1)) %>%
  mutate(UNIT_1ATT_CHG = round(100 * ((UNIT_1ATT - UNIT_1ATT_15)/UNIT_1ATT_15), 1)) %>%
  mutate(UNIT_2_CHG = round(100 * ((UNIT_2 - UNIT_2_15)/UNIT_2_15), 1)) %>%
  mutate(UNIT_3or4_CHG = round(100 * ((UNIT_3or4 - UNIT_3or4_15)/UNIT_3or4_15), 1)) %>%
  mutate(UNIT_5to9_CHG = round(100 * ((UNIT_5to9 - UNIT_5to9_15)/UNIT_5to9_15), 1)) %>%
  mutate(UNIT_1019_CHG = round(100 * ((UNIT_1019 - UNIT_1019_15)/UNIT_1019_15), 1)) %>%
  mutate(UNIT_2049_CHG = round(100 * ((UNIT_2049 - UNIT_2049_15)/UNIT_2049_15), 1)) %>%
  mutate(UNIT_50P_CHG = round(100 * ((UNIT_50P - UNIT_50P_15)/UNIT_50P_15), 1))


write.csv(change_df, "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\v1\\submarket_chg_2015_2020.csv")