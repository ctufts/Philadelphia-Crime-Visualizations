
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

ui <- shinyUI(
  
  
  navbarPage("Philadelphia Crime Statistics",
             theme = "style.css", 
             # includeCSS("map.css"),

  ## Sidebar content
    tabPanel("Crime Trends",
      sidebarLayout(
        sidebarPanel(
          # menuItem("Widgets", tabName = "widgets", icon = icon("th")),
          selectInput("crime.type", "Crime Description", 
                      choices = crime.type, selected = crime.type[7]),
          checkboxGroupInput("year", label = "Year",
                             choices = unique.years,
                             selected = tail(unique.years,2), 
                             inline = T)
        ),
        mainPanel( 
          fluidRow(column(plotOutput("plot1"), width = 11)),
          fluidRow(column(includeMarkdown('references.Rmd'), width = 11))
        )
      )
    ),
  tabPanel("Map",
           sidebarLayout(
             sidebarPanel(
               selectInput("crime.type.map", "Crime Description", 
                           choices = crime.type, selected = crime.type[1]),
               selectInput("year.map", "Year",
                           choices = unique.years, selected = unique.years[1])
             ),
             mainPanel( 
               fluidRow(column(leafletOutput("mymap"), width = 11)),
               fluidRow(column(includeMarkdown('references.Rmd'), width = 11))
             )
           )
  )
  
  )
)
