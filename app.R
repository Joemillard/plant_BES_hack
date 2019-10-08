library(shiny)
library(leaflet)
library(photosearcher)


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
  
  output$mymap <- renderLeaflet({
    leaflet() %>% # code for leaflet goes here
      addTiles()
  })
}

shinyApp(ui = ui, server = server)
