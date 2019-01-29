library(tidyverse)
library('sf')
library('mapview')
library(leaflet)
library(htmltools)


lots = readRDS("C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/final_data/lots.rds")

lots_greened = lots %>% filter(greened)  %>% st_transform(4326)
lots_ungreened = lots %>% filter(!greened)  %>% st_transform(4326)
phl_city_bounds = st_read("http://data.phl.opendata.arcgis.com/datasets/405ec3da942d4e20869d4e1449a2be48_0.geojson") %>% st_transform(4326)

names(phl_city_bounds$geometry) = NULL

g_title <- tags$p(tags$b("Greened Lots"))

greened_lots_map = leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
 addProviderTiles('CartoDB.Positron') %>%
 addCircles(data = lots_greened,
            weight = 2,
            opacity = 0.6,
            fill =T,
            radius = 1.5,
            stroke = F,
            color = "darkgreen") %>%
addPolygons(data = phl_city_bounds,
            weight = 2,
            fill= F, 
            color = "#757575") %>%
addControl(g_title, position = "topleft")



g_title <- tags$p(tags$b("Ungreened Lots"))

ungreened_lots_map = leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  addProviderTiles('CartoDB.Positron') %>%
  addCircles(data = lots_ungreened,
             weight = 2,
             opacity = 0.6,
             fill =T,
             radius = 1.5,
             stroke = F,
             color = "steelblue") %>%
  addPolygons(data = phl_city_bounds,
              weight = 2,
              fill= F, 
              color = "#757575") %>%
  addControl(g_title, position = "topleft")


## use lattice veiw to get side by side leaflet maps, then I manually screenshot
latticeview(greened_lots_map, ungreened_lots_map)



