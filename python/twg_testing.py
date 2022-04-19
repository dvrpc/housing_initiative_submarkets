# Author: Brian Carney
# Purpose: This script evaluates sample data from The Warren Group. It contains properties and transactions for Montgomery County since 2015.

import pandas as pd

properties = pd.read_csv(r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCProperties.txt", sep="\t", index_col='PROPID')
total_rows = len(properties)


print("In this sample dataset, there are {} rows".format(total_rows))
list(properties)


deeds = pd.read_csv(r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCTransactions.txt", sep="\t", index_col='TRANID')
list(deeds)

print(deeds['PROPUSE'].unique())