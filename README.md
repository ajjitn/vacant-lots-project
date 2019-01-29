# vacant-lots-project

This repository contains all the files and scripts used to generate my senior thesis, Vacant Lot Greening and Crime. It combines the below 3 datasets to create one unfied dataset on crime rates around vacant lots. 

1) Greened vacant lot data (from the Pennsylvania Horticultural Society's LandCare program)
2) Control vacant lot data (from the Philadelphia Licenses and Inspections office)
3) Crime data (From the Philadelphia Police Department)

The `raw_data` folder contains the initial data I started with. `Philly_Crime_98to11_Final.dta` was provided courtesy of John MacDonald of the Criminolgy Department at Penn and contains data on crimes within Philly from 1998 to 2011. We combined this with current crime data published on opendataphilly [here](https://www.opendataphilly.org/dataset/crime-incidents) to create one unified crime dataset. The other file is `raw_geocoded_greened_lots_data.rds` and is a geocoded listing of all the greened lots in Philly given to us by PHS. The instructions for geocoding can be found in `raw_data/geocoding_greened_lots`.

### Data Cleaning

The 'scripts_datacleaning' folder contains the scripts used to read in and clean the data. The `vacant_lots_data_readin.R` file will output 2 .rds files to the 'intermediate_data' folder, namely 'lots.rds' and 'crimes_agg.rds'. 'lots.rds' which is the dataset of all greened and unreened vacant lots in Philly, their lat/lons, and addresses. 'crimes_agg.rds' is the dataset of all crimes in Philly from 1998 to Dec 2018. Using the lots.rds and crimes_agg.rds, users can calculate whatever crime metrics they want for the lots in question. An important note on the crimes_agg.rds file is that the types of crime that were reported in the old crime dataset were more limited than the types of crimes reported in the newer crime dataset. To maintain consistency, we collapsed the newer crimetypes into the broader old crimetypes and only keep crimetypes which were recorded in both datasets.  Below is the transalation table of crimetypes. 


|crimetype_new                 |crimetype_old       |
|:-----------------------------|:-------------------|
|Aggravated Assault No Firearm |Aggravated Assaults |
|Aggravated Assault Firearm    |Aggravated Assaults |
|Other      Assault            |Aggravated Assaults |
|Thefts                        |All Thefts          |
|Theft from Vehicle            |All Thefts          |
|Burglary Non-Residential      |Burglaries          |
|Burglary Residential          |Burglaries          |
|Disorderly Conduct            |Disorderly Conduct  |
|Homicide - Criminal           |Homicides           |
|Homicide - Justifiable        |Homicides           |
|Homicide - Gross Negligence   |Homicides           |
|Public Drunkenness            |Public Drunkenness  |
|Robbery Firearm               |Robberies           |
|Robbery No Firearm            |Robberies           |


Next the `scripts_gcloud` folder contains the scripts we used to attach crime data to each lot. Because there were > 1 million crime records, we used a few instances in Google Cloud to quickly attach crime data for each lot. At a high level the crime metrics we measured for each lot was the count of the number of crimes (broken down by crimetype) within certain radii of the lots (70m, 150m, 250m, 500m). We measured these crime metrics in two time periods: 11 months before a lot was greened and 11 months after a lot was greened. 

The `merge_lots_data_from_gcloud.R` file combines all the csvs outputted by the gcloud instances and combines it into our final unified crime change around lots dataset. It saves this dataset in `final_data/lots.rds`, which users can feel free to download and play with. The codebook for this final dataset is being written and will eventually also be in the `final_data` folder. 


### Analysis
The 'scripts_analysis' folder contains all the scripts used for my 2 main analyses:

1) Aggregate comparisons and Wilcox tests for difference in crimes around greened lots vs ungreened lots
2) A Difference in Differences Regression

The `make_agg_comparison_tables.R` file compares the mean crime change per square kilometer for greened lots and control vacant lots broken down by crimetype. It also conducts a t-test and a Wilcoxon rank sum test to test if the means of the two groups are significantly different. It writes out these results as a csv to the `final_data` folder. 

The `make_DID_regressions.R` file conducts a simplified before and after DID regression with no time specific fixed effects. It writes out a few charts and graphs to the `final_data` folder

The `write_geojsons_for_kepler.R` file simply writes out the lots dataset as geojsons for easy visualziation in [kepler.gl](https://kepler.gl/#/demo) (A really cool tool everyone should check out)!

