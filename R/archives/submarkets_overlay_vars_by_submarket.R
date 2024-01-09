# Author: Brian Carney
# Last updated: 09/13/2023
# Prepared for: Region Housing Initiative - Submarket Clustering Analysis Overlays

# Set working directory
setwd("C:\\Users\\bcarney\\Documents\\GitHub\\housing_initiative_submarkets\\R")


# Load packages
library(tidyverse)
library(dplyr)
library(rgdal)
library(tidycensus)
library(censusapi)

#Load Census API key
sys.getenv("CENSUS_API_KEY")


#Region FIPS
fips_region <- c("34005", "34007", "34015", "34021", "42017", "42029", "42045", "42091", "42101")

#Variable List - For Reference
acs5_varlist_2020 <- load_variables(year = 2020,
                                    dataset = "acs5",
                                    cache = TRUE)

# ---- Define Variables ----
acs5_20_overlay_vars <- c(
  POP_TOT = "B01003_001",
  # Aggregate Number of Vehicles Available
  AGG_NUM_VEH = "B25046_001",
  # Means of Transportation to Work
  COMM_TOTHH = "B08101_001",
  COMM_DRVAL = "B08101_009",
  COMM_CARPL = "B08101_017",
  COMM_PUBT = "B08101_025",
  COMM_WALK = "B08101_033",
  COMM_OTHR = "B08101_041",
  COMM_WFHO = "B08101_049",
  # Educational Attainment
  EDU_TOTL = "B15003_001",
  EDU_NONE = "B15003_002",
  EDU_NURS = "B15003_003",
  EDU_KIND = "B15003_004",
  EDU_FRST = "B15003_005",
  EDU_SCND = "B15003_006",
  EDU_THRD = "B15003_007",
  EDU_FRTH = "B15003_008",
  EDU_FFTH = "B15003_009",
  EDU_SXTH = "B15003_010",
  EDU_SVTH = "B15003_011",
  EDU_EGTH = "B15003_012",
  EDU_NNTH = "B15003_013",
  EDU_TNTH = "B15003_014",
  EDU_ELTH = "B15003_015",
  EDU_TWTH = "B15003_016",
  EDU_HSCH = "B15003_017",
  EDU_GEDE = "B15003_018",
  EDU_SC1L = "B15003_019",
  EDU_SCM1 = "B15003_020",
  EDU_ASSO = "B15003_021",
  EDU_BACH = "B15003_022",
  EDU_MAST = "B15003_023",
  EDU_PROF = "B15003_024",
  EDU_DOCT = "B15003_025",
  # Housing Cost Burden
  ## Gross Rent as a Percentage of Household Income (Renter-Occupied Housing Units)
  RPI_TOTPOP = "B25070_001",
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
  ## Selected Monthly Owner Costs by Mortgage Status (Owner-Occupied Housing Units)
  OPI_MORT_POP = "B25091_002",
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
  # Total Population
  POP_TOT = "B01003_001",
  # Race and Ethnicity
  POP_WHI = "B01001A_001",
  POP_BLK = "B01001B_001",
  POP_AIA = "B01001C_001",
  POP_ASN = "B01001D_001",
  POP_HPI = "B01001E_001",
  POP_OTH = "B01001F_001",
  POP_TWO = "B01001G_001",
  POP_WNH = "B01001H_001",
  POP_LAT = "B01001I_001",
  # Unemployment
  EMP_POPU = "B23025_001",
  EMP_LABF = "B23025_002",
  EMP_CVLF = "B23025_003",
  EMP_UNEM = "B23025_005",
  EMP_ARMF = "B23025_006"
)

dvrpc_states <- c(34, 42)
dvrpc_fips <- c('34005|34007|34015|34021|42017|42029|42045|42091|42101')

raw_data <- get_acs(geography = "tract",
                    variables = acs5_20_overlay_vars,
                    year = 2020,
                    state = dvrpc_states,
                    survey = "acs5",
                    output = "wide"
) %>%
  mutate(year = 2020) %>%
  filter(str_detect(GEOID, dvrpc_fips)) %>%
  select(GEOID, year, ends_with("E"), -NAME)%>%
  `colnames<-`(str_replace(colnames(.),"E$",""))

tracts_submarkets <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\SubmarketAnalysis\\20230517_submarket_review\\v1\\data\\tracts_class.csv", colClasses = c("GEOID" = "character"))



# Overlay Variables
burden_df <- raw_data %>%
  mutate(HC_BURD_NUM = RPI_30to34 +
                      RPI_35to39 +
                      RPI_40to49 +
                      RPI_50more +
                      OPI_30to34 +
                      OPI_35to39 +
                      OPI_40to49 +
                      OPI_50more) %>%
  mutate(HC_BURD_DEN = OPI_MORT_POP + RPI_TOTPOP) %>%
  mutate(HC_SEVB_NUM = RPI_50more + OPI_50more) %>%
  mutate(HC_SEVB_DEN = OPI_MORT_POP + RPI_TOTPOP) %>%
  select(GEOID, HC_BURD_NUM, HC_BURD_DEN, HC_SEVB_NUM, HC_SEVB_DEN)


# Join Overlay DF with Submarket Results
cost_burden_submarkets <- left_join(tracts_submarkets, burden_df, by = "GEOID") %>%
  select(Class, HC_BURD_NUM, HC_BURD_DEN, HC_SEVB_NUM, HC_SEVB_DEN) %>%
  group_by(Class) %>%
  summarise(across(everything(), sum),
            .groups = 'drop') %>%
  mutate(submarket_cost_burd = round(HC_BURD_NUM/HC_BURD_DEN, 3)) %>%
  mutate(submarket_sev_cost_burd = round(HC_SEVB_NUM/HC_SEVB_DEN, 3))

# Export to csv
write.csv(cost_burden_submarkets, "G:\\Shared drives\\FY22 Regional Housing Initiative\\SubmarketAnalysis\\20230517_submarket_review\\v1\\data\\submarkets_cost_burden.csv")