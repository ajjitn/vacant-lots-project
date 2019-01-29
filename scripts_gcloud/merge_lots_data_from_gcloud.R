library(data.table)
library(tidyverse)
library(sf)
library(leaflet)


lots = readRDS("intermediate_data/lots.rds")

lots_70 = readRDS("intermediate_data/files_from_gcloud/lots_70.rds") 
lots_150 = readRDS("intermediate_data/files_from_gcloud/lots_150.rds")
lots_250 = readRDS("intermediate_data/files_from_gcloud/lots_250.rds")
lots_500 = readRDS("intermediate_data/files_from_gcloud/lots_500.rds")

lots1 = bind_cols(lots, lots_70, lots_150, lots_250, lots_500) %>%
  select(-contains("pct")) %>%
  #made small naming mistakes in gcloud script, so lets fix here
  rename_at(vars(contains("diff")), ~str_replace(., "m_after", "m")) 


#generate normed_area and std_normed_ares columns for radii of 70,150 and 500m. Basically diff in crimes per meter
lots1 = lots1 %>% 
  mutate(diff_agg_ass_70m_per_km2= 1000000 * (diff_agg_ass_70m / (pi*(70^2))), 
         diff_thefts_70m_per_km2 = 1000000 * (diff_thefts_70m / (pi*(70^2))), 
         diff_burg_70m_per_km2   = 1000000 * (diff_burg_70m / (pi*(70^2))), 
         diff_disord_70m_per_km2 = 1000000 * (diff_disord_70m / (pi*(70^2))), 
         diff_homi_70m_per_km2   = 1000000 * (diff_homi_70m / (pi*(70^2))), 
         diff_pub_dr_70m_per_km2 = 1000000 * (diff_pub_dr_70m / (pi*(70^2))), 
         diff_robb_70m_per_km2   = 1000000 * (diff_robb_70m / (pi*(70^2))), 
         diff_all_70m_per_km2    = 1000000 * (diff_all_70m / (pi*(70^2))), 
         diff_vio_70m_per_km2    = 1000000 * (diff_vio_70m / (pi*(70^2))), 
         diff_nonvio_70m_per_km2 = 1000000 * (diff_nonvio_70m / (pi*(70^2))), 
         
         diff_agg_ass_150m_per_km2= 1000000 * (diff_agg_ass_150m / (pi*(150^2))), 
         diff_thefts_150m_per_km2 = 1000000 * (diff_thefts_150m / (pi*(150^2))), 
         diff_burg_150m_per_km2   = 1000000 * (diff_burg_150m / (pi*(150^2))), 
         diff_disord_150m_per_km2 = 1000000 * (diff_disord_150m / (pi*(150^2))), 
         diff_homi_150m_per_km2   = 1000000 * (diff_homi_150m / (pi*(150^2))), 
         diff_pub_dr_150m_per_km2 = 1000000 * (diff_pub_dr_150m / (pi*(150^2))), 
         diff_robb_150m_per_km2   = 1000000 * (diff_robb_150m / (pi*(150^2))), 
         diff_all_150m_per_km2    = 1000000 * (diff_all_150m / (pi*(150^2))), 
         diff_vio_150m_per_km2    = 1000000 * (diff_vio_150m / (pi*(150^2))), 
         diff_nonvio_150m_per_km2 = 1000000 * (diff_nonvio_150m / (pi*(150^2))), 
         
         diff_agg_ass_500m_per_km2= 1000000 * (diff_agg_ass_500m / (pi*(500^2))), 
         diff_thefts_500m_per_km2 = 1000000 * (diff_thefts_500m / (pi*(500^2))), 
         diff_burg_500m_per_km2   = 1000000 * (diff_burg_500m / (pi*(500^2))), 
         diff_disord_500m_per_km2 = 1000000 * (diff_disord_500m / (pi*(500^2))), 
         diff_homi_500m_per_km2   = 1000000 * (diff_homi_500m / (pi*(500^2))), 
         diff_pub_dr_500m_per_km2 = 1000000 * (diff_pub_dr_500m / (pi*(500^2))), 
         diff_robb_500m_per_km2   = 1000000 * (diff_robb_500m / (pi*(500^2))), 
         diff_all_500m_per_km2    = 1000000 * (diff_all_500m / (pi*(500^2))), 
         diff_vio_500m_per_km2    = 1000000 * (diff_vio_500m / (pi*(500^2))), 
         diff_nonvio_500m_per_km2 = 1000000 * (diff_nonvio_500m / (pi*(500^2))),
         
         std_diff_agg_ass_70m_per_km2 = diff_agg_ass_70m_per_km2 - 1000000 *((diff_agg_ass_500m - diff_agg_ass_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_thefts_70m_per_km2 = diff_thefts_70m_per_km2 - 1000000 *((diff_thefts_500m - diff_thefts_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_burg_70m_per_km2 = diff_burg_70m_per_km2 - 1000000 *((diff_burg_500m - diff_burg_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_disord_70m_per_km2 = diff_disord_70m_per_km2 - 1000000 *((diff_disord_500m - diff_disord_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_homi_70m_per_km2 = diff_homi_70m_per_km2 - 1000000 *((diff_homi_500m - diff_homi_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_pub_dr_70m_per_km2 = diff_pub_dr_70m_per_km2 - 1000000 *((diff_pub_dr_500m - diff_pub_dr_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_robb_70m_per_km2 = diff_robb_70m_per_km2 - 1000000 *((diff_robb_500m - diff_robb_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_all_70m_per_km2 = diff_all_70m_per_km2 - 1000000 *((diff_all_500m - diff_all_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_vio_70m_per_km2 = diff_vio_70m_per_km2 - 1000000 *((diff_vio_500m - diff_vio_70m) / (pi*(500^2) - pi*(70^2))) , 
         std_diff_nonvio_70m_per_km2 = diff_nonvio_70m_per_km2 - 1000000 *((diff_nonvio_500m - diff_nonvio_70m) / (pi*(500^2) - pi*(70^2))) , 
         
         std_diff_agg_ass_150m_per_km2 = diff_agg_ass_150m_per_km2 - 1000000 *((diff_agg_ass_500m - diff_agg_ass_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_thefts_150m_per_km2 = diff_thefts_150m_per_km2 - 1000000 *((diff_thefts_500m - diff_thefts_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_burg_150m_per_km2 = diff_burg_150m_per_km2 - 1000000 *((diff_burg_500m - diff_burg_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_disord_150m_per_km2 = diff_disord_150m_per_km2 - 1000000 *((diff_disord_500m - diff_disord_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_homi_150m_per_km2 = diff_homi_150m_per_km2 - 1000000 *((diff_homi_500m - diff_homi_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_pub_dr_150m_per_km2 = diff_pub_dr_150m_per_km2 - 1000000 *((diff_pub_dr_500m - diff_pub_dr_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_robb_150m_per_km2 = diff_robb_150m_per_km2 - 1000000 *((diff_robb_500m - diff_robb_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_all_150m_per_km2 = diff_all_150m_per_km2 - 1000000 *((diff_all_500m - diff_all_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_vio_150m_per_km2 = diff_vio_150m_per_km2 - 1000000 *((diff_vio_500m - diff_vio_150m) / (pi*(500^2) - pi*(150^2)))  , 
         std_diff_nonvio_150m_per_km2 = diff_nonvio_150m_per_km2 - 1000000 *((diff_nonvio_500m - diff_nonvio_150m) / (pi*(500^2) - pi*(150^2)))  
  )

lots1 = lots1 %>% mutate(full_address = stringr::str_to_lower(full_address),
                         full_address = stringr::str_to_title(full_address),
                         full_address = stringr::str_replace(full_address, ", Pa", ", PA")) %>% 
  as.tibble() %>%
  st_sf(sf_column_name ='geometry')

#needed to create standardized pct change columsn, in future index might be bg pct change, but for now its pct change in 500m radius circle

saveRDS(lots1, "final_data/lots.rds")




