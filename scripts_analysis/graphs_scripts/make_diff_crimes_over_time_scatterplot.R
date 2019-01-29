library(tidyverse)

lots = readRDS("final_data/lots.rds")

#add Year column for easier plotting
lots = lots %>% 
  mutate(year_season_begin = year(date_season_begin))


# convert logical vec to human readable names
lot_greened_names = c(`TRUE` = "Greened Lots",
                      `FALSE` = "Ungreened Lots")

theme_lato = theme( title   = element_text(size  = 13, family = 'CMU Serif'),
                    axis.title.x = element_text(size = 13, family = 'CMU Serif'),
                    axis.title.y = element_text(size = 11, family = 'CMU Serif'),
                    
                    axis.text =  element_text(size = 12, family = 'CMU Serif'),
                    strip.text = element_text(size = 13, family = 'CMU Serif'),
                    legend.text= element_text(size=12,   family = 'CMU Serif'))


diff_crimes_over_time = ggplot(lots, aes (x = year_season_begin, y = diff_all_70m)) + 
  geom_point(col = "maroon", alpha = 0.6, size = 0.5) + 
  geom_smooth(formula = y~x, col = "darkgreen", alpha = 0.5) + 
  labs(x = "Year", y = "Difference in Number of Crimes (70 Meter buffer)") + 
  scale_x_continuous(breaks = c(1993, 1997, 2001, 
                                2005, 2009, 2013, 2017)) + 
  facet_grid(greened ~ ., labeller = as_labeller(lot_greened_names)) + 
  theme_lato


ggsave('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/diff_crimes_over_time.png', width = 8, height = 4, units = "in", dpi = 600)