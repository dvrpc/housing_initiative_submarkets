# Last updated: 07/15/2022
# Purpose: This script uses a crosswalk from NHGIS to convert 2010 block groups to 2010 census tracts.

# Load packages
library(tidyverse)
library(dplyr)
library(rgdal)
library(tidycensus)
library(censusapi)
library(stringr)

#Load Census API key
census_api <- Sys.getenv("CENSUS_API_KEY")


# Import crosswalk
crosswalk <- read.csv("R/nhgis_crosswak_bg2010_tr2020/nhgis_bg2010_tr2020.csv")
crosswalk$bg2010ge_char <- as.character(crosswalk$bg2010ge)

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
  OVAL_Q3 = "B25078_001")

dvrpc_states <- c(34, 42)
dvrpc_fips <- c('34005|34007|34015|34021|42017|42029|42045|42091|42101')


# Create a dataframe with the raw data for the region ----
raw_data <- get_acs(geography = "block group",
                    variables = acs5_15_vars_tot,
                    year = 2015,
                    state = dvrpc_states,
                    survey = "acs5",
                    output = "wide"
) %>%
  mutate(year = 2015) %>%
  filter(str_detect(GEOID, dvrpc_fips)) %>%
  select(GEOID, year, ends_with("E"), -NAME)%>%
  `colnames<-`(str_replace(colnames(.),"E$",""))

# Check for missing values
missing_pop <- raw_data %>%
  filter(is.na(POP_TOT)) 

missing_rent <- raw_data %>%
  filter(is.na(RENT_MED)) %>%
  select(GEOID, POP_TOT, RENT_MED)

missing_inc <- raw_data %>%
  filter(is.na(HHINC_MED))

#Join raw dataframe with crosswalk
raw_data_crosswalk_dataframe <- raw_data %>%
  left_join(crosswalk, by = c("GEOID" = "bg2010ge_char"))


dvrpc_bg_grouped <- raw_data_crosswalk_dataframe %>%
  mutate(RENT_MED = (RENT_MED * wt_hh), 3) %>%
  mutate(HHINC_MED = (HHINC_MED * wt_hh), 3) %>%
  select(GEOID, bg2010ge, tr2020ge, POP_TOT, RENT_MED, HHINC_MED) %>%
  group_by(bg2010ge) %>%
  summarise(
    tr2020ge = first(tr2020ge),
    POP_TOT = sum(POP_TOT),
    RENT_MED = sum(RENT_MED),
    HHINC_MED = sum(HHINC_MED),
    .groups = "drop"
  )
dvrpc_bg_grouped$tr2020ge <- as.character(dvrpc_bg_grouped$tr2020ge)

tract_pop_20 <- dvrpc_bg_grouped %>%
  group_by(tr2020ge) %>%
  summarise(
    POP_TRACT = sum(POP_TOT),
    .groups = "drop"
  )
tract_pop_20$tr2020ge <- as.character(tract_pop_20$tr2020ge)


joined_dataset_with_tracts <- dvrpc_bg_grouped %>%
  inner_join(tract_pop_20, by = "tr2020ge")

final_dataset <- joined_dataset_with_tracts %>%
  group_by(tr2020ge) %>%
  summarise(
    POP_15 = sum(POP_TOT),
    RENT_MED_15 = round(sum(POP_TOT/POP_TRACT * RENT_MED), 1),
    HHINC_MED_15 = round(sum(POP_TOT/POP_TRACT * HHINC_MED), 1),
    .groups = "drop"
  )