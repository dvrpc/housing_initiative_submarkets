# install.packages("dplyr")
# install.packages("tidyverse")
# install.packages("magrittr")
# install.packages("pipeR")
# install.packages("factoextra")
# install.packages("cluster")

library(dplyr)
library(factoextra)
library(cluster)

df <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\ACS5_2020\\acs5_2020_variables.csv", colClasses=c("GEOID"="character", "year"="character"), row.names="GEOID")
df <- select(df, -c(year, HH_TOT, POP_TOT, UNIT_MIS))

# Find missing values
list_na <- colnames(df)[apply(df, 2, anyNA)]
list_na

# Impute missing values
df_impute_median <- data.frame(
  sapply(
    df,
    function(x) ifelse(is.na(x),
                       median(x, na.rm = TRUE),
                       x)))

print(df_impute_median)

# Scale dataframe
df_scale <- scale(df_impute_median)

wbPam <- pam(x=df_scale, k=8, keep.diss=TRUE, keep.data=TRUE)

gap_stat <- clusGap(df_scale,
                    FUN = pam,
                    K.max = 15,
                    B = 50)

fviz_gap_stat(gap_stat)