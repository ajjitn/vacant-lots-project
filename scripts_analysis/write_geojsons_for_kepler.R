library(sf)
library(tidyverse)

#writing 4 geojson files for kepler visualizations
lots %>% filter(!greened)  %>% 
  select(full_address, date_season_begin, geometry, contains("70m"))  %>% 
  # select(full_address, date_season_begin, geometry, (contains("pct"))) %>% 
  select(-contains("num")) %>%
  mutate(datetime=as.POSIXct(date_season_begin)) %>%
  select(-date_season_begin) %>%
  st_transform(4326) %>% 
  st_write("C:/Users/ajjit/Downloads/ungreened_lots_70.geojson")

lots %>% filter(greened)  %>% 
  select(full_address, date_season_begin, geometry, contains("70m"))  %>% 
  # select(full_address, date_season_begin, geometry, (contains("pct"))) %>% 
  select(-contains("num")) %>%
  mutate(datetime=as.POSIXct(date_season_begin)) %>%
  select(-date_season_begin) %>%
  st_transform(4326) %>% 
  st_write("C:/Users/ajjit/Downloads/greened_lots_70.geojson")

lots %>% filter(!greened)  %>% 
  select(full_address, date_season_begin, geometry, contains("70m"))  %>% 
  # select(full_address, date_season_begin, geometry, (contains("pct"))) %>% 
  select(-contains("num")) %>%
  mutate(datetime=as.POSIXct(date_season_begin)) %>%
  select(-date_season_begin) %>%
  st_transform(4326) %>% 
  st_write("C:/Users/ajjit/Downloads/ungreened_lots_150.geojson")

lots %>% filter(greened)  %>% 
  select(full_address, date_season_begin, geometry, contains("70m"))  %>% 
  # select(full_address, date_season_begin, geometry, (contains("pct"))) %>% 
  select(-contains("num")) %>%
  mutate(datetime=as.POSIXct(date_season_begin)) %>%
  select(-date_season_begin) %>%
  st_transform(4326) %>% 
  st_write("C:/Users/ajjit/Downloads/greened_lots_150.geojson")



#getting histograms of difference in crimes
lots %>% filter(greened) %>% 
  select(contains("std")) %>%
  select(contains("70m")) %>%
  gather("stat", "value", -geometry) %>%
  st_set_geometry(NULL) %>%
  # as.data.frame() %>%
  ggplot(aes(x = value)) +
  geom_histogram(col = "white", fill  = "dark green", bins = 50) + 
  # geom_vline(aes(xintercept = mean(value)),col='red',size=1) +
  facet_wrap(vars(stat), nrow = 3)
ggtitle("Differnce in Stanardized Crimes per Unit Area - 70m") 

#getting histograms of % diff in crimes
lots %>% filter(greened) %>% 
  select(contains("pct_change")) %>%
  select(contains(1"70m"))%>%
  select(-contains("std")) %>%
  # gather("stat", "value", -geometry) %>%
  st_set_geometry(NULL) %>%
  ggplot(aes(x = value)) +
  geom_histogram(col = "white", fill  = "dark green", bins = 30) + 
  # geom_vline(aes(xintercept = mean(value)),col='red',size=1) +
  facet_wrap(vars(stat), nrow = 3)

lots %>% filter(greened) %>% 
  select(contains("pct_change")) %>%
  select(contains("70m"))%>%
  select(-contains("std")) %>%
  ggplot(x=)

lots %>% filter(greened) %>% 
  select(contains("pct_change")) %>%
  select(contains("70m"))%>%
  select(-contains("std"))
gather("stat", "value", -geometry)%>%
  group_by(stat) %>%
  summarize(mean =mean(value), median = median(value))
