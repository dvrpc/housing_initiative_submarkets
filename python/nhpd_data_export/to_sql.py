import pandas as pd
import sqlalchemy
import psycopg2

from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:dvrpc@localhost:5433/housing_initiative')


nhpd = pd.read_excel("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\NHPD\\20220830_download\\Active Properties.xlsx")

nhpd.to_sql('102022_nhpd', engine, schema='nhpd')
