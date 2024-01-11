# Introduction
As part of the Regional Housing Initiative (RHI), the team conducted a submarket analysis. This analysis identifies census tracts with similar housing characteristics (density, price, market conditions) and groups them accordingly. This submarket analysis uses a Latent Profile Analysis (LPA) via the mclust package in R to group the region's 1,407 eligible census tracts (tracts with no households or population were removed) into one of eight submarkets. The team reviewed the existing conditions of these submarkets to identify their housing challenges and appropriate policies and strategies for each submarket.

## Data
The submarket analysis uses data from three sources:

### 1. American Community Survey (ACS) 5-Year Estimates (2016-2020)

Inputs: 
- Median Household Income
- Median Gross Rent
- Percent Owner-Occupied
- Vacancy Rate
- Percent of Housing Units Built in 1959 or Earlier
- Percent of Housing Units Built Since 2000
- Percent of Housing Units that are 1 Unit in Structure
- Percent of Housing Units that are 2 to 4 Units in Structure
- Percent of Households that are 2 to 4 Persons
- Percent of Households that are 5 or More Persons
- Housing Units per Acre

For binary and categorical inputs (tenure, age of housing stock, units in structure, household size), we removed at least one input to avoid collinearity in our model.

Removed inputs:
- Percent Owner-Occupied
- Percent of Housing Units Built Between 1960 and 1999
- Percent of Housing Units that are 5 or More Units in Structure
- Percent of Households that are 1 Person

### 2. The Warren Group
Inputs:
- Median Single Family Residential Sale Price, 2021
- Percent Change in Median Single Family Residential Sale Price (2016-2021)

We purchased The Warren Group's (TWG) property sale data for two years, 2016 and 2021. For both years, we selected single-family residential property transactions with a sale price of at least $50,000. We selected single-family properties exclusively due to the difficulty in adjusting prices for multifamily properties. Additionally, we set a price floor of $50,000 to filter out low-cost transactions. We use 2021 as the current median single-family sale price and the percent change in the median single-family sale price from 2016 to 2021 as our two indicators from this dataset.

### 3. National Housing Preservation Database (NHPD)
Inputs:
- Percent of Housing Units that are Federally Subsidized

The NHPD is a point dataset of active subsidized housing developments in the country. It provides information such as the type of subsidy, number of units, and subsidy expiration date. Using this database, we calculate the share of overall housing units at the census tract level that are federally subsidized (Public Housing, Low-Income Housing Tax Credit, and Project-Based Section 8).

## Eligible Tracts
The DVRPC region has 1,449 census tracts. However, we removed 42 census tracts from our submarket analysis because the population and/or number of households in these tracts was zero. Therefore, we conducted the submarket analysis using 1,407 census tracts.


## Script Order
- R/PullCensusData_LPA_3.R
- python/nhpd_to_sql.py
- sql/region_properties_ph_s8_lihtc.sql
- sql/region_subsidizedhousing_tracts.sql
- sql/region_subsidizedhousingunits_bytract.sql
- python/twg_to_sql.py
- sql/twg_deeds_2016.sql
- sql/twg_deeds_2021.sql
- sql/median2016.sql
- sql/median2021.sql
- sql/deeds_tracts_mediansaleprice_20162021.sql
- sql/region_tracts_mediansaleprice_subsidizehousingunits.sql
- R/20221012_Submarkets_LPA_8_Test3.R

