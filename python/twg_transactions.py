# Author: Brian Carney
# Purpose: This script evaluates sample transactions dataset from The Warren Group.

import pandas as pd

# Transactions
transactions = pd.read_csv(r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt", sep="\t", index_col='PROPID')
total_rows = len(transactions)


print("In this sample dataset, there are {} rows".format(total_rows))
vacant_props = len(transactions.loc[transactions['PROPCLASS'] == 'V'])
print("In this sample dataset, {} of the possible {} total rows are vacant, which is {} percent.".format(vacant_props, total_rows, round((vacant_props/total_rows) * 100, 1)))

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
# Summary stats
median_price_all = transactions['PRICE'].median()
print(median_price_all)
"""