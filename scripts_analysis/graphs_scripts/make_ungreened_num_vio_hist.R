library(tidycensus)
library(tidyverse)
library(tidycensus)
library(sf)
library(htmltools)
library(leaflet)
library(extrafont)

li_vacant_url = "https://phl.carto.com/api/v2/sql?format=GeoJSON&q=SELECT address,caseaddeddate,caseresolutiondate,violationdate,violationtype,violationdescription,status,casestatus,casegroup,geocode_x,geocode_y,the_geom FROM li_violations WHERE  (violationdescription LIKE '%VACANT%') and (violationdescription NOT LIKE '%BLDG%') and (violationdescription NOT LIKE '%PROP%') LIMIT 500000"

li_vacant_sf = read_in_vacant_lot_data(li_vacant_url)



ggplot(li_vacant_sf, aes(x = n_violations)) + geom_bar(fill = "darkgreen") + labs(x = "Number of Violations", y = "Count", title = "Number of Violations for Ungreened Vacant Lots (L&I)") + 
  theme(plot.title =element_text(size=14,  family="CMU Serif"),
        axis.text.x =  element_text(size=11,  family="CMU Serif"),
        axis.text.y =  element_text(size=11,  family="CMU Serif"),
        axis.title = element_text(size=12,  family="CMU Serif"),
        text = element_text(family = "CMU Serif")) + 
  scale_y_continuous(label = scales::comma) 
  



ggsave('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/num_violations_ungreened_hist.png', width = 8, height = 4, units = "in", dpi = 600)

