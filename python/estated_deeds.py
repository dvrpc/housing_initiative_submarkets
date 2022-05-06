# Author: Brian Carney
# Purpose: This script evaluates a sample deeds dataset from Estated.

import pandas as pd

# Import dataset
deeds = pd.read_csv(r"G:\Shared drives\FY22 Regional Housing Initiative\Data\Estated Sample Data\Montgomery County\deeds.csv", dtype={'fips': str, 'apn': str, 'document_type': str}, low_memory=False)


# Calculate total number of rows
deeds_total_rows = len(deeds)
print("In the deeds dataset, there are {} rows".format(deeds_total_rows))


# Distressed Sales
distressed_sale = deeds.loc[deeds['distressed_sale'] == 't']
distressed_sale_rows = len(distressed_sale)
print("Of the {} total rows in the dataset, {} rows are categorized as distressed sales. This is {} percent of the total dataset.".format(deeds_total_rows, distressed_sale_rows, round((distressed_sale_rows/deeds_total_rows)*100, 2)))


# Real Estate Owned
real_estate_owned = deeds.loc[(deeds['real_estate_owned'] != 'NO') & (deeds['real_estate_owned'].notnull())]
real_estate_owned_rows = len(real_estate_owned)
print("Of the {} total rows in the dataset, {} rows are categorized as real estate owned sales. This is {} percent of the total dataset.".format(deeds_total_rows, real_estate_owned_rows, round((real_estate_owned_rows/deeds_total_rows)*100, 2)))


# Cash Sales
cash_sales = deeds.loc[(deeds['loan_type'] == 'CASH') | (deeds['document_type'] == 'CASH SALE')]
cash_sales_rows = len(cash_sales)
print("Of the {} total rows in the dataset, {} rows are categorized as cash sales. This is {} percent of the total dataset.".format(deeds_total_rows, cash_sales_rows, round((cash_sales_rows/deeds_total_rows)*100, 2)))


# Foreclosures
foreclosures = deeds.loc[deeds['document_type'] == 'FORECLOSURE']
foreclosure_rows = len(cash_sales)
print("Of the {} total rows in the dataset, {} rows are categorized as foreclosures. This is {} percent of the total dataset.".format(deeds_total_rows, foreclosure_rows, round((foreclosure_rows/deeds_total_rows)*100, 2)))
