# Import libraries
library(tidyLPA)
library(dplyr)
library(magrittr)
library(matrixStats)
library(textshape)
library(tidyr)
library(tibble)
library(sf)
# install.packages("networkD3") 
library(networkD3)

# 
# setwd("G:\\My Drive\\HousingInitiative\\RHI\\secrets.R")
# 
# source("secrets.R")
# 
# conn <- dbConnect(
#   RPostgres::Postgres(),
#   dbname = my_dbname,
#   host = my_host,
#   port = my_port,
#   user = my_username,
#   password = my_password
# )

#census tracts:
census_tracts_2020 <- read_sf("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\shapefiles\\census_tracts.shp") %>% dplyr::select(GEOID)

# Import data
acs2020_raw <- read.csv("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\acs5_2020_variables.csv", colClasses = c("GEOID"="character"))

myVars <- c("HHINC_MED", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "pct_subsidized", "med21", "pct_diff", "HHS_1", "HHS_2to4", "HHS_5P", "hu_acre")
myVars_Class <- c("HHINC_MED", "RENT_MED", "TEN_RENT", "TEN_OWN", "VCY", "HHI_150P", "YB_59E", "YB_6099", "YB_00L", "UNIT_1", "UNIT_2to4", "UNIT_5P", "pct_subsidized", "med21", "pct_diff", "HHS_1", "HHS_2to4", "HHS_5P", "hu_acre", "Class")

mediansaleprice_subsidizedhousing_new <- read.csv("G://Shared drives//FY22 Regional Housing Initiative//SubmarketAnalysis//data//region_tracts_mediansaleprice_subsidizedhousingunits_new.csv", colClasses = c("geoid"="character"))%>%
  rename(subsidizedunits = Total.Subsidized.Units) %>%
  mutate(subsidizedunits = ifelse(is.na(subsidizedunits), 0, subsidizedunits)) %>%
  select(geoid, subsidizedunits, med21, pct_diff)

joined_df <- merge(acs2020_raw, mediansaleprice_subsidizedhousing_new, by.x="GEOID", by.y="geoid") %>%
  drop_na(med21) %>% 
  filter(HH_TOT > 0) %>%
  mutate(pct_subsidized = round((subsidizedunits/UNITS_TOT) * 100, 2)) %>%
  column_to_rownames(., "GEOID")

tracts <- row.names(joined_df)

joined_df_clean <- joined_df %>%
  select(all_of(myVars)) %>%
  mutate_if(is.numeric, function(x) ifelse(is.na(x), median(x, na.rm = T), x))

joined_df_clean_medians <- joined_df_clean %>%
  apply(., 2, median)

# getting results not scaled (for merge): 

export_0 <- get_data(joined_df_clean %>%
                       estimate_profiles(8))

reduced_df <- export_0[myVars_Class]
rownames(reduced_df) <- tracts

reduced_df <- rownames_to_column(reduced_df, var = "geoid")
reduced_df <- merge(census_tracts_2020,reduced_df,by.x="GEOID", by.y="geoid",all=TRUE)


# scale & v1 variables:

joined_df_scaled_reduced_v1 <- joined_df_clean %>% 
  dplyr::select(-TEN_RENT,-HHI_150P,-YB_6099,-UNIT_5P,-HHS_1)

joined_df_scaled_reduced_v1 <- scale(joined_df_scaled_reduced_v1)

export_1 <- get_data(joined_df_scaled_reduced_v1 %>% estimate_profiles(8))

reduced_df_scaled_v1 <- export_1[c("HHINC_MED", "RENT_MED", "TEN_OWN", "VCY",  "YB_59E", 
                                   "YB_00L", "UNIT_1", "UNIT_2to4",  "pct_subsidized", 
                                   "med21", "pct_diff", "HHS_2to4", "HHS_5P", "hu_acre", "Class")]

rownames(reduced_df_scaled_v1) <- tracts

# reduced_df_scaled_v1 <- rownames_to_column(reduced_df_scaled_v1, var = "geoid") %>%
#   select(geoid, Class) %>%
#   rename("GEOID" = "geoid") %>%
#   rename("NewClass" = "Class")

# 
# reduced_df_scaled_v1 <- merge(census_tracts_2020,reduced_df_scaled_v1,by.x="GEOID", by.y="geoid",all=TRUE)
# 
# reduced_df_scaled_v1 %>% group_by(Class) %>% summarize(n())
# 
# temp <- merge(reduced_df_scaled_v1 %>% dplyr::select(GEOID,Class) %>% st_set_geometry(NULL),
#               reduced_df %>% dplyr::select(-Class)%>% st_set_geometry(NULL), by="GEOID") %>% dplyr::select(-GEOID)
# 
# temp <- drop_na(temp)
# 
# submarket_medians_v1_fixed <- aggregate(temp,by =list(temp$Class), FUN = "median")%>% subset(select = -c(Group.1))

# to write into csv
write.csv(submarket_medians_v1_fixed,"G://Shared drives//FY22 Regional Housing Initiative//SubmarketAnalysis//data//submarket_medians_v1_fixed.csv")

# to export a shapefile
st_write(reduced_df_scaled_v1, "G://Shared drives//FY22 Regional Housing Initiative//SubmarketAnalysis//data//submarkets_clusters_scaled_reduced_v1.shp")

# dbDisconnect(conn)


# Old and New Result Comparison ----

# Import old results
old_submarkets <- read.csv("U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\LPA_Test3_Submarkets\\lpa_results_3_submarkets.csv")

rownames(old_submarkets) <- old_submarkets$X

old_submarkets <- old_submarkets %>%
  rename("OldClass" = "Class")

old_submarkets$GEOID <- old_submarkets$X

# Import new results
new_submarkets <- reduced_df_scaled_v1 %>%
  rename("NewClass" = "Class")

new_submarkets$GEOID <- tracts

# Merge dataframes
combined_results <- merge(new_submarkets, old_submarkets, by.x="GEOID", by.y="X") %>%
  select(GEOID, NewClass, OldClass)

write.csv(combined_results, "G:\\My Drive\\HousingInitiative\\submarkets_combined_results.csv")


# Sankey Diagram ----
# sankey_2 <- merge(old_submarkets %>% dplyr::select(GEOID,OldClass)%>%st_set_geometry(NULL),
#                   new_submarkets %>% dplyr::select(GEOID,NewClass)%>%st_set_geometry(NULL),by="GEOID")
# 
# colnames(sankey_2) <- c("geoid","class_old","class_new")

links <- as.data.frame(combined_results %>% group_by(OldClass,NewClass) %>% summarise(n()))
colnames(links) <- c("source", "target", "value")

links$source <- paste("class_old_",as.character(links$source),sep="")
links$target <- paste("class_new_",as.character(links$target),sep="")

nodes <- data.frame(name=c("class_old_1","class_old_2","class_old_3","class_old_4","class_old_5","class_old_6","class_old_7","class_old_8",
                           "class_new_1","class_new_2","class_new_3","class_new_4","class_new_5","class_new_6","class_new_7","class_new_8"))

my_color <- 'd3.scaleOrdinal() .domain(["a", "b"]) .range(["#69b3a2", "steelblue"])'

links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

nodes$group <- as.factor(c("a","a","a","a","a","a","a","a",
                           "b","b","b","b","b","b","b","b"))

s2 <- sankeyNetwork(Links = links, Nodes = nodes,
                    Source = "IDsource", Target = "IDtarget",
                    Value = "value", NodeID = "name", fontSize= 12,
                    colourScale=my_color, NodeGroup="group", iterations = 0)

s2