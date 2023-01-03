# Author: Brian Carney
# Last updated: 12/27/2022
# Prepared for: Region Housing Initiative - Submarket Clustering Analysis Overlays

# Set working directory
setwd("C:\\Users\\bcarney\\Documents\\GitHub\\housing_initiative_submarkets\\R")

#remove.packages("tidycensus")
#install.packages("tidycensus", dependencies = TRUE)

#remove.packages("dplyr")
#install.packages("dplyr", dependencies = TRUE)

# Install necessary packages
# install.packages("censusapi")
# install.packages("tidyverse")
# install.packages("dplyr")
# install.packages("rgdal")
# install.packages("tidycensus")
# update.packages("tidycensus")

# Load packages
library(tidyverse)
library(dplyr)
library(rgdal)
library(tidycensus)
library(censusapi)

#Load Census API key
census_api_key("e6cd8f90ccb0acacdfa5373911a2e73b96dbd792", install=TRUE, overwrite=TRUE)
readRenviron("~/.Renviron")


#Region FIPS
fips_region <- c("34005", "34007", "34015", "34021", "42017", "42029", "42045", "42091", "42101")

#Variable List - For Reference
acs5_varlist_2020 <- load_variables(year = 2020,
                                    dataset = "acs5",
                                    cache = TRUE)

# ---- Define Variables ----
acs5_20_overlay_vars <- c(
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


# Import Submarket Results
tracts_submarkets <- read.csv("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\LPA_Test3_Submarkets\\tracts_submarkets.csv", colClasses = c("X"="character"))


# Overlay Variables
overlay_df <- raw_data %>%
  mutate(CARS_HH = round(AGG_NUM_VEH/COMM_TOTHH, 1)) %>%  # Cars per HH
  mutate(CS_PUBT = round(100 * (COMM_PUBT/COMM_TOTHH), 1)) %>% # Percent of HHs that commute to work via public transit
  mutate(CS_DRIVE = round((100 * (COMM_DRVAL + COMM_CARPL)/COMM_TOTHH), 1)) %>% # Percent of HHs that commute to work via driving
  mutate(CS_WFH = round(100 * (COMM_WFHO/COMM_TOTHH), 1)) %>% # Percent of HHs that work from home
  mutate(ED_LHSC = round(100 *((EDU_NURS +
                         EDU_KIND +
                         EDU_FRST +
                         EDU_SCND +
                         EDU_THRD +
                         EDU_FRTH +
                         EDU_FFTH +
                         EDU_SXTH +
                         EDU_SVTH +
                         EDU_EGTH +
                         EDU_NNTH +
                         EDU_TNTH +
                         EDU_ELTH +
                         EDU_TWTH)/EDU_TOTL), 1)) %>%
  mutate(ED_HSCH = round(100 * ((EDU_HSCH + EDU_GEDE)/EDU_TOTL), 1)) %>%
  mutate(ED_BACH = round(100 *((EDU_BACH +
                          EDU_MAST +
                          EDU_PROF +
                          EDU_DOCT)/EDU_TOTL), 1)) %>%
  mutate(HC_BURD = round(100 * ((RPI_30to34 +
                          RPI_35to39 +
                          RPI_40to49 +
                          RPI_50more +
                          OPI_30to34 +
                          OPI_35to39 +
                          OPI_40to49 +
                          OPI_50more)
                          /(OPI_MORT_POP + RPI_TOTPOP)), 1)) %>%
  mutate(HC_SEVB = round(100 * ((RPI_50more +
                            OPI_50more)
                         /(OPI_MORT_POP + RPI_TOTPOP)), 1)) %>%
  mutate(PCT_WHI = round(100 * (POP_WHI/POP_TOT), 1)) %>%
  mutate(PCT_BLK = round(100 * (POP_BLK/POP_TOT), 1)) %>%
  mutate(PCT_AIA = round(100 * (POP_AIA/POP_TOT), 1)) %>%
  mutate(PCT_ASN = round(100 * (POP_ASN/POP_TOT), 1)) %>%
  mutate(PCT_HPI = round(100 * (POP_HPI/POP_TOT), 1)) %>%
  mutate(PCT_OTH = round(100 * (POP_OTH/POP_TOT), 1)) %>%
  mutate(PCT_TWO = round(100 * (POP_TWO/POP_TOT), 1)) %>%
  mutate(PCT_WNH = round(100 * (POP_WNH/POP_TOT), 1)) %>%
  mutate(PCT_LAT = round(100 * (POP_LAT/POP_TOT), 1)) %>%
  mutate(UNEMP_RT = round(100 * (EMP_UNEM/EMP_CVLF), 1)) %>%
  select(GEOID, CARS_HH, CS_PUBT, CS_DRIVE, CS_WFH, ED_LHSC, ED_HSCH, ED_BACH, HC_BURD, HC_SEVB, PCT_WHI, PCT_BLK, PCT_AIA, PCT_ASN, PCT_HPI, PCT_OTH, PCT_TWO, PCT_WNH, PCT_LAT, UNEMP_RT)


# Join Overlay DF with Submarket Results
overlay_submarkets <- left_join(tracts_submarkets, overlay_df, by = c("X"="GEOID"))

rownames(overlay_submarkets) <- overlay_submarkets$X

# Export to csv
write.csv(overlay_submarkets, "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\LPA_Test3_Submarkets\\tracts_submarkets_overlays.csv")