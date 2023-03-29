# housing_initiative_submarkets

## Introduction
As part of the Regional Housing Initiative (RHI), the team conducted a submarket analysis. This analysis identifies census tracts with similar housing characteristics (density, price, market conditions) and groups them accordingly. This submarket analysis uses a Latent Profile Analysis (LPA) via the mclust package in R to group the region's 1,400 eligible census tracts into one of eight submarkets. The team reviewed the existing conditions of these submarkets to identify their housing challenges and appropriate policies and strategies for each submarket.

## Data
The clustering algorithm requires a tabular dataset with continous variables. Since the submarket analysis evaluates a wide array of variables (units in structure, density, sale price, subsidized housing units, transportation costs, etc.), there are multiple datasets that comprise the final tabular dataset. We use the following datsets in the submarket analysis:

### 1. ACS 5-Year Estimates
We use the 2016-2020 ACS 5-Year Estimates survey at the census tract level for multiple variables, including housing density, median household income, vacancy rates, units in structure, and median household rent. We use 16 indicators from this dataset.

### 2. Property sale data
We purchased The Warren Group's (TWG) property sale data for two years, 2016 and 2021. For both years, we identified the single-family residential median sale price at the census tract level. We use 2021 as the current median single-family sale price and the percent change in the median single-family sale price from 2016 to 2021 as our two indicators from this dataset.

### 3. National Housing Preservation Database (NHPD)
The NHPD is a point dataset of active subsidized housing developments in the country. It provides information such as the type of subsidy, number of units, and subsidy expiration date. For the tabular dataset, we calculate the share of overall housing units at the census tract level that are federally subsidized (Public Housing, Low-Income Housing Tax Credit, and Project-Based Section 8).

## Script Order

1.    R/PullCensusData_LPA_3.R
2.    Python/nhpd_data_export/to_sql.py
3.    Sql/region_properties_ph_s8_lihtc.sql
4.    Sql/region_subsidizedhousing_tracts.sql
5.    Sql/region_subsidizedhousingunits_bytract.sql
6.    Python/twg_export/to_sql.py
7.    twg_deeds_2016.sql
8.    twg_deeds_2021.sql
8.    median2016.sql
9.    median2021.sql
10.   deeds_tracts_mediansaleprice_20162021.sql
11.   Sql/region_tracts_mediansaleprice_subsidizehousingunits.sql
12.   Python/region_tracts_mediansaleprice_subsidizedhousingunits.sql
13.   R/20221012_Submarkets_LPA_8_Test3.R
