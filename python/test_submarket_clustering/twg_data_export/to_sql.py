import pandas as pd
import sqlalchemy

from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:dvrpc@localhost:5433/housing_initiative')

df = pd.read_csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\TWG\\Deeds\\2016\\DVRPDeedMtg2016.txt", sep="\t", engine='python')
print(df)

df.to_sql('twg_deeds_2016', engine, schema='twg')