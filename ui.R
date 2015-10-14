
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
                      choices = crime.type[crime.type != 'Homicide - Gross Negligence' &
                                             crime.type != 'Homicide - Justifiable'],
                      selected = crime.type[1]),
          includeMarkdown('references.Rmd')
          
        ),
        mainPanel( 
          fluidRow(column(plotOutput("original.signal", height = "150px"),width = 11)),
          p(),
          fluidRow(column(plotOutput("trend", height = "150px"), width = 11)),
          p(), 
          fluidRow(column(plotOutput("season", height = "150px"), width = 11))
          # fluidRow(column(includeMarkdown('references.Rmd'), width = 11))
        )
      )
    ),
  tabPanel("Map",
           sidebarLayout(
             sidebarPanel(
               selectInput("crime.type.map", "Crime Description", 
                           choices = crime.type, selected = crime.type[1])
               
             ),
             mainPanel( 
               fluidRow(column(leafletOutput("mymap"), width = 11)),
               fluidRow(column(includeMarkdown('references.Rmd'), width = 11))
             )
           )
  )
  
  )
)
