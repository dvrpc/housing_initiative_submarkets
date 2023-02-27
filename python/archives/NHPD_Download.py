# Author: Brian Carney
# Last updated: 03/16/2022
# Purpose: This script downloads the National Housing Preservation Database (NHPD) using the urllib package.

import pandas as pd
import urllib3

http = urllib3.PoolManager()
r = http.request('GET', 'https://nhpd.preservationdatabase.org/Data')
print(r.data)

