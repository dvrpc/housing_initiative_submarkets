# Author: Brian Carney
# Purpose: This script evaluates sample transactions dataset from The Warren Group.

import pandas as pd

# Transactions
transactions = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt",
    dtype={"DEEDTYPE": str, "SALETYPE": str, "PROPUSE": str, "MTGTYPE": str},
    sep="\t",
)


transactions_test = transactions[["DEEDTYPE", "SALETYPE", "PROPUSE", "MTGTYPE"]]
print(transactions_test)

# Calculate total number of rows
transactions_total_rows = len(transactions)
print("In the transactions dataset, there are {} rows".format(transactions_total_rows))


# Testing a quick groupby
transactions_condensed = transactions[["SALETYPE", "TRANID"]]
transactions_condensed["count"] = 0
results = transactions_condensed.groupby("SALETYPE", "TRANID").count()
print(results)

"""

# Distressed Sales
distressed_sale = transactions.loc[transactions['distressed_sale'] == 't']
distressed_sale_rows = len(distressed_sale)
print("Of the {} total rows in the dataset, {} rows are categorized as distressed sales. This is {} percent of the total dataset.".format(transactions_total_rows, distressed_sale_rows, round((distressed_sale_rows/transactions_total_rows)*100, 2)))


# Real Estate Owned
real_estate_owned = transactions.loc[(transactions['real_estate_owned'] != 'NO') & (transactions['real_estate_owned'].notnull())]
real_estate_owned_rows = len(real_estate_owned)
print("Of the {} total rows in the dataset, {} rows are categorized as real estate owned sales. This is {} percent of the total dataset.".format(transactions_total_rows, real_estate_owned_rows, round((real_estate_owned_rows/transactions_total_rows)*100, 2)))


# Cash Sales
cash_sales = transactions.loc[(transactions['loan_type'] == 'CASH') | (transactions['document_type'] == 'CASH SALE')]
cash_sales_rows = len(cash_sales)
print("Of the {} total rows in the dataset, {} rows are categorized as cash sales. This is {} percent of the total dataset.".format(transactions_total_rows, cash_sales_rows, round((cash_sales_rows/transactions_total_rows)*100, 2)))


# Foreclosures
foreclosures = transactions.loc[transactions['document_type'] == 'FORECLOSURE']
foreclosure_rows = len(cash_sales)
print("Of the {} total rows in the dataset, {} rows are categorized as foreclosures. This is {} percent of the total dataset.".format(transactions_total_rows, foreclosure_rows, round((foreclosure_rows/transactions_total_rows)*100, 2)))
"""

"""
total_rows = len(transactions)


print("In this sample dataset, there are {} rows".format(total_rows))
vacant_props = len(transactions.loc[transactions['PROPCLASS'] == 'V'])
print("In this sample dataset, {} of the possible {} total rows are vacant, which is {} percent.".format(vacant_props, total_rows, round((vacant_props/total_rows) * 100, 1)))

# SALETYPE
print(len(transactions['SALETYPE'].notnull()))

transactions = transactions[['FIPS', 'SALETYPE']]
grouped = transactions.groupby('SALETYPE').count()
print(grouped)

print(transactions['SALETYPE'].unique())
"""
"""
# No tract
no_tract = len(transactions.loc[transactions['FIPS'].isnull()])
print("Of the {} records, {} of them have no FIPS, or {} percent.".format(total_rows, no_tract, round((no_tract/total_rows) * 100, 1)))


# Mortgage Transactions
mortgages = len(transactions.loc[transactions['DEEDTYPE'].notnull()])
print(mortgages)

# Nominal transactions
nominal = len(transactions.loc[transactions['NOMINAL'].notnull()])
print(nominal)

nominal_vals = transactions['NOMINAL'].unique()
print(nominal_vals)

deed_type_vals = transactions['DEEDTYPE'].unique()
print(deed_type_vals)

print(list(transactions))

transactions = transactions[['TRANID', 'FIPS', 'PRICE', 'DATE', 'DEEDTYPE', 'SALETYPE', 'NOMINAL', 'VALIDSALE', 'MORTGAGE', 'PROPUSE', 'MTGTYPE', 'ForeclosureFlag']]
print(transactions.head(10))

# DOC_TYPE

deed_transactions = transactions.loc[transactions['DEEDTYPE'] == 27]
print(len(deed_transactions))

cash_sale_deed = transactions.loc[transactions['DEEDTYPE'] == 15]
print(len(cash_sale_deed))
"""
"""
# Summary stats
median_price_all = transactions['PRICE'].median()
print(median_price_all)
"""
