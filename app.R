library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Plantnet mapper"),
  navbarPage("", 
             tabPanel("Map",
                      sidebarPanel(
                        selectInput("Flickr", "Enter flickr terms", c("plant", "plants")),
                        actionButton("photo", "Run photo search"),
                        br(),
                        br(),
                        actionButton("plantnet", "Run Plantnet")
                      ),
                      mainPanel(
                        leafletOutput("mymap") # leaflet map goes here in ui
                        
                      )),
             tabPanel("Flickr parameters",
                      mainPanel(
                        # flickr table of parameters goes here
                      )
             )
  )
)

server <- function(input,output,session) {
  
  observeEvent(input$photo, {
    # code for photosearch goes here, either taking input from Flickr input or in the server script
  })
  
  observeEvent(input$plantnet, {
    # code for plantnet goes here
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>% # code for leaflet goes here
      addTiles()
  })
}

shinyApp(ui = ui, server = server)
