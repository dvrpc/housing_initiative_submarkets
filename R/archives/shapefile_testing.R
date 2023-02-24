# install.packages("rgdal")
# install.packages("maptools")
# install.packages("dplyr")
# install.packages("raster")

library(rgdal)
library(maptools)
library(dplyr)
library(raster)

x <- readOGR("G:\\My Drive\\Region_Tracts_Shapefile\\gis.demographics.shp")

#Import ACS data
acs <- read.csv("G:\\Shared drives\\FY22 Regional Housing Initiative\\Data\\ACS5_2019\\acs5_2019_variables.csv")

m <- merge(x, acs, by.x='geoid', by.y='GEOID')

shapefile(m, "G:\\My Drive\\test_region_shapefile\\test_region_shapefile.shp")

writeOGR(m, ".", "G:\\My Drive\\test_region_shapefile\\test_region_shapefile.shp", 
         driver = "ESRI Shapefile")