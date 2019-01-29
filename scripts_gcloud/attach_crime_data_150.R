library(sf)
library(tidyverse)
library(data.table)


#need function to accurate calc percent change if before or after =0
calc_percent_change = function(before, after){
  ifelse(((before ==0) & (after ==0)), 0, 
         ifelse(before ==0, after*100, 
                ifelse(after ==0, before*(-100),
                       100*((after-before)/before))))} 



## assumes crimes_agg is in global environment before this function is run
add_crime_data = function(geometry, date_begin, date_end, date_season_end, date_season_begin, dist_m, ...)
{
  
  counter <<- counter + 1; 
  if(counter %in% seq(0, nrow(lots), 100)) 
    print(paste("Row", counter, "has been processed"))
  
  crime_trans_df = data.table(input_name = c('Aggravated Assaults',"All Thefts","Burglaries",
                                             "Disorderly Conduct", "Homicides", 
                                             "Public Drunkenness","Robberies","All","Violent","Non Violent"),
                              short_name = c("agg_ass","thefts",'burg','disord',"homi",'pub_dr',"robb","all",
                                             "vio","nonvio"))
  
  
  
  geo = st_sfc(geometry, crs = 32129) 
  geo = st_buffer(geo, dist_m) 
  geo = st_sf(geo)
  
  
  crimes_agg1 = crimes_agg_dt[date >= date_begin & date <= date_end]
  crimes_agg1 = st_as_sf(crimes_agg1)
  crimes_agg1 = suppressWarnings(st_intersection(geo, crimes_agg1))
  
  crimes_agg1 = data.table(crimes_agg1) 
  
  
  crimes_before_in_radius = crimes_agg1[date <= date_season_begin]
  crimes_after_in_radius = crimes_agg1[date >= date_season_end]
  
  
  
  b4 = data.table(data.frame(as.list(summary(crimes_before_in_radius$crimetype_05))))
  b4 =  b4[, `:=`(All = rowSums(.SD, na.rm=T))]
  b4 =  b4[, `:=`(Violent = rowSums(.SD, na.rm  =T)), .SDcols = c("Aggravated.Assaults", "Homicides", "Robberies")]
  b4 =  b4[, `:=`(Non.Violent = rowSums(.SD, na.rm  =T)), .SDcols = c("All.Thefts", "Burglaries",
                                                                      "Disorderly.Conduct", "Public.Drunkenness")]
  
  
  
  af = data.table(data.frame(as.list(summary(crimes_after_in_radius$crimetype_05))))
  af =  af[, `:=`(All = rowSums(.SD, na.rm=T))]
  af =  af[, `:=`(Violent = rowSums(.SD, na.rm  =T)), .SDcols = c("Aggravated.Assaults", "Homicides", "Robberies")]
  af =  af[, `:=`(Non.Violent = rowSums(.SD, na.rm  =T)), .SDcols = c("All.Thefts", "Burglaries",
                                                                      "Disorderly.Conduct", "Public.Drunkenness")]
  
  
  
  values =unlist(c( matrix(c(b4, af, calc_percent_change(b4, af), af-b4), nrow=4, byrow=TRUE))  )
  
  names = unlist(lapply(crime_trans_df$short_name, 
                        function(cr) c(paste0("num_",cr,"_", dist_m,"m_before"),
                                       paste0("num_",cr,"_", dist_m,"m_after"),
                                       paste0("pct_change_",cr,"_", dist_m ),
                                       paste0("diff_",cr,"_", dist_m,"m_after"))))
  
  values = setNames(values, names)
  result = data.frame(as.list(values))
  
  return(result)
  
}


#Read in data
crimes_agg_dt = readRDS("final_data/crimes_agg_dt.rds")
lots = readRDS("final_data/lots.rds")



counter = 0
distm = 150

assign(paste0("lots_",distm), (suppressWarnings(pmap(lots, add_crime_data, dist_m = distm))  %>%
                                 do.call(rbind, .)))



# lots1 = (suppressWarnings(pmap(lots, add_crime_data, dist_m = distm))  %>%
#          do.call(rbind, .) )
#          
# %>%
# bind_cols(y1, .)))