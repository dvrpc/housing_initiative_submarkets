import pandas as pd
from sqlalchemy import create_engine
from settings import gis_db, postgres_pw

engine = create_engine(
    "postgresql://postgres:{}@localhost:5433/housing_initiative".format(postgres_pw)
)

circuittrails = pd.read_sql("select * from public.circuittrails", engine)

print(circuittrails)
