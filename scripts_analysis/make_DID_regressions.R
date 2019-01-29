library(data.table)
library(tidyverse)
library(sf)
library(leaflet)
library(extrafont)
library(patchwork)
library(broom)
library(tidyr)

lots = readRDS("final_data/lots.rds")


crime_trans_df = data.table(crimetype = c('Aggravated Assaults',"All Thefts","Burglaries",
                                          "Disorderly Conduct", "Homicides", 
                                          "Public Drunkenness","Robberies","All","Violent","Non Violent"),
                            short_name = c("agg_ass","thefts",'burg','disord',"homi",'pub_dr',"robb","all",
                                           "vio","nonvio"))


lots_70m_did =  lots %>% select(contains("70m"), contains("500m"), greened, date_season_begin, full_address) %>% 
  select(-contains("diff")) %>% 
  mutate(greened = as.numeric(greened))


lots_70m_expanded = lots_70m_did %>% 
  #expand and left join by a dummy before_after variable
  expand(after = c(0,1), full_address) %>% 
  left_join(lots_70m_did, by = "full_address") %>%
  arrange(full_address) %>%
  mutate(all_70m =  dplyr::if_else(after==0, num_all_70m_before, num_all_70m_after),
         agg_ass_70m = dplyr::if_else(after==0, num_agg_ass_70m_before, num_agg_ass_70m_after),
         thefts_70m  = dplyr::if_else(after==0, num_thefts_70m_before, num_thefts_70m_after),
         burg_70m    = dplyr::if_else(after==0, num_burg_70m_before, num_burg_70m_after),
         disord_70m  = dplyr::if_else(after==0, num_disord_70m_before, num_disord_70m_after),
         homi_70m    = dplyr::if_else(after==0, num_homi_70m_before, num_homi_70m_after),
         pub_dr_70m  = dplyr::if_else(after==0, num_pub_dr_70m_before, num_pub_dr_70m_after),
         robb_70m    = dplyr::if_else(after==0, num_robb_70m_before, num_robb_70m_after),
         vio_70m     = dplyr::if_else(after==0, num_vio_70m_before, num_vio_70m_after),
         nonvio_70m  = dplyr::if_else(after==0, num_nonvio_70m_before, num_nonvio_70m_after),
         
         agg_ass_70m_per_km2_num= 1000000 * ((if_else(after ==0, num_agg_ass_70m_before, num_agg_ass_70m_after)) / (pi*(70^2))), 
         thefts_70m_per_km2_num = 1000000 * ((if_else(after ==0, num_thefts_70m_before, num_thefts_70m_after)) / (pi*(70^2))), 
         burg_70m_per_km2_num   = 1000000 * ((if_else(after ==0, num_burg_70m_before, num_burg_70m_after)) / (pi*(70^2))), 
         disord_70m_per_km2_num = 1000000 * ((if_else(after ==0, num_disord_70m_before, num_disord_70m_after)) / (pi*(70^2))), 
         homi_70m_per_km2_num   = 1000000 * ((if_else(after ==0, num_homi_70m_before, num_homi_70m_after)) / (pi*(70^2))), 
         pub_dr_70m_per_km2_num = 1000000 * ((if_else(after ==0, num_pub_dr_70m_before, num_pub_dr_70m_after)) / (pi*(70^2))), 
         robb_70m_per_km2_num   = 1000000 * ((if_else(after ==0, num_robb_70m_before, num_robb_70m_after)) / (pi*(70^2))), 
         all_70m_per_km2_num    = 1000000 * ((if_else(after ==0, num_all_70m_before, num_all_70m_after)) / (pi*(70^2))), 
         vio_70m_per_km2_num    = 1000000 * ((if_else(after ==0, num_vio_70m_before, num_vio_70m_after)) / (pi*(70^2))), 
         nonvio_70m_per_km2_num = 1000000 * ((if_else(after ==0, num_nonvio_70m_before, num_nonvio_70m_after)) / (pi*(70^2))), 
         
         agg_ass_500m_per_km2_num= 1000000 * ((if_else(after ==0, num_agg_ass_500m_before - num_agg_ass_70m_before ,
                                              num_agg_ass_500m_after - num_agg_ass_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         thefts_500m_per_km2_num = 1000000 * ((if_else(after ==0, num_thefts_500m_before - num_thefts_70m_before ,
                                              num_thefts_500m_after - num_thefts_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         burg_500m_per_km2_num   = 1000000 * ((if_else(after ==0, num_burg_500m_before - num_burg_70m_before ,
                                              num_burg_500m_after - num_burg_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         disord_500m_per_km2_num = 1000000 * ((if_else(after ==0, num_disord_500m_before - num_disord_70m_before ,
                                               num_disord_500m_after - num_disord_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         homi_500m_per_km2_num   = 1000000 * ((if_else(after ==0, num_homi_500m_before - num_homi_70m_before ,
                                              num_homi_500m_after - num_homi_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         pub_dr_500m_per_km2_num = 1000000 * ((if_else(after ==0, num_pub_dr_500m_before - num_pub_dr_70m_before ,
                                              num_pub_dr_500m_after - num_pub_dr_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         robb_500m_per_km2_num   = 1000000 * ((if_else(after ==0, num_robb_500m_before - num_robb_70m_before ,
                                               num_robb_500m_after - num_robb_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         all_500m_per_km2_num    = 1000000 * ((if_else(after ==0, num_all_500m_before - num_all_70m_before ,
                                              num_all_500m_after - num_all_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         vio_500m_per_km2_num    = 1000000 * ((if_else(after ==0, num_vio_500m_before - num_vio_70m_before ,
                                              num_vio_500m_after - num_vio_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         nonvio_500m_per_km2_num = 1000000 * ((if_else(after ==0, num_nonvio_500m_before - num_nonvio_70m_before ,
                                              num_nonvio_500m_after - num_nonvio_70m_after   )) / (pi*(500^2) - pi*(70^2))), 
         
         agg_ass_70m_per_km2_std_num= agg_ass_70m_per_km2_num - agg_ass_500m_per_km2_num,
         thefts_70m_per_km2_std_num = thefts_70m_per_km2_num - thefts_500m_per_km2_num, 
         burg_70m_per_km2_std_num   = burg_70m_per_km2_num - burg_500m_per_km2_num, 
         disord_70m_per_km2_std_num = disord_70m_per_km2_num - disord_500m_per_km2_num, 
         homi_70m_per_km2_std_num   = homi_70m_per_km2_num - homi_500m_per_km2_num, 
         pub_dr_70m_per_km2_std_num = pub_dr_70m_per_km2_num - pub_dr_500m_per_km2_num, 
         robb_70m_per_km2_std_num   = robb_70m_per_km2_num - robb_500m_per_km2_num, 
         all_70m_per_km2_std_num    = all_70m_per_km2_num - all_500m_per_km2_num, 
         vio_70m_per_km2_std_num    = vio_70m_per_km2_num - vio_500m_per_km2_num, 
         nonvio_70m_per_km2_std_num = nonvio_70m_per_km2_num - nonvio_500m_per_km2_num
    
         ) %>%
  select(full_address, greened, after, matches("^\\w+70m$"), contains("std"))



######## DID regressions for 70 Meters Unstandardized ###########

did_regressions_70m_unstd = map2(1:10, crime_trans_df$short_name, 
     ~ do.call("lm", list(as.formula(paste0(.y, "_70m ~ greened + after + greened:after")), 
              data=as.name("lots_70m_expanded"))))

did_regressions_70m_std = map2(1:10, crime_trans_df$short_name, 
       ~ do.call("lm", list(as.formula(paste0(.y, "_70m_per_km2_std_num ~ greened + after + greened:after")), 
                     data=as.name("lots_70m_expanded"))))



did_regressions_70m_unstd_r2 = map(did_regressions_70m_unstd, 
                                 ~ .x %>% glance() %>% pull(adj.r.squared)) %>% unlist()

did_regressions_70m_std_r2 = map(did_regressions_70m_std, 
                                 ~ .x %>% glance() %>% pull(adj.r.squared)) %>% unlist()



interaction_effects_70m_unstd = map(did_regressions_70m_unstd, ~ .x %>% tidy() %>% filter(term == "greened:after") )  %>% 
  bind_rows() %>%
  mutate(short_name = crime_trans_df$short_name, 
         summary_crimetype = c(F,F,F,F,F,F,F,T,T,T),
         dist_radis = "70m",
         standardized = c("Unstandardized Crime")) %>%
  left_join(crime_trans_df) %>%
  mutate(crimetype = as.factor(crimetype),
         negative_effect = if_else(estimate <= 0, T, F),
         sig_.05 = if_else(p.value <= 0.05, T, F))

interaction_effects_70m_std = map(did_regressions_70m_std, ~ .x %>% tidy() %>% filter(term == "greened:after") )  %>% 
  bind_rows() %>%
  mutate(short_name = crime_trans_df$short_nam, 
         summary_crimetype = c(F,F,F,F,F,F,F,T,T,T),
         dist_radis = "70m",
         standardized = c("Standardized Crime")) %>%
  left_join(crime_trans_df) %>%
  mutate(crimetype = as.factor(crimetype),
         negative_effect = if_else(estimate <= 0, T, F),
         sig_.05 = if_else(p.value <= 0.05, T, F))

coefficients = bind_rows(interaction_effects_70m_unstd, interaction_effects_70m_std)


did_estimates_plot = ggplot(coefficients, aes(x = crimetype, y = estimate, col = negative_effect))+
  geom_hline(yintercept = 0, col = "gray70", size = 1.3) + 
  geom_point(size = 2) + 
  geom_errorbar(aes(ymin = estimate - 2*std.error, 
                    ymax = estimate + 2*std.error),
                alpha = 1, width = 0.15) +
  facet_grid(rows = vars(standardized), cols = vars(summary_crimetype), scales = "free") + 
  labs(y = "DID estimate", x = "Crimetype") +
  # "ggtitle(DID estimates by Crimetype") + 
  theme(text = element_text(family = "CMU Serif"),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size =12),
        axis.text.x  = element_text(size = 12, angle = 55, hjust = 1),
        axis.text.y  = element_text(size =12),
        legend.text = element_text( size = 12)) + 
  scale_colour_hue() + 
  guides(col = F)

ggsave('C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/did_estimators_plot.png', width = 8, height = 5.5, units = "in", dpi = 600)


unstd_did_estimators_plot = ggplot(interaction_effects_70m_unstd, aes(x = crimetype, y = estimate, col = negative_effect ))+
  geom_hline(yintercept = 0, col = "gray70", size = 1.3) + 
  geom_point(size = 2) + 
  # geom_segment(aes(xend = crimetype, yend =0), show.legend = F) +
  geom_errorbar(aes(ymin = estimate - 2*std.error, 
                    ymax = estimate + 2*std.error),
                alpha = 1, width = 0.15) + 
  labs(y = "DID estimate", x = "Crimetype", title = "Unstandardized DID estimators by Crimetype") + 
  facet_wrap(~summary_crimetype, scales = "free_x") +
  theme(text = element_text(family = "Lato"),
        strip.text.x = element_blank(),
        axis.text.x  = element_text(size = 11, angle = 55, hjust = 1),
        legend.text = element_text( size = 11)) + 
  guides(col = F)
  

std_did_estimators_plot = ggplot(interaction_effects_70m_std, aes(x = crimetype, y = estimate, col = negative_effect ))+
  geom_hline(yintercept = 0, col = "gray70", size = 1.3) + 
  geom_point(size = 2) + 
  # geom_segment(aes(xend = crimetype, yend =0), show.legend = F) +
  geom_errorbar(aes(ymin = estimate - 2*std.error, 
                    ymax = estimate + 2*std.error),
                alpha = 1, width = 0.15) + 
  labs(y = "DID estimate", x = "Crimetype", title = "Standardized DID estimators by Crimetype") + 
  facet_wrap(~summary_crimetype, scales = "free_x") +
  theme(text = element_text(family = "Lato"),
        strip.text.x = element_blank(),
        axis.text.x  = element_text(size = 11, angle = 55, hjust = 1),
        legend.text = element_text( size = 11)) + 
  guides(col = F)



  


