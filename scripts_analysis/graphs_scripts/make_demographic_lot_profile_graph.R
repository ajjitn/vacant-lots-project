library(tidyverse)
library(extrafont)
library(grid)
library(gridExtra)
# font_import()
loadfonts()
# urbnthemes::set_urbn_defaults('web')

stats_file = paste0("C:/Users/ajjit/Downloads/greened_lots.geojson_stats.csv")
# map_file = paste0("C:/Users/ajjit/Box Sync/open_data_bias/test_data/output1/", "map_data/",params$location, "_", params$dataset,".csv")

#log = suppressMessages(read_csv(log_file))
# map_data = suppressMessages(read_csv(map_file))
stats = suppressMessages(read_csv(stats_file))
# map_data = st_as_sf(map_data, wkt ="geometry")


#creating hhuman readable variable names
var_names = data_frame(statistic = c('pct_bach','pct_pov','pct_unemp','pct_white','pct_black','pct_anai',
                                     'pct_asian','pct_nh_pi','pct_other_race', 'pct_two_race', 'pct_hisp',
                                     'pct_smaller_races'),
                       full_name = c("Bachelor's degree or higher", "Families in poverty (last 12 months)",
                                     "Unemployment rate","White non-Hispanic ", "Black non-Hispanic ", 
                                     "Alaskan Native/American Indian non-Hispanic ", "Asian non-Hispanic ",
                                     "Native Hawaiian/Pacific Islander non-Hispanic ","Percent Other",
                                     "Two or more races", "Hispanic","Other race non-Hispanic"))
var_names$full_name = str_wrap(var_names$full_name, width = 15)

#getting means and sds in human readbale format
means = stats %>%
  select(-starts_with("hh"), -ends_with("sd")) %>%
  mutate(mean = c("Citywide Average","Greened Lots Average", "Control Lots Average"))%>%
  gather(statistic, value, - mean) 


data = stats %>% 
  select(contains("sd")) %>% 
  slice(1) %>%
  gather(sd_category, sd) %>% 
  select(sd) %>%
  mutate(statistic = unique(means$statistic), 
         mean = "Citywide Average") %>% right_join(means, by = c("mean" = "mean", 
                                                                 "statistic" = "statistic")) %>%
  select(statistic, mean, value, sd) %>% left_join(var_names, by = c("statistic" = "statistic")) %>%
  filter(!statistic %in% c("pct_anai","pct_nh_pi",
                           "pct_other_race","pct_two_race")) %>%
  mutate(statistic = ifelse(statistic =="pct_smaller_races",
                            "pct_other", statistic))

#setting factor order on names for prettier plots
data$full_name <- factor(data$full_name, levels=unique(data$full_name))

#setting colors
colors= c("#9d9d9d", "#e89474", "#96e874")


theme_lato = theme( title   = element_text(size  = 13, family = 'CMU Serif'),
                    axis.title = element_text(size = 12, family = 'CMU Serif'),
                    axis.text =  element_text(size = 10.5, family = 'CMU Serif'),
                    strip.text = element_text(size = 12, family = 'CMU Serif'),
                    legend.text= element_text(size=12,   family = 'CMU Serif'))



demo_plot = ggplot(data, aes(x=full_name, y = value, color = mean))+
  geom_point(size=2.6) +
  labs(#title=paste(city_name, data, "Demographic Bias"),
    y="Percentage of Residents", x="") +
  scale_y_continuous(labels = function(x) paste0(x, "%"), limits = c(0,80))+
  scale_color_manual(labels =c("Citywide Average", "Control Lots Average", "Greened Lots Average"), 
                     values=colors) +
  # ggtitle("Demographic Profile of Lots") +
  theme(axis.ticks.x = element_blank(),
        legend.position = "top",
        legend.title=element_blank()) +
  theme_lato


ggsave( 'C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/demo_profil_lots.png',  width = 8, height = 4, units = "in", dpi = 600)




