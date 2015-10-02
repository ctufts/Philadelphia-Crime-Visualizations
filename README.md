# Philadelphia-Crime-Visualizations
R Shiny App for visualizing Philadelphia Crime Data

The app currently includes:
* A Leaflet Map showing the locations of the incidents reported based on a selected crime type and year

![alt tag](https://github.com/ctufts/Philadelphia-Crime-Visualizations/blob/master/images/phillyCrimeMap.gif)

* Monthly crime incident counts based on a selected year and crime type

![alt tag](https://github.com/ctufts/Philadelphia-Crime-Visualizations/blob/master/images/crimeTrends.gif)

The data used in the app is hosted at [Open Data Philly](https://www.opendataphilly.org/dataset/crime-incidents).  

## Prerequisites (Only needs to be done one time)
1. Create a 'data' folder.
2. Run 'preprocess/collectAndCleanData.R'. This will download all the 'Crime Part 1' csv files for 2006-2014, then pre-process the data.  This only needs to be done once as the data will then be written to the 'data' folder (which is ignored via the .gitignore). 

## Run the App
Run the Shiny App via the shiny::runApp() command or via Rstudio GUI.
