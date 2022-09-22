from datetime import date
from xmlrpc.client import _datetime
import pandas as pd
import sqlalchemy
import psycopg2

from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:dvrpc@localhost:5433/housing_initiative')

conn = psycopg2.connect(dbname="housing_initiative", user="postgres", host="localhost", port=5433, password="dvrpc")
cur = conn.cursor()

df  = cur.execute("SELECT * FROM 'twg'.'twg_deeds_2016';")
print(df)