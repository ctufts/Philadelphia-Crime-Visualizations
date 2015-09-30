
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

server <- function(input, output, session) {
  

  output$plot1 <- renderPlot({
    data <- filter(event.log, 
                   TEXT_GENERAL_CODE == input$crime.type & 
                     year %in% input$year) %>%
                     group_by(month,year) %>%
                     summarise(
                       monthly.count = sum(event.count)
                     )
    ggplot(data, 
           aes(x = month, y = monthly.count, color = factor(year))) +
      stat_smooth(se = F) + geom_point() + 
      scale_color_brewer(palette="Set1",
                         name = "Year") + 
        labs(title = paste('Philadelphia Crime Occurences:', input$crime.type),
             x = "", y = "Occurrences") + 
      scale_x_continuous(breaks = 1:12, labels = month(1:12, label = T) ) +
      fte_theme()
  })
  
  
  
  output$mymap <- renderLeaflet({
    
    points <- filter(coordinates, 
                     TEXT_GENERAL_CODE == input$crime.type.map & 
                       year %in% input$year.map)
    
    leaflet() %>%
      addProviderTiles('CartoDB.Positron') %>%
      setView(lng=-75.06048, lat=40.03566, zoom = 11) %>%
      addCircleMarkers( data = points,
                        lat = ~POINT_Y, lng = ~POINT_X,
                  clusterOptions = markerClusterOptions()
      )
    #filter(points, month == ts$counter)
  })
  output$mapAnimation <- renderLeaflet({
    
    points <- filter(coordinates, 
                     TEXT_GENERAL_CODE == input$crime.type.map & 
                       year %in% input$year.map)
    
    leaflet() %>%
      addProviderTiles('CartoDB.Positron') %>%
      setView(lng=-75.06048, lat=40.03566, zoom = 11) %>%
      addCircleMarkers( data = points,
                        lat = ~POINT_Y, lng = ~POINT_X,
                        clusterOptions = markerClusterOptions()
      )
    #filter(points, month == ts$counter)
  }) 
 

}