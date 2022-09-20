from datetime import date
from xmlrpc.client import _datetime
import pandas as pd
import sqlalchemy
import psycopg2

from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:dvrpc@localhost:5433/housing_initiative')

deeds_2016 = pd.read_csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\TWG\\Deeds\\2016\\DVRPDeedMtg2016.txt", sep="\t", engine='python', parse_dates=['DATE'])

deeds_2016.to_sql('twg_deeds_2016', engine, schema='twg_raw', dtype={'DATE': sqlalchemy.Date()})

deeds_2021_20220715 = pd.read_csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\TWG\Deeds\\2021_2022\\20220715\\DVRPDeedMtg07152022.txt", sep="\t", engine='python', parse_dates=['DATE'])

deeds_2021_20220715.to_sql('twg_deeds_2021', engine, schema='twg_raw', dtype={'DATE': sqlalchemy.Date()})

properties_20220715 = pd.read_csv("G:\\Shared drives\\FY22 Regional Housing Initiative\Data\\TWG\\Properties\\20220715\\DVRPProp07152022.txt", sep="\t", engine='python', parse_dates=['LSTSLDATE'])

properties_20220715.to_sql('twg_properties_20220715', engine, schema='twg_raw', dtype={'LSTSLDATE': sqlalchemy.Date()}, chunksize=1000)

properties_20220722 = pd.read_csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\TWG\\Properties\\20220722\\DVRPProp07222022.txt", sep="\t", engine='python', parse_dates=['LSTSLDATE'])

properties_20220722.to_sql('twg_properties_20220722', engine, schema='twg_raw', dtype={'LSTSLDATE': sqlalchemy.Date()}, chunksize=1000)