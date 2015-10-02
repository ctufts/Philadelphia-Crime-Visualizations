rm(list = ls())
library(dplyr)
library(lubridate)
library(RCurl)

# download the csv files for 2006-2014
ds <- NULL
# urls
url.names <- c(#2014
               'http://data.phl.opendata.arcgis.com/datasets/6d96e221f41a44949820d8645db07d85_0.csv',
               # 2013
               'http://data.phl.opendata.arcgis.com/datasets/bcebd896ce4a4f7eb2336c00c3f0ca97_0.csv',
               #2012
               'http://data.phl.opendata.arcgis.com/datasets/27ffa39726514ba8a433131d67498fa9_0.csv',
               #2011
               'http://data.phl.opendata.arcgis.com/datasets/4ce9d9633e814d2ba455423dce9e8d9a_0.csv',
               #2010
               'http://data.phl.opendata.arcgis.com/datasets/768db9016a7e48b6a53f705c6eacd4cc_0.csv',
               #2009
               'http://data.phl.opendata.arcgis.com/datasets/03964472996c49ca913e07507d3dd28f_0.csv',
               #2008
               'http://data.phl.opendata.arcgis.com/datasets/9a2a182643de40e18a1b831a7d7de49b_0.csv',
               #2007
               'http://data.phl.opendata.arcgis.com/datasets/06fdccfe795a4bd7b32160ada1d37178_0.csv',
               #2006
               'http://data.phl.opendata.arcgis.com/datasets/6b910edd9ca74577b50eab71564772f4_0.csv'
)

for(i in url.names){
  fin = getURL(i)
  ds <- rbind(read.csv(text = fin), ds)
}


ds$DISPATCH_DATE <- ymd(ds$DISPATCH_DATE)
ds$TEXT_GENERAL_CODE <- as.character(ds$TEXT_GENERAL_CODE)
ds$TEXT_GENERAL_CODE[ds$TEXT_GENERAL_CODE == "Homicide - Criminal "] <- 
  "Homicide - Criminal"
ds$TEXT_GENERAL_CODE <- as.factor(ds$TEXT_GENERAL_CODE)


# preprocess coordinate data
# only want the date time, coordinates, and crime type
coordinates <- select(ds, DISPATCH_DATE_TIME,TEXT_GENERAL_CODE,POINT_X,POINT_Y)
coordinates$DISPATCH_DATE_TIME <- ymd_hms(coordinates$DISPATCH_DATE_TIME)
coordinates <- na.omit(coordinates)
coordinates$year  <- year(coordinates$DISPATCH_DATE_TIME)
coordinates$month <- month(coordinates$DISPATCH_DATE_TIME) 
write.csv(coordinates, 'data/coordinates.csv')





# create the event log
# # of incidents/day split by type 

event.log <- ds %>% group_by(DISPATCH_DATE, TEXT_GENERAL_CODE) %>%
  summarise(
    event.count = n()
  )

event.log$year <- year(event.log$DISPATCH_DATE)
event.log$month <- month(event.log$DISPATCH_DATE)
event.log$yday   <- yday(event.log$DISPATCH_DATE)
write.csv(event.log, 'data/eventLog_2006to2014.csv')
