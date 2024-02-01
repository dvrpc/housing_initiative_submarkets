# Author: Brian Carney
# Last updated: 03/16/2023
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


# Variable List - For Reference
acs5_varlist <- load_variables(year = 2015,
                                    dataset = "acs5",
                                    cache = TRUE)


# ---- Define Variables ----
acs5_vars_tot <- c(
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
  UNIT_MOB = "B25024_010")

dvrpc_states <- c(34, 42)
dvrpc_fips <- c('^34005|^34007|^34015|^34021|^42017|^42029|^42045|^42091|^42101')

raw_data_11 <- get_acs(geography = "county",
                       variables = acs5_vars_tot,
                       year = 2011,
                       state = dvrpc_states,
                       survey = "acs1",
                       output = "wide"
) %>%
  filter(str_detect(GEOID, dvrpc_fips)) %>%
  select(GEOID, ends_with("E"), -NAME)%>%
  `colnames<-`(str_replace(colnames(.),"E$","")) %>%
  rename("UNITS_STR_11" = "UNITS_STR") %>%
  rename("UNIT_1DET_11" = "UNIT_1DET") %>%
  rename("UNIT_1ATT_11" = "UNIT_1ATT") %>%
  rename("UNIT_2_11" = "UNIT_2") %>%
  rename("UNIT_3or4_11" = "UNIT_3or4") %>%
  rename("UNIT_5to9_11" = "UNIT_5to9") %>%
  rename("UNIT_1019_11" = "UNIT_1019") %>%
  rename("UNIT_2049_11" = "UNIT_2049") %>%
  rename("UNIT_50P_11" = "UNIT_50P") %>%
  rename("UNIT_MOB_11" = "UNIT_MOB")

raw_data_21 <- get_acs(geography = "county",
                       variables = acs5_vars_tot,
                       year = 2021,
                       state = dvrpc_states,
                       survey = "acs1",
                       output = "wide"
) %>%
  filter(str_detect(GEOID, dvrpc_fips)) %>%
  select(GEOID, ends_with("E"), -NAME)%>%
  `colnames<-`(str_replace(colnames(.),"E$",""))


chg_df <- left_join(raw_data_11, raw_data_21, by="GEOID") %>%
  select(-GEOID) %>%
  summarise(across(everything(), sum)) %>%
  mutate(UNITS_STR_CHG = round((UNITS_STR - UNITS_STR_11)/UNITS_STR_11, 3)) %>%
  mutate(UNIT_1DET_CHG = round((UNIT_1DET - UNIT_1DET_11)/UNIT_1DET_11, 3)) %>%
  mutate(UNIT_1ATT_CHG = round((UNIT_1ATT - UNIT_1ATT_11)/UNIT_1ATT_11, 3)) %>%
  mutate(UNIT_2_CHG = round((UNIT_2 - UNIT_2_11)/UNIT_2_11, 3)) %>%
  mutate(UNIT_3or4_CHG = round((UNIT_3or4 - UNIT_3or4_11)/UNIT_3or4_11, 3)) %>%
  mutate(UNIT_5to9_CHG = round((UNIT_5to9 - UNIT_5to9_11)/UNIT_5to9_11, 3)) %>%
  mutate(UNIT_1019_CHG = round((UNIT_1019 - UNIT_1019_11)/UNIT_1019_11, 3)) %>%
  mutate(UNIT_2049_CHG = round((UNIT_2049 - UNIT_2049_11)/UNIT_2049_11, 3)) %>%
  mutate(UNIT_50P_CHG = round((UNIT_50P - UNIT_50P_11)/UNIT_50P_11, 3)) %>%
  mutate(UNIT_MOB_CHG = round((UNIT_MOB - UNIT_MOB_11)/UNIT_MOB_11, 3))


write.csv(chg_df, "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\units_in_structure_region_2011_2021.csv")
  