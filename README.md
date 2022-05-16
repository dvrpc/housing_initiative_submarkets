# housing_initiative_submarkets

## Introduction
As part of the Regional Housing Initiative (RHI), the team is conducting a submarket analysis. This analysis identifies census tracts with similar housing characteristics (density, price, market conditions) and groups them accordingly. Depending on the clustering algorithm, the number of submarkets will either be manually chosen (k-medoids analysis) or defined based on the results (latent profile analysis). The project team decided to conduct this analysis based on the work of peer metropolitan planning organizations (MPOs) in Atlanta (ARC), Boston (MAPC), and Chicago (CMAP). The goal of the submarket analysis is to group areas with similar housing market conditions and to identify strategies and solutions that best fit each submarket.

## Data
The clustering algorithm requires a tabular dataset with continous variables. Since the submarket analysis evaluates a wide array of variables (units in structure, density, sale price, subsidized housing units, transportation costs, etc.), there multiple datasets that are a part of the final tabular dataset. We use the following datsets in the submarket analysis:

### 1. ACS 5-Year Estimates
### 2. Property sale data (Estated)
### 3. HUD Location Affordability Index
### 4. National Housing Preservation Database (NHPD)
### 5. Home Mortgage Disclosure Act (HMDA) data

## Data Preparation
