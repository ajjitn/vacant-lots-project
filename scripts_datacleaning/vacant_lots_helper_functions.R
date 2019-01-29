library(tidycensus)
library(tidyverse)
######## Vacant Lot Project Helper Functions #######

#helper fxn to download and read in shapefile to avoid manual downaload/unzipping process
download_and_readin_shpfile = function(url, temp = TRUE, input_dir = getwd(), folder_name = "") {
  
  #save zipped shp files in temporyary dir if temp=T
  if (isTRUE(temp)){
    tmpdir <- tempdir()
    file_path <- file.path(tmpdir, basename(url))
  }
  else {
    tmpdir = input_dir
    # save zipped shp files in curernt working directory
    if (folder_name == ""){
      file_path <- file.path(input_dir, basename(url))
    }
    else{
      file_path <- file.path(input_dir, folder_name)
    }
  }
  
  #try downloading file into tempdir
  x = try(download.file(url, destfile=file_path))
  
  #Try HTTP version of the URL if downloading the file fails
  if (class(x) == "try-error"){
    url = str_replace(url, "https:","http:")
    x = try(download.file(url, destfile=file_path))
  }
  
  #If URL still gives errors, stop and print error
  if (class(x) == "try-error") {
    message("Url cannot be opened")
    stop()
  }
  unzip(file, exdir = file.path(tmpdir, folder_name))
  
  #look through unzipped files and locate ",shp" file
  shpfile = str_subset(list.files(tmpdir), "shp")
  shpfile_name = file.path(tmpdir, shpfile)
  
  # read in shp file with sf
  x = st_read(shpfile_name)
  return(x)
}

#no built in way to calcaulate midpoint of date interval, so we create our own
int_midpoint = function(interval){
  interval@start + as.duration(interval)/2
}

#need function to accurate calc percent change if before or after =0
#now dont use percent change, use normed difference in crimes per unit area
calc_percent_change = function(before, after){
  ifelse(((before ==0) & (after ==0)), 0, 
         ifelse(before ==0, after*100, 
                ifelse(after ==0, before*(-100),
                       100*((after-before)/before))))} 


###############################################
##### DATA READ IN HELPER FUNCTIONS ###########
###############################################


##### VACANT LOT DATA #######
#Helper function to read in li_vacant data given SQL URL query
read_in_vacant_lot_data = function(li_vacant_url){
  
  #Saw by visual inspection of Google Streetveiw that these violationtypes coressponded to vacant lots
  ungreened_vacant_lot_descriptions = c('VACANT LOT KEEP CLEAN GET LIC',
                                        'LICENSE - VACANT LOT', 
                                        'VACANT LOT STANDARD', 
                                        'EXT A-VACANT LOT CLEAN/MAINTAI' )
  
  li_vacant_sf = st_read(URLencode(li_vacant_url)) %>%
    
    mutate(full_address = paste0(address, ", PHILADELPHIA, PA"),
           full_address = as.character(full_address)) %>%
    #throw out vacant lots that are in list of greened vacant lots
    filter(!full_address %in% toupper(greened_lots_sf$full_address)) %>%
    #only keep lots whose violation descriptions match the ones in the ungreened vacant lot list above
    filter(violationdescription %in% ungreened_vacant_lot_descriptions) 
  
  
  #start_vacnant_date = first violation date
  #last_vacant_date   = either laste caser resolution date, or if still OPEN, then today() (10-30-18) 
  
  li_vacant_sf = li_vacant_sf %>% 
    group_by(full_address) %>% 
    summarise(n_violations= n(), 
              first_viodate = as.Date(dplyr::first(violationdate, order_by = violationdate, default = NA)),
              last_caseresdate  = as.Date(max(caseresolutiondate, na.rm = T)),
              #vio_desc = paste(violationdescription, collapse = ","),
              #case_status = paste(casestatus, collapse = ","),
              case_status_all = ifelse(((n_distinct(casestatus)==1) & ("CLOSED" %in% unique(casestatus))), 
                                       "CLOSED", 
                                       "OPEN"),
              date_vacant_begin = first_viodate,
              date_vacant_end   = dplyr::if_else(case_status_all == "OPEN", as.Date(lubridate::today()), 
                                                 last_caseresdate),
              date_season_begin = date_vacant_begin + floor((date_vacant_end-date_vacant_begin)/2), 
              date_season_end   = date_season_begin %m+% months(1),
              date_begin = date_season_begin %m-% months(11),
              date_end   = date_season_end %m+% months(11),
              greened = F) %>%
    #only want lots that have been vacant for at least 2 years to make comparable to our test case
    filter((date_vacant_end - date_vacant_begin) > 720) %>%
    #filter out properties without lat/lon
    filter(!st_is(.,"GEOMETRYCOLLECTION")) %>%
    st_transform(32129) %>%
    #some lots (around 10) have slightly diff lat/lons, so lets jsut get ehe centroid
    st_centroid() %>%
    st_transform(4326)
  
  # arrange(desc(n_violations)) 
  
  return(li_vacant_sf)
  
}


##### CRIME DATA #######
#helper functions to read in and clean both old crime data (from file) and new crime data (from opendataphilly.org), Also to merge the data
clean_old_crime_data_for_joining = function(filepath){
  crimes.old = as_tibble(read_dta(filepath)) %>%
    mutate(date = as.Date(paste(Month, Day, Year, sep = '/' ), format =  "%m/%d/%Y"))%>%
    select(date, Hour, Minute, AMPM, INCIDENT, INCT_GUN,
           NAME00, NAMELSAD00, INTPTLON00, INTPTLAT00,
           `_ID`, X_COORD, Y_COORD)
  # #Data cleaning
  yearz = year(crimes.old$date)
  crimes.old = crimes.old %>%
    setnames("INCIDENT", "crimetype_05") %>%
    mutate(AMPM= as.factor(AMPM),
           # crimetype_05=as.factor(crimetype_05),
           INCT_GUN=as.factor(INCT_GUN),
           lon_x_nad83 =as.numeric(X_COORD),
           lat_y_nad83 =as.numeric(Y_COORD),
           fulltime = paste0(Hour, ":", ifelse(nchar(Minute) == 1, "0",""),Minute, " ", AMPM),
           fulltime = format(strptime(fulltime, "%I:%M %p"), format="%H:%M:%S"),
           timedate = as.POSIXct(paste(date, fulltime), format = "%Y-%m-%d %H:%M:%S"),
           crimetype_new= NA,
           year=yearz,
           tract_number = NAME00)%>%
    select(-one_of(c("INTPTLAT00", "INTPTLON00", "fulltime", "NAME00", "NAMELSAD00")))%>%
    select(date, timedate, lon_x_nad83, lat_y_nad83, year, crimetype_new, crimetype_05)
  
  #Illegal Dumping wasn't reported in crime_opendata, so take those out of crimes.old
  crimes.old = crimes.old %>% filter(!(crimetype_05 == "Illegal Dumping")) %>%
    mutate(crimetype_05 = factor(crimetype_05))
  
  #lat and lon are in terms of NAD 83 state plane (EPSG code 3365), so lets create an sf Dataframe with that CRS,         #then transofrm CRS to 4326 (lat/lon)
  crimes.old = crimes.old %>% st_as_sf(crs = 3365, coords = c("lon_x_nad83", "lat_y_nad83"), agr="constant") %>%
    st_transform(4326)
  
  crimes.old %>% mutate(crimetype_vio = if_else(crimetype_05 %in% c('Aggravated Assaults','Robberies','Homicides'), 1, 0))
  
  
  return(crimes.old)
  
}
clean_new_crime_data_for_joining = function(crime_url){
  crime_opendata_sf = st_read(URLencode(crime_data_url))
  
  crimetype_translation_df = data_frame(crimetype_new = c("Aggravated Assault No Firearm","Aggravated Assault Firearm", "Other      Assault", "Thefts" , "Theft from Vehicle", "Burglary Non-Residential","Burglary Residential","Disorderly Conduct","Homicide - Criminal", "Homicide - Justifiable",
                                                          "Homicide - Gross Negligence", "Public Drunkenness","Robbery Firearm", "Robbery No Firearm"),
                                        crimetype_05 = c(rep('Aggravated Assaults',3), rep("All Thefts", 2), rep("Burglaries", 2), "Disorderly Conduct", rep("Homicides",3),"Public Drunkenness", rep("Robberies", 2)))
  
  crime_opendata_sf = crime_opendata_sf %>%
    dplyr::mutate(
      #create year, date, lon and lat columns
      year = lubridate::year(dispatch_date_time),
      date = lubridate::date(dispatch_date_time),
      text_general_code = as.factor(text_general_code)) %>% 
    #rename some columns
    dplyr::rename(timedate = dispatch_date_time,
                  crimetype_new = text_general_code) %>%
    dplyr::select(timedate, date, year, crimetype_new) %>%
    
    # add on crimetype_05
    dplyr::left_join(crimetype_translation_df, by="crimetype_new") %>% 
    
    
    #filter out crimes that weren't reported in 2005
    dplyr::filter(!is.na(crimetype_05)) %>%
    mutate(crimetype_vio = if_else(crimetype_05 %in% c('Aggravated Assaults','Robberies','Homicides'), 
                                   1,
                                   0)) %>%
    select(-crimetype_vio)
  
  return(crime_opendata_sf)
}
merge_crime_data = function(old_crime_data, new_crime_data){
  old_crime_data = old_crime_data %>% filter(date < "2006-01-01")
  new_crime_data = new_crime_data %>% filter(date >= "2006-01-01")
  
  crimes_agg = rbind(old_crime_data, new_crime_data) 
  return(crimes_agg)
  
}


##### BLOCK GROUP DATA #######





###############################################
##### DATA MEGING HELPER FUNCTIONS ############
###############################################

## assumes crimes_agg_dt is in global environment before this function is run
add_crime_data = function(geometry, date_begin, date_end, date_season_end, date_season_begin, dist_m, ...){
  
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


#exapmle of using above function to append crime data in radius 80 to df y1

# y1 = lots %>% slice(1:5) 
# p1 = ((suppressWarnings(pmap(y1, add_crime_data, dist_m = 80))  %>%
#   do.call(rbind, .) %>%
#   bind_cols(y1, .)), times = 5)




## Testing to see whether st_intersections or st_join is faster for out pt in polygon calculation. Answer: st_intersection
# c_test = (crimes_agg %>% sample_n(600000))
# 
# 
# y_test = li_vacant_sf %>% slice(1:1000)
# microbenchmark::microbenchmark(st_intersection(y_test, c_test),
#                                st_join(c_test, y_test, left = F), times = 10)
#send crime functions to Shane
# 
