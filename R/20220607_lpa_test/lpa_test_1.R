# install.packages("tidyLPA")
# install.packages("magrittr")

library(tidyLPA)
library(dplyr)
library(magrittr)

acs2020 <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\ACS5_2020\\acs5_2020_variables.csv", row.names = 1, header = TRUE)

myVars <- c("HHINC_MED", "MED_HVAL", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P")
myVars2 <- c("HHINC_MED", "MED_HVAL", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "Class")


acs2020 <- acs2020[myVars]
tracts <- row.names(acs2020)


# getting median of each column using apply() 
all_column_median <- apply(acs2020, 2, median, na.rm=TRUE)

# imputing median value with NA 
for(i in colnames(acs2020))
  acs2020[,i][is.na(acs2020[,i])] <- all_column_median[i]

acs2020

# Export 1
m3 <- acs2020 %>%
  estimate_profiles(8)

export_1 <- get_data(m3)



# Subset columns
reduced_df <- export_1[myVars2]

# Append index
rownames(reduced_df) <- row.names(acs2020)

# Write csv
write.csv(reduced_df, "C:\\Users\\bcarney\\Desktop\\lpa_testing\\reduced_df.csv")

# Group by cluster and get median
grouped_df <- aggregate(reduced_df, by = list(reduced_df$Class), FUN = "median")


# ----
# Test to see if the clusters are the same with another run through. they were the same.
# Export 2
m4 <- acs2020 %>%
  estimate_profiles(8)

export_2 <- get_data(m4)

write.csv(export_2, "C:\\Users\\bcarney\\Desktop\\lpa_testing\\export_2.csv")

