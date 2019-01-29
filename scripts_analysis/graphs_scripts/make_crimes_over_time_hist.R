library('data.table')
library(tidyverse)
library(sf)
library(extrafont)


crimes = readRDS('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/intermediate_data/crimes_agg_dt.rds')

crimes_over_time = ggplot(crimes, aes(x = year)) +
    geom_histogram(bins = 21, col = "white", fill = "maroon") +
    xlab("Year") +
    ylab("Count of Crimes") + 
    ggtitle("Crimes over Time") + 
    # labs(x = "Year", y = "Number of Crimes", title = "Crimes over time") +
    theme(plot.title =element_text(size=16,  family="Lato"),
          axis.text=  element_text(size=10,  family="Lato"),
          axis.title = element_text(size=13,  family="Lato"),
          text = element_text(family = "Lato"))

ggsave('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/crimes_over_time.png', width = 8, height = 4, units = "in", dpi = 600)