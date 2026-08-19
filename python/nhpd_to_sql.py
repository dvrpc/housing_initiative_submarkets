import pandas as pd
import sqlalchemy
import psycopg2
import openpyxl
from settings import dw_creds

from sqlalchemy import create_engine

engine = create_engine(dw_creds)


nhpd = pd.read_excel(
    "G:/Shared drives/Planning Innovation/Support/FY2027/housing_submarkets/nhpd_20260818.xlsx",
    dtype={"Zip": str, "CBSACode": str, "CountyCode": str, "CensusTract": str},
)

nhpd.to_sql("20260818_nhpd", engine, schema="nhpd", if_exists="replace")
