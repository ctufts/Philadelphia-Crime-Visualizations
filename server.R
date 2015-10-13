
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

server <- function(input, output, session) {
  
  # split it into multiple plots,
  # put the data filtering into an observer
  # then display the general trend and the seasonal trend
  observe({
    data <- filter(event.log, 
                   General.Crime.Category == input$crime.type) %>%
      arrange(Dispatch.Date)
    # all crimes except negligent and justifiable homicide (these have very low numbers)
    # have a full 36 months of data
    z.ts <- ts(data$events, frequency = 12, start = c(min(year(data$Dispatch.Date)),1))
    z.decomp <- decompose(z.ts)
    z.decomp <- data.frame(x = as.numeric(z.decomp$x), 
                           seasonal = as.numeric(z.decomp$seasonal),
                           trend = as.numeric(z.decomp$trend),
                           Dispatch.Date  = data$Dispatch.Date)
    
    output$original.signal <- renderPlot({
       ggplot(z.decomp, aes(x = Dispatch.Date, x)) +
        geom_point(color = "#E4002B", size = 3) + geom_line(color = "#7A99AC") +
        labs(x = 'Date', y = 'Incidents', title = 'Total Incidents') + fte_theme() +
        scale_x_date(labels=date_format('%m/%y'))
      
  
    })
    output$trend  <- renderPlot({
     ggplot(z.decomp, aes(x = Dispatch.Date, trend)) + 
        geom_point(color = "#E4002B") + geom_line(color = "#7A99AC") +
        labs(x = 'Date', y = 'Incidents', title = 'Trend') + fte_theme() +
        scale_x_date(labels=date_format('%m/%y'))
      
    })
    output$season  <- renderPlot({
      ggplot(z.decomp, aes(x = Dispatch.Date, seasonal)) + 
        geom_point(color = "#E4002B") + geom_line(color = "#7A99AC") + 
        labs(x = 'Date', y = 'Incidents', title = 'Seasonal Trend') + fte_theme() + 
        scale_x_date(labels=date_format('%m/%y')) 
      
    })
  
  })
  
#   output$mymap <- renderLeaflet({
#     
#     points <- filter(coordinates, 
#                      General.Crime.Category == input$crime.type.map & 
#                        year %in% input$year.map)
#     
#     leaflet() %>%
#       addProviderTiles('CartoDB.Positron') %>%
#       setView(lng=-75.06048, lat=40.03566, zoom = 11) %>%
#       addCircleMarkers( data = points,
#                         lat = ~POINT_Y, lng = ~POINT_X,
#                   clusterOptions = markerClusterOptions()
#       )
# 
#   })

 

}