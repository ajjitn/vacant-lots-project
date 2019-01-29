---
title: "Vacant Lot Greening and Crime"
author: "Ajjit Narayanan"
csl: apa.csl
date: 20 December 2018
output:
  html_document: default
  word_document:
    reference_docx: word-test-options.docx
  pdf_document: default
nocite: |
  @*
link-citations: yes
indent: false
bibliography: citations_thesis.bib
abstract:
  Many American cities, particularly former industrial hubs like Detroit and Philadelphia, face the burgeoning problem of vacant lots. Philadelphia has adopted an intersting solution in the form of vacant lot greening, which turns the lots into mini public parks for local residents. The positive ecological and mental health benefits of greened vacant lots have been well documented, but one secondary question is the effect of greening on crime. This paper seeks to answer this question by using data on greened vacant lots, control vacant lots and crime in Philadelphia. We used Wilcoxon rank sum tests and a Difference in Difference regression to analyze how crime rates change around greened lots and around control lots. Overall we found that greening reduced non violent crimes, particularly robberies, thefts, and disorderly conduct citations, after taking into account crime rates around control lots and crime rates in surrounding neighborhoods.
header-includes: |
  \makeatletter
  \def\fps@figure{h}
  \makeatother
---


## Introduction

Many former industrial cities like Boston and Philadelphia,  have large inventories of vacant lots. A survey of 70 American cites by the Brookings Institute for example found that on average, fifteen percent of a city’s lots were vacant [@pagano2000vacant]. While no formal definition of a ‘vacant lot’ exists, the term generally covers privately owned unused or abandoned land that contains no buildings or unusable/vacant buildings.

In order to combat this problem, city governments have adopted a slew of policies, with one of the more popular approaches being vacant lot greening. City governments in conjunction with nonprofit partners have instituted citywide programs to ‘green’ subsets of the vacant lots. In Philadelphia, this program is called the LandCare program and is carried out by PHS (The Pennsylvania Horticultural Society) and a consortium of community organization. This process of greening usually includes cleaning out trash/debris, grading the land, planting grass and trees to create a park like setting, and installing low wooden posts and fences around the perimeter to show the land is cared for. This is followed up by bimonthly maintenance visits. Also of note is the programs commitment to hiring community members to be maintenance workers so they can have a stake in the newly created green space. In effect, this greening program has created a series of mini green spaces in pockets throughout the city. Below is an example of what these greened lots look like.

![Example of Vacant Lot Greening](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/greened_lot_pic.png)


One of the fundamental question in urban studies is the relationship between the built environment of a city and community vibrancy, or the well-being of the people who live there. And an important part of the built environment of a city is the existence of parks and green spaces. Green spaces provide many positive opportunities for residents, including sports and recreation, stormwater management, air quality regulation, environmental preservation, and mental health just to name a few [@groenewegen2006vitamin]. And Phialdelphia's greening programs provides us with a ripe natural experiment to study what happens to communities after greenspace is introduced.

In this paper, we focus on the effect of vacant lot greening on crime rates. While the primary purpose of the vacant lot greening program may be to beautify neighborhoods, an interesting second order effect is the effect of greening on crime rates. This is an open question in the field as many scholars have differing views on the effect of greenspace on crime rates and even empirical studies on vacant lot greening in specific have reached differing conclusions. I will analyze Philadelphia's greening program and its effect on crime rates using Difference in Difference regressions and aggregate Wilcoxon rank sum comparisons between the greened vacant lots and control vacant lots that have not been greened. We make use of recent data from the Pennsylvania Horticultural Society, the Philadelphia Licenses and Inspections Office and the Philadelphia police department that so far has not been used in the literature.

This research is important because there has been a shift from programs that address violence/crime on an individual level basis to place-based interventions that address violence/crime from a structural perspective. Greening programs are an example of such a place-based policy that, while not specifically intended to lower crime rates, provide us an opportunity to study how a place based intervention to increase access to green space can affect public safety.


## Literature Review

Over the past 10 years, the number of vacant properties in the United States has been steadily rising. The trajectory of vacancy varies from city to city. Sunbelt cities like Phoenix and Miami saw a surge in vacancy rates during the Great Recession, but rates have since returned to pre crisis levels. In cities with a strong housing demand, like Washington DC, or San Francisco, the long term vacancy rates generally trend downward [@mallach2018empty]. This is not the case for the nation’s ‘legacy’ cities – former industrial cities like Detroit, Cleveland, Pittsburgh, and Philadelphia that have lost much of their peak population over the past few decades. Due to deindustrialization, recent economic downturns, and population outmigration, these legacy cities are face very high levels of vacancy. Detroit Future City - a nonprofit planning and advocacy organization - estimates that there are more than 120,000 vacant lots in Detroit [@detroitfuture17green]. Econsult – an economic consulting firm - estimates that Philadelphia has around 40,000 vacant lots  [@econsult10vacant]. Typically, these vacant lots are concentrated in the poorest neighborhoods  of cities.


Vacant buildings have a plethora of negative effects including increased fiscal strain on city services, the lowering of nearby property values, and the undermining of neighbor’s quality of life. Studies in Philadelphia estimated that vacant properties result in $3.6 billion in reduced household wealth because of the blighting effect they have on nearby properties [@econsult10vacant]. And a 2005 report from the National Vacant Properties Campaign found that “With abandoned buildings comes social fragmentation. Individuals who live in communities with an increasing number of vacant buildings begin to feel isolated, weakening the community as a whole” [@nationalvacant05vacant].

It’s also important to distinguish between vacant properties - buildings that have been abandoned - from vacant lots - lots without any standing buildings or structures. In a bid to reduce the blighting effects of vacant properties and to reduce the dangers that old dilapidated structures pose, many municipalities have started demolishing vacant buildings in effect turning them into vacant lots.

Cities have adopted a slew of policies to respond to the growing number of vacant lots/ t. Louis for example gives community residents the ability to buy vacant lots at very low prices – often for a $1 –  through a program called Mow to Own [@anderson18much]. Many vacant lots have also been turned into community gardens, and even vineyards. One of the unique approaches that the city of Philadelphia has taken revolves around low cost greening of lots, in effect turning vacant properties into mini parks. Most vacant lots are located in urban high density low income neighborhoods where public parks and greenspaces are in short supply [@wolch2005parks]. So Philadelphia’s greening program provides a unique opportunity to study what happens when historically deprived low income communities gain access to green space.

The history of lot greening programs in the United States is long and rich. Urban activists have been transforming vacant and abandoned places into community green spaces for decades, often without municipal approval. A good example of this is the Green Guerillas who built over 1000 urban gardens in New York in the 1970's [@schmelzkopf1995urban]. In recent years, many municipal government have given their explicit approval and are actively working with community organizations to encourage vacant lot greening. The type of land that has been greened is also expanding from single isolated lots to larger swaths of land. In cities like Detroit, recent initiatives seek to turn large groups of abandoned lots into urban farms and even forests [@goodyear13acre]. Greening programs in US cities are growing at a fast pace. Current day greening programs exist in many North American cities including Toronto, Seattle, Houston, Detroit, Boston, New York, Baltimore, Jacksonville, and Philadelphia and have only grown in popularity over the last few decades [@schilling2008greening]. As more of these programs are being incorporated into city government’s official responses to growing vacancy rates, there has also been a growing emphasis on researching exactly what the effects of green spaces are on the surrounding communities.

The primary intent of greening programs is to beautify neighborhoods and turn vacant lot into community greenspaces. But there have also been many second order effects which are equally important. For example much research has been conducted on the social, mental health, and environmental impacts of lot greening, and the overwhelming consensus is that greening provides positive benefits along those fronts. Green lots provide more robust storm water management, better air quality, decreased stress levels, and increased perceptions of health and exercise [@south2015neighborhood]. But the one area of analysis where evidence is a lot more contested is the impact of greened lots on neighborhood safety and crime rates.


Some scholars believe that greened lots would increase the crime rates of the neighborhoods they’re in. The theoretical reasons for this are that green spaces and parks often provide cover for criminal activity [@kuo2001environment]. They impede visibility and could also limit one’s ability to easily escape [@jackson2013health]. Finally, if green spaces bring in more people and vehicles into an area, there are more opportunities for criminals to strike in the first place. The empirical support for this line of thinking is also well established. Wolfe et. al examined the the association of vegetation with crime in Philadelphia and found that the higher the rates of vegetation in the neighborhood, the higher the likelihood of theft [@wolfe2012does]. Their methodology involved estimating the amount of greenery/vegetation in Philly neighborhoods through the use of satellites and aerial photography, which is harder to apply to vacant lots.  Garvin and co-authors conducted a similar analysis in 2012 on greened vacant lots in Philadelphia. They found that vandalism, burglaries, and robberies all significantly increased after a lot was greened [@garvin2013greening]. Another study by Branas and co-authors in 2011 found that the greened lots in Philadelphia were also associated with statistically insignificant increases in drug use and distribution, as well as disorderly conduct [@branas2011difference]. So in conclusion, research on vegetation in general and greened lots in particular find that certain types of crimes – notably place based crimes like theft and vandalism– have increased after a community obtains more green space.

On the other side of the argument are scholars who argue that green space should deter and lower crime rates. The theoretical underpinnings for this first come from Jane Jacobs “eyes on the street” theory, which is the idea that green spaces encourage more people to use the space and thus deter criminals from initiating a crime in the first place. Another theoretical underpinning for this view comes from social disorganization theory which posits that signs of physical disrepair, like vacant lots, send a message that the community is deteriorating and incentivizes criminal activity. So greening lots is a good way to counteract these signs of physical disorder. A final reason why greening may lead to reduced crime rates was proposed by Kaplan s that being in view of greenery and vegetation has a mentally restorative effect on potential criminals [@kaplan1989experience]. All together, these theoretical groundings paint a strong picture in favor of decreased crime rates.

The empirical support for this is equally strong. Wolfe and his coauthors (in the same study cited above) find that rates of vegetation are negatively correlated with rates of assaults and burglaries. A similar study by Kuo in and co-authors in 2012 find that vegetation is negatively correlated with aggravated assaults, and total violent crimes [@kuo2001aggression]. This study in particular gives strong support to the mental restoration hypotheses because it shows that people who live in areas with higher amounts of green space and vegetation had lower rates of interfamily violence after controlling for a host of other variables. Another study by Donovan and co-authors studied the amount of trees in a given neighborhood and its relationship to crime. They find that the larger and more populous trees are in a neighborhood, the fewer reports of vandalism and violent crime there are [@donovan2012effect]. At the end of the day, these studies provide support for green spaces leading to less crime but they are not specific to vacant lot greening, so now we turn to those studies.

Branas and coauthors (in the same article cited above) find that vacant lot greening in Philadelphia led to a significant decrease in gun assaults and vandalism. A similar study of vacant lot greening in Austin by Snelgrove and coauthors found that greening was associated with a significant reduction in the total amount of crimes and an even sharper reduction in the amount of violent crimes [@snelgrove2004urban]. Finally,  another study by Kuo and co-authors in 2001 found that vacant lot greening led to a statistically significant reduction in violent crimes [@kuo2001environment]. All in all, the literature suggests that vacant lot greening has a distinct negative impact on gun crimes and violent crime, while other less serious place based crimes like robberies and burglaries seem to go up.

Big questions that still remain in the literature as to exactly what crimes are impacted by vacant lot greening, how big those impacts are how long it takes for the impacts to be felt. This paper seeks to explore these questions by using recent data on vacant lots and crime in Philadelphia.

## Data

For this study, we combined data from 3 sources:

1) Greened vacant lot data (from the Pennsylvania Horticultural Society's LandCare program)
2) Control vacant lot data (from the Philadelphia Licenses and Inspections office)
3) Crime data (From the Philadelphia Police Department)


### Greened Vacant Lot Data

The first dataset comes from the Pennsylvania Horticultural Society (PHS), which administers Philadelphia’s LandCare program. This data reported all lots in the city that have been greened through PHS’s vacant lot greening program.  In total, there were 10,132 lots that were greened in the time period between 1993 and 2017. The data gives the address of the lot, the season it was greened in (Fall or Spring) and the square footage of the lot. For some lots, the date of greening was not recorded and we left them out of this analysis. There were not any identifiable systematic geographic biases in these excluded lots.

### Control Vacant Lot Data

The second dataset comes from the Philadelphia Licenses and Inspections office and lists all code violations in the city. The L&I office monitors building conditions in Philadelphia and issues code violations to properties that are in violation of the building code. One subtype of code violations is given to vacant and abandoned lots in the city. By filtering the data to only lots with these subtypes of code violations, we obtain data on all vacant (and ungreened) lots in Philadelphia. Overall, this data gave us 15,612 ungreened vacant lots from the years 2007 to 2017.


There are a couple of important notes about this dataset. First, there are many lots with multiple vacant violations and for consistency we only record the first violation. Second, a few of the lots appeared in both the LandCare greened lot data and the control vacant lot data. We assumed the LandCare data was more recent and deleted these overlapping lots from the control vacant lot data. This ensured lots appear only once in either the greened lot set or the control set. Third, many of the violations have now been closed, implying that the lots are no longer vacant. Some violations are not closed, implying that the lots are still vacant. This allows us to construct a vacancy timeframe for each lot where the vacancy start date is the date of the first issued violation and the vacancy end date is either the date the violation has been closed or the current date if the violation hasn’t been closed. Finally we limit the dataset to lots that have been vacant for atleast 2 years for reasons that will become apparent below.

Figure 2 is a map of where all the greened and ungreened lots are located in Philadelphia. Most vacant lots are located in West and South Philly, though the control lots are more spread throughout the city.


![Locations of Vacant Lots in Philadelphia](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/greended_vs_ungreened_lots_in_phl_eda.png)


### Crime Data

We obtained crime data from two separate sources. First, old crime data from 1995 to 2005 isn't publicly available but was given to us by the Penn Criminology Department. And newer crime data from 2005 till October 2018 was obtained from the Philadelphia Police Department and is publicly available at opendataphilly.org. The crime data reports crimetype, latitude/longitude coordinates, and date of crime. One note about this dataset is that the types of crime that were reported in the old crime dataset were more limited than the types of crimes reported in the newer crime dataset. To maintain consistency, we only keep crimetypes which were recorded in both datasets, leaving us with 1,510,789 crime records from 1995 to 2018. Figure 3 is a barplot of the number of crimes that fall within each of our crimetypes. The most common crimes are thefts and burglaries while the least common is homicide.

\newpage

![Crime counts by Crimetype (1995-2018)](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/crimetypes_breakdown.png)

### Combining the Data
Finally, we combined all the above data to create one unified dataset on crime change around lots in Philadelphia (both greened and ungreened). Specifically, we created a 70 meter buffer around each vacant lot and counted the number of crimes that occurred 11 months before and after the treatment date. The average block in Philadelphia has a radius of 140 meters, so a 70 meter buffer was chosen to cover the area of a full block around the lot. The 11 month before and after time frame was chosen to cancel out any seasonality in the crime data. Figure 4 shows what a 70 meter buffer zone around an example lot in the data looks like.


![70 meter buffer zone for 1803 N 8th Street](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/70m_radius.png)


We also assigned an intervention date to all the lots as follows. For greened lots, the intervention date was the date the lot was greened. For ungreened lots, the intervention date was the midpoint of the vacancy interval. So if a lot was vacant from January 2011 to January 2013, the treatment date was assigned as January 2012. This can be thought of as the date the lot would have been greened, had it been chosen to be a part of the LandCare program. Our final dataset was a listing of addresses, latitude/longitude pairs, a binary greening treatment variable, and crime statistics for each of our 22,434 lots. Below is a short excerpt of 3 random lots in our dataset.


|Address            |Intervention Date |Greened | Num Crimes before (70m)| Num Crimes after (70m)|
|:------------------|:-----------------|:-------|-----------------------:|----------------------:|
|3006 Broad St      |2008-12-28        |FALSE   |                       2|                      9|
|1701 S 22nd St     |2004-03-01        |TRUE    |                       6|                      6|
|1239 N 19th St     |2015-04-28        |FALSE   |                       4|                      2|

For further details on our data cleaning process, consult Appendix A.


## Results
### I. Aggregate Comparisons
For the first part of our data analysis, we analyzed how crime rates had changed on average at a 70 meter radius around greened lots and around ungreened control lots. The below table shows the average difference in number of crimes in the 11 months pre and post intervention date for greened vacant lots and control vacant lots broken down by crimetype. The Difference in Difference column is simply the average difference in number of crimes around greened lots minus the average difference in number of crimes around control lots. It represents the additive effect of greening on crime once you take into account crime trends around control lots. We also conduct a Wilcoxon rank-sum test to see if there is a statistically significant difference between crime change around greened lots and crime change around control lots. [^wilxox_note].

[^wilxox_note]:  The Wilcoxon rank-sum test is similar to a t-test and assesses whether two means are significantly different from each other. The key advantage is that the Wilcoxon test allows for non-normal distributions around the means.

\newpage

##### *Table 1: Unstandardized Aggregate Comparison and Wilcox tests*
|Crimetype           | Average difference (greened)| Average difference (control)| Difference in Difference| Wilcox test p value|
|:-------------------|----------------------------:|----------------------------:|------------------------:|-------------------:|
|Aggravated Assaults |                     0.036646|                    -0.062450|                 0.099098|           0.0031389|
|Burglaries          |                    -0.064200|                    -0.131050|                 0.066849|           0.0531337|
|Disorderly Conduct  |                    -0.057170|                    -0.043490|                -0.013680|           0.0027141|
|Homicides           |                     0.010554|                     0.000448|                 0.010106|           0.6598012|
|Public Drinking     |                     0.005717|                    -0.002630|                 0.008343|           0.0195992|
|Robberies           |                    -0.116240|                    -0.045220|                -0.071020|           0.0006443|
|Thefts              |                    -0.049400|                    -0.009610|                -0.039790|           0.0548307|
|Violent Crime       |                    -0.069040|                    -0.107230|                 0.038184|           0.1641667|
|Non Violent Crime   |                    -0.165050|                    -0.186780|                 0.021725|           0.3493958|
|All Crimes          |                    -0.234100|                    -0.294000|                 0.059909|           0.2109585|

###### *Notes: There were 6822 greened lots and 15612 control lots.



There are a couple of notable results. First, the number of total crimes decreases more around control lots (-0.29) than around greened lots (-0.23), and the difference in differences is +0.06. This means even though crime had reduced around greened lots, greened lots had on average 0.06 more crimes than the control lots. In other words, greening seems to have slowed down the crime reduction that would have taken place otherwise. The crimetypes with significant positive difference in differences (at a 5% confidence level) were the number of aggravated assaults (0.10) and public drinking (0.01). The crimetypes with significant negative difference in differences (at a 5% confidence level) were disorderly conduct and robberies. This initial analysis seems to suggest that greening actually increases the total number of crimes, particularly aggravated assaults and public drinking, relative to control vacant lots. Taking a step back, all of these averages are very small given that we're measuring crime change across a year. It is hard to see how 0.26 less crimes in the year after greening would actually affect public safety.

This analysis has one big shortcoming, Namely, we've assumed that control lots and vacant lots are directly comparable and the only difference between them is that some of them were greened. However, greened lots and control lots as an aggregate tend to be located in different kinds of neighborhoods. Below is a comparison of the socioeconomic characteristics of the average neighborhood that control lots and greened lots are located in. Control vacant lots tend to be in neighborhoods with higher poverty rates, higher share of black residents, lower share of white residents and lower college education rates than the average neighborhood in Philadelphia.
Greened lots tend to be in neighborhoods with even higher poverty rates, even higher share of black residents, even lower share of white residents and even lower college education rates. We needed a way of measuring crime change while also taking into account the different surrounding neighborhoods of greened and control vacant lots.


![Demographic profiles of control and greened vacant lots](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/demo_profil_lots.png)

###### *Notes: These statistics were calculated by using a prototype Data Bias Assessment tool from the Urban Institute. It uses tract level Census data to calculate citywide demographic averages, and then uses the proportion of the datapoints falling into each tract to 'weight' the Census variables and return the demographic averages implied by the data. *


### II. Aggregate Comparisons (Standardized)

So, we decided to create a crime metric for each lot that takes into account the crime change in the surrounding neighborhoods. This standardized crime change variable was the difference in crimes at a 70 meter buffer minus the number of crimes at a 500 meter 'doughnut' buffer. In terms of the below chart, the standardized crime change is the difference in crimes within the blue circle minus the difference in crimes within the orange 'doughnut'.

\newpage
![ 70m and 500m buffers for 1803 N 8th Street](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/70m_radius_doughnut.png)

The crime change at a 500 meter 'doughnut' buffer tells us about the neighborhood level crime trends. And the crime change at a 70 meter buffer tells us about the localized crime trends around a vacant lot. The difference between these crime changes (ie the Difference in Difference) will tell us what the additive effect of greening is relative to the neighborhood level crime trends. The crime change was also standardized per square kilometer - that is divided by the area of the buffer in square kilometers - so that the differences in crimes could be directly comparable across different buffer sizes.  Below are the mean standardized differences in number of crimes per square kilometer for greened vacant lots and control vacant lots broken down by crimetype, along with the Wilcoxon rank-sum test's p-value for the differences in differences.


##### *Table 2: Standardized Aggregate Comparison and Wilcox tests*
Crimetype           | Standardized difference (greened)| Standardized difference (control)| Difference in Difference| Wilcox test p value|
|:------------------|---------------------------------:|---------------------------------:|------------------------:|-------------------:|
|Aggravated Assaults |  4.506| -2.364|  6.870| 0.000|
|Burglaries          | -1.850| -2.446|  0.596| 0.514|
|Disorderly Conduct   | -2.350|  0.329| -2.678| 0.996|
|Homicides           |  0.826|  0.058|  0.769| 0.012|
|Public Drinking     |  0.241| -0.297|  0.537| 0.600|
|Robberies           | -5.029| -0.512| -4.517| 0.036|
|Thefts              | -2.577|  0.302| -2.878| 0.060|
|Violent Crimes      |  0.304| -2.818|  3.122| 0.057|
|Non Violent Crimes  | -6.536| -2.113| -4.423| 0.477|
|All                 | -6.232| -4.931| -1.302| 0.991|

###### *Notes: There were 6822 greened lots and 15612 control lots. Standardized crime counts are the number of crimes per square Km in the 70 meter buffer - number of crimes per square Km in the 500 meter doughnut buffer. The standardized differences is the standardized crime counts 11 months after -  the standardized crime counts 11 months before.*


For greened lots, all crimes except for aggravated assaults, homicides and public drinking went down in relation to the neighborhood level crime trends. And for control lots, all crimes except for homicides, disorderly conduct and thefts went down in relation to the neighborhood level crime trends. Since homicides are a low frequency and unpredictable crime type, this result should not be read into too much. Finally the difference in differences -  which can be thought of as the additive effect of greening on crime in relation to neighborhood level crime trends and control vacant lots - show similar results to the unstandardized results above. Namely, the number of disorderly conducts, robberies and thefts went down while the number of burglaries, homicides, and public drinking went slightly up. Interestingly, the total number of crimes and non violent crimes go down (thought not at a statistically significant level), in contrast to the unstandardized analysis above. This is because while the signs are the same between the unstandardized and standardized analyses, the magnitudes of the negative results are larger in the standardized analysis.

### III. Difference in Differences Regression

The above aggregate comparisons are very similar in methodology to a Difference in Differences regression. To check the validity of our results, we also conduct a Difference in Difference regression using control and greened lots. First our dataset had to be transformed to look like the following:


|Address            |Intervention Date |Greened | Time| Num Crimes         |
|:------------------|:-----------------|:-------|-----|-------------------:|
|3006 Broad St      |2008-12-28        |0       |   0 |                   2|
|3006 E Thompson St |2008-12-28        |0       |   1 |                   2|
|1701 S 22nd St     |2004-03-01        |1       |   0 |                   6|
|1701 S 22nd St     |2004-03-01        |1       |   1 |                   6|
Then the regression setup was as follows

$Y_{i} = \beta_0 + \beta_1 X_{Time} + \beta_2 X_{Greened} + \beta_3 X_{Greened:Time}$

Where $Y_i$ is the number of crimes. In this case the DID coefficient of interest is $B_3$ which tells us what the additive effect of a lot being greened is on crime rates. There are some important notes about our approach. First, this approach assumes there are no time specific fixed effects. In other words there should be no additional effect on crime whether a lot was greened in 2001 or 2018. This is an important assumption because our dataset spans the 21 years from 1997 to 2018. We verified this assumption was valid by plotting the difference in number of crimes for all the lots in the dataset. For easier viewing, we  overlaid a local polynomial regression line in green. There seem to be no clear patterns over time for either greened or ungreened control lots, so our assumption of no time specific fixed effects is valid.

![Differences in Crimes over Time](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/diff_crimes_over_time.png)

##### *Notes: Each point represents a lot in the dataset. The x axis is the year of the intervention data and the y axis is the difference in total number of crimes 11 months after vs 11 months before in 70 meter buffer zone. Due to data limitations, the Ungreened control lots span fewer years than the greened lots.*

We ran a series of DID regressions using different values for the dependent variable $Y_i$. The dependent variables we used were total number of crimes broken down by crimetype (ie total number of Aggravated Assaults, Burglaries, Thefts etc) as well as number of non violent crimes, violent crimes, and all crimes. We also used standardized crime counts (which took into account the number of crimes in the surrounding neighborhood using the 'doughnut' approach described above) as well as dependent variables. The DID estimates and their 95% confidence intervals from each of those regression is summarized in the below graph.

![DID Estimates for Standardized and Unstandardized Crime Counts](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/did_estimators_plot.png)

These chart mirrors the results found in the aggregate comparison section. When looking at the unstandardized crime counts, the DID estimate is negative only for thefts, disorderly conducts, and robberies. This remains true for the standardized crime counts, but now the DID estimates for total number of crimes and non violent crimes flips and becomes negative. In short, greening reduced the total number of non violent crimes, mostly through reductions in thefts, robberies, and disorderly conduct citations. There also seems to be an increase in violent crimes driven mostly by increases in aggravated assaults. The only strongly significant effects (at the 5% level) are the decrease in robberies and the increase in aggravated assaults.

For robustness, we replicated the above analysis at a base buffer distance of 150 meters instead of 70 meters, and the results mostly the same. For the actual results, consult Part B of the Appendix.

## Discussion

The big takeaway is that greening reduces the number of robberies and the number of non violent crimes - mainly through reductions in disorderly conduct citations robberies - after taking into account crime trends in the surrounding neighborhood and crime trends around control vacant lots. There is also a corresponding increase in the number of aggravated assaults. These results are for the most part statistically significant at the 5% level. There are also statistically insignificant increases in the number of burglaries, homicides, and public drinking citations. This aligns with some of the previous literature by showing reductions in disorderly conduct citations and thefts but also contradict the literature by showing an increase in violent crimes like aggravated assaults.

The reasoning behind why greening leads to less thefts and robberies is pretty straightforward. A theft is the taking of property that does not involve person to person contact. A robbery is the taking of property that does involve person to person contact with force, intimidation or coercion (and is considered violent). Since robberies and thefts are crimes of opportunity, a greened lot means more human activity and less opportunity for criminals to find unsuspecting/unwatched targets. This aligns with the eyes on the street theory of public safety described in the literature review.

On the other hand, the reasoning for why there was a corresponding decrease in disorderly conduct citations and increase in aggravated assaults is less straightforward. The charge of disorderly conduct is vague in nature and covers a host of offences including engaging in fighting or threatening behavior, making unreasonable noise, and using obscene languages/gestures. This kind of arrest is dependent on officers' discretion. So it could also be that police officers have changed how/when they charge people with disorderly conduct. Or it could mean residents are less likely to behave in a disorderly manner around greened lots again because there is more human activity and eyewitnesses. The increase in aggravated assaults is particularly hard to rationalize as most of the literature finds that greenspace has a mentally restorative effect on residents and reduces the amount of violent crimes.


## Limitations

This analysis has plenty of limitations and should be taken with a grain of salt. To list a few:

1) There is large potential for cross contamination in our results as many vacant and control lots are clustered closely together. In other words crime change could be due to the presence of multiple greened lots within the buffer radius. In this paper we don't make any attempts to adjust for the number of  greened/control vacant lots that fall within the buffer zone.

2) The control and treatment lots are not exactly the same, violating some assumptions of a DID regression. Specifically the parallel trend assumption of a DID regression requires that control and treatment observations have to follow the same trend before the treatment. Due to data limitations, the control lots only span the years 2001 to 2018 while the greened lot data span the years 1993 - 2018. In addition the control and treatment lots were in slightly different parts of Philadelphia and in socioeconomically different neighborhoods. Overall, it is unlikely that control and treatment lots follow the same trend.

3) We tried to correct for the differing locations treatment and control lots by using doughnut 'standardized' crime counts. However our doughnut standardization increases the possibility of cross contamination by using an even larger radius of 500 meters for comparison. Furthermore the fact that our standardized and unstandardized approaches yielded approximately the same results is a sign that our standardization is not really effective. Our approach still doesn't truly incorporate the varying density of greened and vacant lots throughout the city.

4) Upon visual inspection using Google Street View, there were some groups of greened lots that were greened as one contiguous lot. However, in the PHS data they were reported as several separate lots. So our dataset overrepresents these large contiguously greened lots.


## Conclusion

Our analyses paint a nuanced picture of how crime changes around vacant lots. After taking into account crime change around control lots and the neighborhood level crime trends, the two statistically significant results (at a 95% confidence level) are a decrease in robberies and an increase in aggravated assaults. There were also statistically insignificant decreases in thefts and disorderly conduct citations accompanied with an increase in homicides, burglaries and public drunkenness. Overall we saw a reduction of 4.5 non violent crimes, an increase of 3.1 violent crimes and a decrease in 1.3 total crimes per square kilometer in the 11 months after a lot was greened. These numbers are small in magnitude and suggest that crime is not affected by just greening

Future extensions of this paper would aim to match control lots to treatment lots at a more granular level, perhaps using propensity score matching or Manhanalobis distance matching, to more accurately compare similar control and treatment lots.


\newpage

## Appendix A: Data Cleaning Procedures

#### Greened Lot Data

The dataset from PHS contained the address of the lots that were greened, the season (Fall or Spring) and year the lot was greened, the latitude/longitude, and the square footage. However after talking with PHS personnel, it was revealed that all lots were greened in March of their reported year. For this reason we defined the variable `date_season_begin` as 03/01/Year, where the Year varies from lot to lot. We also assumed that the treatment period was 1 month, in other words that it took the whole of March for PHS to finish greening all of their assigned vacant lots.


#### Ungreened Lot Data

The Philadelphia Licenses and Inspections Office hosts the L&I Violation dataset in an online CartDB database, meaning end users can send queries and filter the data as necessary. One important field in the dataset is `violationdescription` which as the name implies is the L&I listed reason for the code violation. In order to figure out which violation descriptions were associated with vacant lots, we manually went through each violation description and used Google Street View to see which violations actually signified vacant lots. We observed that the following 4 violation descriptions were associated with vacant lots and used them as filters in order to identify all vacant lots in the city:

- VACANT LOT KEEP CLEAN GET LIC
- LICENSE - VACANT LOT
- VACANT LOT STANDARD
- EXT A-VACANT LOT CLEAN/MAINTAI

As noted in the paper, there were many addresses (6754) which appeared in both our derived ungreened vacant lot dataset and in the official greened lot dataset given to us by PHS. Below is a map of the lots that appeared in both datasets. There doesn't seem to be any visual systematic geographic bias as to which greened lots were included in our ungreened lot dataset. We deleted these addresses from the Ungreened lot dataset and kept it in the Greened Lot dataset as it could be possible for greened lots to be wrongly issued violation, and it is very unlikely that an ungreened vacant lot was included in the official greened lot dataset we obtained from PHS.

![Duplicate Lots that appeared in Greened and Ungreened Lot Data](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/duplicated_lots_in_phl.png)
\

There were also many addresses with multiple L&I violations. Below is a histogram of the number of violations for each lot.

![Number of Violations over all Ungreened Lots](C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/graphs/num_violations_ungreened_hist.png)

Most lots had 1 or 2 violations but there is a long right tail, meaning some lots had violations in the 10s and 20s. We simplified all lots with multiple violations into one record and only recorded two variables for each lot: date_vacant_begin and date_vacant_end. Their definitions are given below:

- date_vacant_begin: Date of the first issued violation. So if there are multiple violations, the vacant_date_begin is the day the very first violation was assigned
- date_vacant_end: Either the case resolution date of the last violation (ie when the last violation was closed by the L&I office) or if none is available, then the day the data was pulled (11/08/13). The reasoning behind this was that if the last assigned violation was closed, then there is a chance the lot is no longer vacant. This may not be true as some violations may simply require that residents get a permit for a vacant lot and the violation is closed once the permit is obtained. However we err on the side of caution and assume that if the last violation is closed, then the lot is no longer vacant as of the last case resolution date. Otherwise, if the last violation was not closed by the L&I office, then we assume that the property is still vacant and assign the date_vacant_end as the day the data was pulled.

The interval between date_vacant_begin and date_vacant_end form a vacancy interval for each lot. We further limit the dataset to lots that have a vacancy interval of atleast two years. This is because our before and after study period for crime change is 2 years so we want to make sure that vacant lots remain vacant throughout the study period.

There were 28 lots without latitude/longitude provided and they were excluded from our analysis. The final caveat is that there were 5 lots where slightly different latitudes/longitudes were reported for different violation at the same address. The points are very close together and could be due to measurement error, so to minimize error we simply take the centroid of the points for these 5 datapoints. The addresses of those multipoint lots are reported below.

|Full Address                            |
|:---------------------------------------|
|2116 E York St, Philadelphia, Pa        |
|2729-31 E Thompson St, Philadelphia, Pa |
|2946 N 2nd St, Philadelphia, Pa         |
|4923r-47 N 16th St, Philadelphia, Pa    |
|6229 Harley Ave, Philadelphia, Pa       |


#### Crime Data

Our crime data is a combination of old crime data from 1998 to 2005 and new crime data from 2006 till present day. One discrepancy between the old and the new data is that the old data used broader crime categories while the newer data used more granular crime categories. In order to maintain consistency, we keep all crime categories in terms of the broader 2005 crime categories. The transalation table we use is shown below

|New Crimetype                 |2005 Crimetype      |
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

There was one other crimetype reported in 2005 - Illegal Dumping - but it was relatively small in proportion (0.007 % of all crimes) and wasn't reported in the newer crime data, so we excluded Illegal Dumping crimes from this analysis. We also defined Aggravated Assaults, Robberies, Homicides as `Violent Crimes` and all other crimes as `Non Violent Crimes` for use in analyses.

\newpage

## Appendix B: Results at 150 meter Buffer Distance instead of 70 meters

##### *Table 3: Unstandardized Aggregate Comparison and Wilcox tests (150 meters)*
| Crimetype            |  Average difference (greened) |  Average difference (control) |  Difference in Difference |  Wilcox test p value |
|:---------------------|-----------------------------:|-------------------------------:|---------------------------------:|---------------------:|
| Aggravated Assault | 0.0366 | -0.0625 | 0.0991 | 0.0002 |
| Burglaries | -0.0642 | -0.1311 | 0.0668 | 0.0096 |
| Disorderly Conduct | -0.0572 | -0.0435 | -0.0137 | 0.5901 |
| Homicides | 0.0106 | 0.0004 | 0.0101 | 0.0625 |
| Public Drinking | 0.0057 | -0.0026 | 0.0083 | 0.0193 |
| Robberies | -0.1162 | -0.0452 | -0.071 | 0.0004 |
| Thefts | -0.0494 | -0.0096 | -0.0398 | 0.262 |
| Violent Crime | -0.069 | -0.1072 | 0.0382 | 0.2662 |
| Non Violent Crime | -0.1651 | -0.1868 | 0.0217 | 0.6769 |
| All | -0.2341 | -0.294 | 0.0599 | 0.3619 |


##### *Table 4: Standardized Aggregate Comparison and Wilcox tests (150 meters)*

| Crimetype            |  Standardized difference (greened) |  Standardized difference (control) |  Difference in Difference |  Wilcox test p value |
|:---------------------|-----------------------------:|-------------------------------:|---------------------------------:|---------------------:|
| Aggravated Assault | 6.3339 | 0.1338 | 6.2001 | 0 |
| Burglaries | -4.299 | -2.5193 | -1.7797 | 0.0219 |
| Disorderly Conduct | 0.9251 | -0.808 | 1.7331 | 0.0231 |
| Homicides | 0.4171 | 0.0989 | 0.3182 | 0.0637 |
| Public Drinking | 0.3547 | -0.1423 | 0.4971 | 0.0001 |
| Robberies | -6.0461 | -0.4577 | -5.5884 | 0 |
| Thefts | -0.2228 | 2.0036 | -2.2265 | 0.0748 |
| Violent Crime | 0.7049 | -0.225 | 0.9299 | 0.3917 |
| Non Violent Crime | -3.242 | -1.4661 | -1.7759 | 0.2916 |
| All | -2.5371 | -1.691 | -0.846 | 0.6842 |
\newpage

## Works Cited
