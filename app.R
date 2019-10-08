library(shiny)
library(leaflet)
library(photosearcher)

##

#photo_meta <- structure(list(latitude = c(51.524923, 51.534803, 51.53511, 51.528067, 
#                                 51.542116, 51.564689), longitude = c(-0.10621, -0.10063, -0.13098, 
#                                                                     -0.066662, -0.036561, -0.054239), URLS = structure(c(6L, 1L, 
#                                                                                                                         2L, 3L, 4L, 5L), .Label = c("https://images.pexels.com/photos/1103715/pexels-photo-1103715.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260", 
#                                                                                                                                                    "https://images.pexels.com/photos/1104365/pexels-photo-1104365.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260", 
#                                                                                                                                                   "https://images.pexels.com/photos/14111/pexels-photo-14111.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260", 
#                                                                                                                                                  "https://images.pexels.com/photos/358429/pexels-photo-358429.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260", 
#                                                                                                                                                 "https://images.pexels.com/photos/583850/pexels-photo-583850.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260", 
#                                                                                                                                                "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260"
#                                                                                                                   ), class = "factor"), tags = c("flowers, London", "flowers", 
#                                                                                                                                                 "plant", "plant, London", "flowers", "london")), row.names = c(NA, 
#-6L), class = "data.frame")

ui <- fluidPage(
  titlePanel("Real time plant observations in London"),
  navbarPage("", 
             tabPanel("Map",
                      sidebarPanel(
                        dateRangeInput('dateRange',
                                       label = 'Date Range'),
                        selectInput("Flickr", "Select Tag", c("flower","tree","plant")),
                        actionButton("photo", "Run photo search"),
                        br(),
                        br(),
                        actionButton("plantnet", "Run Plantnet"),
                        actionButton("plot_map", "Plot map")
                      ),
                      mainPanel(
                        leafletOutput("mymap") # leaflet map goes here in ui
                      )),
             tabPanel("Flickr parameters",
                      mainPanel(
                        strong(tableOutput("complete"))
                      )
             )
  )
)

server <- function(input,output,session) {
  
  observeEvent(input$photo, {
    photo_meta <- photo_search(mindate_taken = "2019-07-01",
                               maxdate_taken = "2019-08-01",
                               tags = c("tree, plant, flower"),
                               tags_any = FALSE,
                               bbox = "-0.312836,51.439050,-0.005219,51.590237")
    
    urls <- data.frame(photo_meta)
    output$complete <- renderTable(photo_meta)
    
  })
  
  observeEvent(input$plantnet, {
    # code for plantnet goes here
  })
  
  observeEvent(input$plot_map, {
    
    output$mymap <- renderLeaflet({
      map = leaflet() %>% addTiles() %>% setView(-0.096024, 51.531786,  zoom = 10) %>% addMarkers(data = photo_meta, lng = photo_meta$longitude, lat = photo_meta$latitude, popup = paste0(photo_meta$tags, "<p><img src = ", photo_meta$URLS, " height='200px%'>"))
      
    })
    
  })
}

shinyApp(ui = ui, server = server)
