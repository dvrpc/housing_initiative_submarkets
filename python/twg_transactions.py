# Author: Brian Carney
# Purpose: This script evaluates sample transactions dataset from The Warren Group.

import pandas as pd
import openpyxl

# Transactions
transactions = pd.read_csv(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt",
    dtype={
        "DEEDTYPE": str,
        "SALETYPE": str,
        "PROPUSE": str,
        "MTGTYPE": str,
        "PROPUSE": str,
    },
    sep="\t",
    low_memory=False,
)


# Calculate total number of rows
transactions_total_rows = len(transactions)
print("In the transactions dataset, there are {} rows".format(transactions_total_rows))


# PROPUSE Groupby
usage_condensed = transactions[["PROPUSE"]]
usage_condensed["COUNT"] = ""
results = usage_condensed.groupby("PROPUSE").count()
print(results)


# Lookup Tables ---


# DOC_TYPE Lookup
doc_type_lookup = pd.read_excel(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\TWG_Data Dictionary_All Record Layouts.xlsx",
    sheet_name="DOC_TYPE",
    dtype={"CODE": str},
    index_col="CODE",
)
print(doc_type_lookup)


# USAGE Lookup
usage_lookup = pd.read_excel(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\TWG_Data Dictionary_All Record Layouts.xlsx",
    sheet_name="USAGE",
    dtype={"code": str},
    index_col="code",
)
print(usage_lookup)

# LU_CODE Lookup
lu_code_lookup = pd.read_excel(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\TWG_Data Dictionary_All Record Layouts.xlsx",
    sheet_name="LU_CODE ",
    dtype={"CODE": str},
    index_col="CODE",
)

# SALETYPE Lookup
sale_type_lookup = pd.read_excel(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\TWG_Data Dictionary_All Record Layouts.xlsx",
    sheet_name="SALETYPE",
    dtype={"code": str},
    index_col="code",
)


# TRAN_TYPE Lookup
tran_type_lookup = pd.read_excel(
    r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\TWG_Data Dictionary_All Record Layouts.xlsx",
    sheet_name="TRAN_TYPE",
    dtype={"TransType": str},
    index_col="TransType",
)


# Join PROPUSE with LU_CODE
prop_use_results = lu_code_lookup.merge(results, how="inner", left_index=True, right_index=True)

prop_use_results.to_csv(r"C:\Users\bcarney\Desktop\test_data\prop_use_results.csv")
# Note: Did this to see the property use for these records. Mostly (90-95 percent) residential. Nearly twice as many records as Estated.

# DEEDTYPE
use_type = transactions[["DEEDTYPE"]]
use_type["count"] = ""
use_type_grouped = use_type.groupby("DEEDTYPE").count()

# print(len(use_type.loc[use_type["DEEDTYPE"].isnull()]))


# Distressed Sales
distressed_sale = transactions.loc[transactions["distressed_sale"] == "t"]
distressed_sale_rows = len(distressed_sale)
print(
    "Of the {} total rows in the dataset, {} rows are categorized as distressed sales. This is {} percent of the total dataset.".format(
        transactions_total_rows,
        distressed_sale_rows,
        round((distressed_sale_rows / transactions_total_rows) * 100, 2),
    )
)


# Real Estate Owned
real_estate_owned = transactions.loc[
    (transactions["real_estate_owned"] != "NO") & (transactions["real_estate_owned"].notnull())
]
real_estate_owned_rows = len(real_estate_owned)
print(
    "Of the {} total rows in the dataset, {} rows are categorized as real estate owned sales. This is {} percent of the total dataset.".format(
        transactions_total_rows,
        real_estate_owned_rows,
        round((real_estate_owned_rows / transactions_total_rows) * 100, 2),
    )
)


# Cash Sales
cash_sales = transactions.loc[
    (transactions["loan_type"] == "CASH") | (transactions["document_type"] == "CASH SALE")
]
cash_sales_rows = len(cash_sales)
print(
    "Of the {} total rows in the dataset, {} rows are categorized as cash sales. This is {} percent of the total dataset.".format(
        transactions_total_rows,
        cash_sales_rows,
        round((cash_sales_rows / transactions_total_rows) * 100, 2),
    )
)


# Foreclosures
foreclosures = transactions.loc[transactions["document_type"] == "FORECLOSURE"]
foreclosure_rows = len(cash_sales)
print(
    "Of the {} total rows in the dataset, {} rows are categorized as foreclosures. This is {} percent of the total dataset.".format(
        transactions_total_rows,
        foreclosure_rows,
        round((foreclosure_rows / transactions_total_rows) * 100, 2),
    )
)


print("In this sample dataset, there are {} rows".format(transactions_total_rows))
vacant_props = len(transactions.loc[transactions["PROPCLASS"] == "V"])
print(
    "In this sample dataset, {} of the possible {} total rows are vacant, which is {} percent.".format(
        vacant_props,
        transactions_total_rows,
        round((vacant_props / transactions_total_rows) * 100, 1),
    )
)

# SALETYPE
print(len(transactions["SALETYPE"].notnull()))

transactions = transactions[["FIPS", "SALETYPE"]]
grouped = transactions.groupby("SALETYPE").count()
print(grouped)

print(transactions["SALETYPE"].unique())
"""
"""
# No tract
no_tract = len(transactions.loc[transactions["FIPS"].isnull()])
print(
    "Of the {} records, {} of them have no FIPS, or {} percent.".format(
        transactions_total_rows,
        no_tract,
        round((no_tract / transactions_total_rows) * 100, 1),
    )
)


# Mortgage Transactions
mortgages = len(transactions.loc[transactions["DEEDTYPE"].notnull()])
print(mortgages)

# Nominal transactions
nominal = len(transactions.loc[transactions["NOMINAL"].notnull()])
print(nominal)

nominal_vals = transactions["NOMINAL"].unique()
print(nominal_vals)

deed_type_vals = transactions["DEEDTYPE"].unique()
print(deed_type_vals)

print(list(transactions))

transactions = transactions[
    [
        "TRANID",
        "FIPS",
        "PRICE",
        "DATE",
        "DEEDTYPE",
        "SALETYPE",
        "NOMINAL",
        "VALIDSALE",
        "MORTGAGE",
        "PROPUSE",
        "MTGTYPE",
        "ForeclosureFlag",
    ]
]
print(transactions.head(10))

# DOC_TYPE

deed_transactions = transactions.loc[transactions["DEEDTYPE"] == 27]
print(len(deed_transactions))

cash_sale_deed = transactions.loc[transactions["DEEDTYPE"] == 15]
print(len(cash_sale_deed))

# Summary stats
median_price_all = transactions["PRICE"].median()
print(median_price_all)


# DOCTYPE Groupby
doc_type_condensed = transactions[["DOC_TYPE"]]
doc_type_condensed["COUNT"] = ""
doc_type_grouped = doc_type_condensed.groupby("DOC_TYPE").count()
print(doc_type_grouped)
