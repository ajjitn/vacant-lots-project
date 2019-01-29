library(data.table)
library(tidyverse)
library(broom)
library(tidyr)
library(sf)
library(leaflet)


# lots = readRDS("final_data/lots1.rds")
lots = readRDS("final_data/lots.rds")


#make eda table function
make_eda_table = function(lots, radius){
  
  radius_m = paste0(radius, "m")
  lots1 = lots %>% st_set_geometry(NULL)
  lots_radius = lots1 %>% 
    select(greened, contains(radius_m)) %>% 
    select(greened, contains("diff"))  
  
  
  #### Doing T and Wilcox Tests ######
  
  std_cols_to_test = lots_radius %>% select(greened, contains("std"))%>% 
    gather(key = "stat", value = "value", -greened) %>% 
    mutate(greened = !greened)
  
  abs_diff_cols_regex = paste0("^diff\\w+", radius,"m$")
  ustd_cols_to_test = lots_radius %>% select(greened, matches(abs_diff_cols_regex))%>% 
    gather(key = "stat", value = "value", -greened) %>% 
    mutate(greened = !greened)
  
  
  #helper do_test fxn for t tests and wilcox tests
  do_test = function(cols, test = "t", p_val_name){
    
    if (test == "t"){
      r = cols %>%
        group_by(stat) %>% 
        do(tidy(t.test(value~greened, data=. ))) %>%
        ungroup() %>% 
        mutate(crimetype = stringr::str_replace_all(stat, "std_diff_", ""),
               crimetype = stringr::str_replace_all(crimetype, paste0("_",radius_m, "_per_km2"), ""),
               crimetype = stringr::str_replace_all(crimetype, paste0("_",radius_m), ""),
               crimetype = stringr::str_replace_all(crimetype, "diff_", "")) %>%
        select(p.value, crimetype) %>%
        rename(!!p_val_name := p.value)
    } else if (test == "w"){
      
      r = cols %>% 
        group_by(stat) %>% 
        do(glance(wilcox.test(value~greened, data=. ))) %>%
        ungroup() %>% 
        mutate(crimetype = stringr::str_replace_all(stat, "std_diff_", ""),
               crimetype = stringr::str_replace_all(crimetype, paste0("_",radius_m, "_per_km2"), ""),
               crimetype = stringr::str_replace_all(crimetype, paste0("_",radius_m), ""),
               crimetype = stringr::str_replace_all(crimetype, "diff_", "")) %>%
        select(p.value, crimetype) %>%
        rename(!!p_val_name := p.value)    
    } else {
      stop("test parameter is not valid, must be 't' or 'w'")
    }
    
    return(r)
    
  }
  
  
  std_diff_normed_area_t_test = do_test(std_cols_to_test, test = "t", "std_t_test_p_value")
  std_diff_normed_area_w_test = do_test(std_cols_to_test, test = "w", "std_w_test_p_value")
  ustd_diff_normed_area_t_test= do_test(ustd_cols_to_test, test = "t", "ustd_t_test_p_value")
  ustd_diff_normed_area_w_test= do_test(ustd_cols_to_test, test = "w", "ustd_w_test_p_value")
  
  tests = std_diff_normed_area_t_test %>% 
    left_join(std_diff_normed_area_w_test) %>% 
    left_join(ustd_diff_normed_area_t_test) %>%
    left_join(ustd_diff_normed_area_w_test) 
  
  
  
  #### Creatning aggreggate means,differences, and p-vals in final dataframe ####
  s = lots_radius %>% 
    gather(key = "stat", value = "value", -greened) %>%
    group_by(stat, greened) %>%
    summarize_all(mean) %>%
    spread(greened, value) %>% ungroup() %>% 
    mutate(crimetype = stringr::str_replace_all(stat, "std_diff_", ""),
           crimetype = stringr::str_replace_all(crimetype, paste0("_",radius_m, "_per_km2"), ""),
           crimetype = stringr::str_replace_all(crimetype, paste0("_",radius_m), ""),
           crimetype = stringr::str_replace_all(crimetype, "diff_", "")
    ) %>%
    rename(greened = "TRUE",
           ungreened = "FALSE") %>%
    arrange(stat) %>% 
    group_by(crimetype) %>%
    summarize(
      abs_diff_g =       dplyr::nth(greened, n =1),
      abs_diff_g_per_km2 =      dplyr::nth(greened, n =2),
      std_abs_diff_g_per_km2 = dplyr::nth(greened, n = 3),
      abs_diff_c =       dplyr::nth(ungreened, n = 1),
      abs_diff_c_per_km2 =      dplyr::nth(ungreened, n =2),
      std_abs_diff_c_per_km2 = dplyr::nth(ungreened, n = 3)) %>% 
    ungroup() %>%
    mutate(diff_abs_diff = abs_diff_g - abs_diff_c,
           diff_std_diff_per_km2 = std_abs_diff_g_per_km2 - std_abs_diff_c_per_km2) %>%
    left_join(tests, by = "crimetype") %>%
    arrange(factor(crimetype, levels = c("agg_ass","burg","disord","homi","pub_dr","robb","thefts","vio","nonvio","all"))) 
  
  s = s %>% select(crimetype, abs_diff_g, abs_diff_c, diff_abs_diff, ustd_w_test_p_value, 
                   ustd_t_test_p_value, abs_diff_g_per_km2, abs_diff_c_per_km2,
                   std_abs_diff_g_per_km2, std_abs_diff_c_per_km2 ,diff_std_diff_per_km2, 
                   std_w_test_p_value, std_t_test_p_value)
  
  
  return(s)
}

#creating and saving eda tables for 70 and 150m radii
lots_70m_eda = make_eda_table(lots, 70)
lots_150m_eda = make_eda_table(lots, 150)

write_csv(lots_70m_eda, "final_data/lots_70m_eda_disjoint_renamed.csv")
write_csv(lots_150m_eda, "final_data/lots_150m_eda_disjoint_renamed.csv")

