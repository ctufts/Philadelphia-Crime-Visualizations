rm(list = ls())
library(dplyr)
library(ggplot2)
library(lubridate)
library(RColorBrewer)
library(leaflet)
source('fte_theme.R')
source('multiplot.R')

ds <- read.csv('data/PPD_Crime_Incidents_2012-2014.csv')
ds$Dispatch.Date.Time <- mdy_hms(ds$Dispatch.Date.Time)
ds$Dispatch.Date <- as.Date(ds$Dispatch.Date.Time)
day(ds$Dispatch.Date) <- 1 
ds$month         <- month(ds$Dispatch.Date)
ds$year          <- year(ds$Dispatch.Date)
# get the number of events per district by category
district.crime.summary <-  ds %>% group_by(General.Crime.Category,
                                           Dispatch.Date) %>% 
  arrange(Dispatch.Date) %>%
  summarise(
    events = n()
  )


unique.crimes <- unique(district.crime.summary$General.Crime.Category)
ts.df <- data.frame(stringsAsFactors = F)
for( i in 1:length(unique.crimes)){
  temp <- filter(district.crime.summary, 
                 General.Crime.Category == unique.crimes[i]) %>%
    arrange(Dispatch.Date)
  # all crimes except negligent and justifiable homicide (these have very low numbers)
  # have a full 36 months of data
  if(nrow(temp) == 36){
    z.ts <- ts(temp$events, frequency = 12, start = c(min(year(temp$Dispatch.Date)),1))
    z.decomp <- decompose(z.ts)
    ts.df <- rbind(ts.df, 
                   data.frame(x = as.numeric(z.decomp$x), 
                              seasonal = as.numeric(z.decomp$seasonal),
                              trend = as.numeric(z.decomp$trend),
                              figure = as.numeric(rep(z.decomp$figure,3)),
                              type = rep(z.decomp$type, 36),
                              crime = as.character(temp$General.Crime.Category), 
                              date  = temp$Dispatch.Date)
                   
                   )
    
  }
}

for(i in unique(ts.df$crime)){
  temp <- filter(ts.df, crime == i)
  g.season <- ggplot(temp, aes(x = date, seasonal)) + 
    geom_point(color = "#E4002B") + geom_line(color = "#7A99AC") + fte_theme() +
    theme(axis.ticks = element_blank(), axis.text.x = element_blank()) + 
    labs(title = i)
  g.trend  <- ggplot(temp, aes(x = date, trend)) + 
    geom_point(color = "#E4002B") + geom_line(color = "#7A99AC") + fte_theme()
  g.x      <- ggplot(temp, aes(x = date, x)) +
    geom_point(color = "#E4002B") + geom_line(color = "#7A99AC") + fte_theme() +
    theme(axis.ticks = element_blank(), axis.text.x = element_blank())
  multiplot(g.x, g.season, g.trend)
}