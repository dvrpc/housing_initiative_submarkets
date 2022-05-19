# housing_initiative_submarkets

## Introduction
As part of the Regional Housing Initiative (RHI), the team is conducting a submarket analysis. This analysis identifies census tracts with similar housing characteristics (density, price, market conditions) and groups them accordingly. Depending on the clustering algorithm, the number of submarkets will either be manually chosen (k-medoids analysis) or defined based on the results (latent profile analysis). The project team decided to conduct this analysis based on the work of peer metropolitan planning organizations (MPOs) in Atlanta (ARC), Boston (MAPC), and Chicago (CMAP). The goal of the submarket analysis is to group areas with similar housing market conditions and to identify strategies and solutions that best fit each submarket.

## Data
The clustering algorithm requires a tabular dataset with continous variables. Since the submarket analysis evaluates a wide array of variables (units in structure, density, sale price, subsidized housing units, transportation costs, etc.), there multiple datasets that are a part of the final tabular dataset. We use the following datsets in the submarket analysis:

### 1. ACS 5-Year Estimates
We use the 2016-2020 ACS 5-Year Estimates survey at the census tract level for multiple variables, including housing density, median household income, vacancy rates, units in structure, and median household rent.

### 2. Property sale data (Estated/TWG)
We are planning on purchasing property sale data for two years, 2016 and 2021. Each record in the deeds/transaction dataset represents a transaction, which must be aggregated to the census tract level. The 2021 transactions will serve as the current year and we will use the median sales price at the tract level as one of the variables in the final dataset. To capture the change in the housing market, we will also calculate the percent change in median sale price at the tract level from 2016 to 2021, which will be another variable used in the dataset. To get these values, there are multiple steps in the filtering process. For example, we are only evaluating transactions for low-density housing (have not defined this yet--unclear if we are going to include duplexes through quadplexes). Additionally, these transactions should only be first mortgages, since second mortgages and refinancing are not a reflection of how much the property is going for on the open market. 

### 3. HUD Location Affordability Index v.3
The HUD Location Affordability Index v.3 was released in March 2019 and uses 2012-2016 ACS 5-Year Estimates. The Index provides standardized housing and transportation costs at the census tract level. There are eight household profiles to choose from--which vary by household income, size, and number of commuters (have not chosen which profile to use yet). 

### 4. National Housing Preservation Database (NHPD)
The NHPD is a point dataset of active subsidized housing developments in the country. It provides information such as the type of subsidy, number of units, and subsidy expiration date. For the tabular dataset, we will include a field that shows the percent of overall housing units that are subsidized (have not made a decision on which types of subsidies count yet). This can be done by aggregating the number of subsidized units at the tract level and dividing that by the total number of housing units, which is taken from the 2016-2020 ACS 5-Year Estimates.

### 5. Home Mortgage Disclosure Act (HMDA) data

## Data Preparation
