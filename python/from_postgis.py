import geopandas
from sqlalchemy import create_engine  
db_connection_url = "postgresql://postgres:dvrpc@localhost:5433/housing_initiative"
con = create_engine(db_connection_url)  
sql = '''SELECT * FROM nhpd.region_nhpd_properties'''
df = geopandas.GeoDataFrame.from_postgis(sql, con)