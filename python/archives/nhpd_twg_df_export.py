import pandas as pd
import sqlalchemy
import psycopg2


conn = psycopg2.connect(
    database="housing_initiative", user="postgres", password="dvrpc", host="localhost", port="5433"
)


conn.autocommit = True
cursor = conn.cursor()

dataframe = pd.read_sql(
    """
            SELECT * FROM
            public.region_tracts_mediansaleprice_subsidizedhousingunits
            """,
    con=conn,
)

print(dataframe)

dataframe.to_csv(
    "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\region_tracts_mediansaleprice_subsidizedhousingunits.csv"
)
