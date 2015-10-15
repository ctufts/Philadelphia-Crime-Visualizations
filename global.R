rm(list = ls())
library(dplyr)
library(ggplot2)
library(lubridate)
library(RColorBrewer)
library(leaflet)
library(stringr)
library(rgdal)
source('fte_theme.R')
source('multiplot.R')

ds  <- read.csv('data/PPD_Crime_Incidents_2012-2014.csv')
ds$Dispatch.Date.Time <- mdy_hms(ds$Dispatch.Date.Time)
ds$Dispatch.Date <- as.Date(ds$Dispatch.Date.Time)
day(ds$Dispatch.Date) <- 1 
ds$month         <- month(ds$Dispatch.Date)
ds$year          <- year(ds$Dispatch.Date)
# get the number of events per district by category
event.log <-  ds %>% group_by(General.Crime.Category,
                                           Dispatch.Date) %>% 
  arrange(Dispatch.Date) %>%
  summarise(
    events = n()
  )

# clean up coordinates

ds$Coordinates<- gsub(")", "", ds$Coordinates)
ds$Coordinates<- gsub("\\(", "", ds$Coordinates)
coord.list <- (str_split(ds$Coordinates, ","))
y <- as.numeric(unlist(lapply(coord.list, function(x)x[1])))
x <- as.numeric(unlist(lapply(coord.list, function(x)x[2])))
coordinates <- data.frame(POINT_Y = y,
                          POINT_X = x,
                          General.Crime.Category = ds$General.Crime.Category,
                          District = ds$District
)
coordinates <- na.omit(coordinates)
coordinates$District[coordinates$District==23] <- 22
# event.log <- read.csv('datadata/eventLog_2006to2014.csv')
# coordinates <- read.csv('data/coordinates.csv')
# coordinates$DISPATCH_DATE_TIME <- ymd_hms(coordinates$DISPATCH_DATE_TIME)
crime.type <- unique(as.character(event.log$General.Crime.Category))
unique.years <- unique(event.log$year)


# get shape and incident count data for maps
districts <- readOGR(dsn = "data/shp",
                  layer = "Police_Districts", verbose = FALSE)

district.log <- coordinates %>% group_by(General.Crime.Category, District) %>%
  summarise(
    events = n()
  )


