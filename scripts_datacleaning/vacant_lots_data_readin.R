library(data.table)
library(lubridate)
library(rgdal)
library(stringr)
library(geosphere)
library(haven)
library(raster)
library(scales)
library(sp)
library(maptools)
library(qpcR)
library(sf)
library(reshape2)
library(broom)
library(tidyr)
library(lattice)
library(tidyverse)
library(gridExtra)
library(ggspatial)
select = dplyr::select
filter = dplyr::filter
melt = reshape2::melt

setwd("C:/Users/Ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project")


source("scripts_datacleaning/vacant_lots_helper_functions.R")


#######################################################
########### READ IN GREENED LOT DATA ##################
#######################################################

# raw_geocoded_greened_lots_data.rds = datsets wiht latslons geocoded
greened_lots_sf = readRDS("raw_data/raw_geocoded_greened_lots_data.rds")
greened_lots_sf = greened_lots_sf %>%
  distinct(full_address, .keep_all = T) %>%
  filter(!is.na(date_season_begin)) %>%
  arrange(desc(date_season_begin)) %>%
  mutate(date_season_begin = as.Date(as.POSIXct(format(date_season_begin)), format = "%Y-%m-%d", tz ="" ),
         date_season_end   = date_season_begin %m+% months(1),
         date_begin = date_season_begin %m-% months(11),
         date_end   = date_season_end %m+% months(11),
         greened = T
         # date_interval =  date_begin %--% date_end
  )%>%
  select(full_address, date_season_begin,date_season_end, date_begin, date_end, lon, lat, sq_ft, greened) %>%
  st_as_sf(agr = "constant", coords = c("lon","lat"), crs = 4326)



#######################################################
########### READ IN UNGREENED LOT DATA ################
#######################################################


# SQL query below Selects L&I properties that have the following conidtions:
# 1) violation description includes the word vacant
# 2) violation descrption doesnt include 'BLDG' (to exclude vacant buildings)
li_vacant_url = "https://phl.carto.com/api/v2/sql?format=GeoJSON&q=SELECT address,caseaddeddate,caseresolutiondate,violationdate,violationtype,violationdescription,status,casestatus,casegroup,geocode_x,geocode_y,the_geom FROM li_violations WHERE  (violationdescription LIKE '%VACANT%') and (violationdescription NOT LIKE '%BLDG%') and (violationdescription NOT LIKE '%PROP%') LIMIT 500000"

li_vacant_sf = read_in_vacant_lot_data(li_vacant_url)




#######################################################
############### READ IN CRIME DATA ####################
#######################################################



# THis is SQL query (in URL form) to the PostgreSQL Database that stores the crime data
# It will pull all crimes where lat/lon is not NULL (ie its reported) which is about 2.5 millionn records
# See here for more information on the SQL API: https://cityofphiladelphia.github.io/carto-api-explorer/#incidents_part1_part2
# See here for more information on the crime dataset: https://www.opendataphilly.org/dataset/crime-incidents
crime_data_url = "https://phl.carto.com/api/v2/sql?q=SELECT dispatch_date_time,ucr_general,text_general_code,point_x,point_y,the_geom FROM incidents_part1_part2 WHERE point_x is not NULL LIMIT 10000000&filename=crime_part1_part2&format=geojson&skipfields=cartodb_id"

#filepath to old crimes dataset
filepath_old_crimes_data = "raw_data/Philly_Crime_98to11_Final.dta"

#Read in both old and new  crime data using helper functions (Takes a long time!) and merge
crimes_old = clean_old_crime_data_for_joining(filepath_old_crimes_data)
crimes_new = clean_new_crime_data_for_joining(crime_data_url)
crimes_agg = merge_crime_data(crimes_old, crimes_new)
#To suppress warning messages when joining on crimes_agg later
st_agr(crimes_agg) = "constant"

crimes_agg = st_transform(crimes_agg, 32129)

crimes_agg_dt = data.table(crimes_agg)
saveRDS("intermediate_data/crimes_agg.rds")
saveRDS("intermediate_data/crimes_agg_dt.rds")


#######################################################
########### APPEND CRIME DATA TO LOTS #################
#######################################################

#Create combined ungreened and greened lot data
#sf doesn't yet support bind_rows, so lets drop geometry columns, bind rows, then reattach geometry columns
greened_lots_sf_data = st_set_geometry(greened_lots_sf, NULL)
li_vacant_sf_data = st_set_geometry(li_vacant_sf, NULL)
lots = bind_rows(greened_lots_sf_data, li_vacant_sf_data)
lots = st_sf(lots, geometry = c(greened_lots_sf$geometry, li_vacant_sf$geometry))
lots = st_transform(lots, 32129)

saveRDS("intermediate_data/lots.rds")



#After this script is run, we used gcloud compute instances to quickly append crime data to lots data. See scripts_gcloud folder for implementation details.
