library(tidycensus)
library(tidyverse)
library(tidycensus)
library(sf)
library(htmltools)
library(leaflet)
library(extrafont)

ungreened_vacant_lot_descriptions = c('VACANT LOT KEEP CLEAN GET LIC',
                                      'LICENSE - VACANT LOT', 
                                      'VACANT LOT STANDARD', 
                                      'EXT A-VACANT LOT CLEAN/MAINTAI' )

li_vacant_url = "https://phl.carto.com/api/v2/sql?format=GeoJSON&q=SELECT address,caseaddeddate,caseresolutiondate,violationdate,violationtype,violationdescription,status,casestatus,casegroup,geocode_x,geocode_y,the_geom FROM li_violations WHERE  (violationdescription LIKE '%VACANT%') and (violationdescription NOT LIKE '%BLDG%') and (violationdescription NOT LIKE '%PROP%') LIMIT 500000"

li_vacant_dup = st_read(URLencode(li_vacant_url)) %>%
  mutate(full_address = paste0(address, ", PHILADELPHIA, PA"),
         full_address = as.character(full_address)) %>%
  #keepl only vacant lots that are in list of greened vacant lots
  filter(full_address %in% toupper(greened_lots_sf$full_address)) %>%
  #only keep lots whose violation descriptions match the ones in the ungreened vacant lot list above
  filter(violationdescription %in% ungreened_vacant_lot_descriptions) %>%
  as.data.frame() %>% 
  distinct(full_address, .keep_all = T) %>% 
  st_as_sf()

phl_city_bounds = st_read("http://data.phl.opendata.arcgis.com/datasets/405ec3da942d4e20869d4e1449a2be48_0.geojson") %>% st_transform(4326)
names(phl_city_bounds$geometry) = NULL


g_title <- tags$p(tags$b("Duplicate Lots"))

dup_lots_map = leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addCircles(data = li_vacant_dup,
             weight = 3,
             opacity = 0.7,
             fill =T,
             radius = 2,
             stroke = F,
             color = "brown") %>%
  addPolygons(data = phl_city_bounds,
              weight = 3,
              fill= F, 
              color = "#757575") %>%
  addControl(g_title, position = "topleft")


#Then manually screenshot with pixel resolution: 1833x1040
dup_lots_map

