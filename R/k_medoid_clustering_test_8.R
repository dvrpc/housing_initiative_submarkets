# install.packages("dplyr")
# install.packages("tidyverse")
# install.packages("magrittr")
# install.packages("pipeR")


df <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\ACS5_2020\\acs5_2020_variables.csv", colClasses=c("GEOID"="character", "year"="character"))
df <- scale(df)