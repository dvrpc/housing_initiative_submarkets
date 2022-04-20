# Author: Brian Carney
# Purpose: This script evaluates sample properties dataset from The Warren Group.

import pandas as pd

# Properties
properties = pd.read_csv(r"G:\Shared drives\FY22 Regional Housing Initiative\Data\TWG Sample Data\Montgomery County\DVRPCProperties.txt", sep="\t", index_col='PROPID')
total_rows = len(properties)


print("In this sample dataset, there are {} rows".format(total_rows))
vacant_props = len(properties.loc[properties['PROPCLASS'] == 'V'])
print("In this sample dataset, {} of the possible {} total rows are vacant, which is {} percent.".format(vacant_props, total_rows, round((vacant_props/total_rows) * 100, 1)))

# No tract
no_tract = len(properties.loc[properties['FIPS'].isnull()])
print("Of the {} records, {} of them have no FIPS, or {} percent.".format(total_rows, no_tract, round((no_tract/total_rows) * 100, 1)))

# PROPCLASS
propclass = properties[['FIPS', 'PROPCLASS']]
properties['prop_total'] = propclass.groupby('PROPCLASS').count()
properties

""""
def g(x):
    d = {}
    d['residential'] = len(x.loc[x['PROPCLASS'] == 'R'])
    d['commercial'] = len(x.loc[x['PROPCLASS'] == 'C'])
    d['office'] = len(x.loc[x['PROPCLASS'] == 'O'])
    d['recreation'] = len(x.loc[x['PROPCLASS'] == 'F'])
    d['industrial'] = len(x.loc[x['PROPCLASS'] == 'I'])
    d['transportation'] = len(x.loc[x['PROPCLASS'] == 'T'])
    d['agriculture'] = len(x.loc[x['PROPCLASS'] == 'A'])
    d['vacant'] = len(x.loc[x['PROPCLASS'] == 'V'])
    d['exempt'] = len(x.loc[x['PROPCLASS'] == 'E'])
    return pd.Series(d, index=['residential', 'commercial', 'office', 'recreation', 'industrial', 'transportation', 'agriculture', 'vacant', 'exempt'])

totals_df = deeds.groupby('PROPCLASS').apply(g)
"""