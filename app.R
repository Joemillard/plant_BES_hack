library(shiny)
library(leaflet)

##

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
