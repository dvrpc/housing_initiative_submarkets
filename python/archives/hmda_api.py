import pandas as pd

url = "https://ffiec.cfpb.gov/v2/data-browser-api/view/csv?counties=34005,34007,34015,34021,42017,42029,42045,42091,42101&years=2021"

df = pd.read_csv(url, low_memory=False)

home_purchase = df.loc[df["loan_purpose"] == 1]
