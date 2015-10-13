rm(list = ls())
library(dplyr)
library(ggplot2)
library(lubridate)
library(RColorBrewer)
library(leaflet)
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

# event.log <- read.csv('datadata/eventLog_2006to2014.csv')
# coordinates <- read.csv('data/coordinates.csv')
# coordinates$DISPATCH_DATE_TIME <- ymd_hms(coordinates$DISPATCH_DATE_TIME)
crime.type <- unique(as.character(event.log$General.Crime.Category))
unique.years <- unique(event.log$year)