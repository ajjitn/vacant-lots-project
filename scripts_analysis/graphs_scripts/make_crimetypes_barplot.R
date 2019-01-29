library('data.table')
library(tidyverse)
library(sf)
library(extrafont)


crimes = readRDS('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/intermediate_data/crimes_agg_dt.rds')



crimetypes_barplot = ggplot(crimes, aes(x = crimetype_05)) +
  geom_bar(fill = "maroon")+ 
  xlab("Crimetype") +
  ylab("Count") + 
  # ggtitle("Crime Counts by Crimetype (1995 - 2018)") + 
  scale_y_continuous(label = scales::comma) +
  theme(plot.title =element_text(size=14,  family="CMU Serif"),
        axis.text.x =  element_text(size=11,  family="CMU Serif", angle  = 45, hjust = 1),
        axis.text.y =  element_text(size=11,  family="CMU Serif"),
        axis.title = element_text(size=12,  family="CMU Serif"),
        text = element_text(family = "CMU Serif"))

ggsave('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/crimetypes_breakdown.png', width = 8, height = 4, units = "in", dpi = 600)
