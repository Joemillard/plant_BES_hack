library(shiny)
library(leaflet)
library(photosearcher)
library(plantnet)

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
                        actionButton("plot_map", "Plot map")
                      ),
                      mainPanel(
                        leafletOutput("mymap", height = "100%") # leaflet map goes here in ui
                      )),
             tabPanel("Flickr parameters",
                      mainPanel(
                        strong(tableOutput("complete"))
                      )),
             tabPanel("Plantnet parameters",
                      mainPanel(
                        strong(tableOutput("complete_plants"))
                      )
             )
  )
)

server <- function(input,output,session) {
  
  photo_meta <- reactiveValues(DAT=NULL)
  
  observeEvent(input$photo, {
    
    photo_meta$DAT <- photo_search(mindate_taken = "2019-07-05",
                               maxdate_taken = "2019-07-18",
                               tags = c("tree, plant, flower"),
                               tags_any = FALSE,
                               bbox = "-0.312836,51.439050,-0.005219,51.590237")
    
    urls <- data.frame(photo_meta$DAT)
    
    output$complete <- renderTable(photo_meta$DAT)
    
  })
  
  observeEvent(input$plot_map, {
    
    key <- "2a10egBxTG839st87lMrBoWQ"
    
    # imageURL <- 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Single_lavendar_flower02.jpg/800px-Single_lavendar_flower02.jpg'
    # classifications <- identify(key, imageURL)
    
    # Read csv test file of URL's
    #url_list <- read.csv("photo_search_intial.csv", stringsAsFactors = FALSE)
    
    url_list <- photo_meta$DAT
    
    ids_urls <- url_list[, c("id", "latitude", "longitude", "datetaken", "url_l")]
    no_of_urls <- nrow(ids_urls)
    
    # Need to fix datetaken which comes in as a factor
    
    top_output <- data.frame(matrix(NA, nrow=1, ncol=11))
    colnames(top_output) <- c("id", "latitude", "longitude", "datetaken", "url_l", "prob1", "cname1", "prob2", "cname2", "prob3", "cname3")
    loop_output <- top_output
    
    for(i in 1:no_of_urls){
      this_url <- data.frame(identify(key, as.character(ids_urls$url_l[i])))
      loop_output[1, "id"] <- ids_urls[i, 1]
      loop_output[1, "latitude"] <- ids_urls[i, 2]
      loop_output[1, "longitude"] <- ids_urls[i, 3]
      loop_output[1, "datetaken"] <- ids_urls[i, 4]
      loop_output[1, "url_l"] <- ids_urls[i, 5]
      if(nrow(this_url) == 1){
        loop_output[1, "prob1"] <- NA
        loop_output[1, "cname1"] <- NA
      }else if(nrow(this_url) == 2){
        loop_output[1, "prob1"] <- unlist(this_url[1, 1]) # score top
        loop_output[1, "cname1"] <- unlist(this_url[1, 3]) # common name top
        loop_output[1, "prob2"] <- unlist(this_url[2, 1]) # 2nd score
        loop_output[1, "cname2"] <- unlist(this_url[2, 3]) # 2nd name
      } else if(nrow(this_url) >= 3){
        loop_output[1, "prob1"] <- unlist(this_url[1, 1]) # score top
        loop_output[1, "cname1"] <- unlist(this_url[1, 3]) # common name top
        loop_output[1, "prob2"] <- unlist(this_url[2, 1]) # 2nd score
        loop_output[1, "cname2"] <- unlist(this_url[2, 3]) # 2nd name
        loop_output[1, "prob3"] <- unlist(this_url[3, 1]) # 3rd score
        loop_output[1, "cname3"] <- unlist(this_url[3, 3]) # 3rd name
      }
      top_output <- rbind(top_output, loop_output)
      loop_output <- data.frame(matrix(NA, nrow=1, ncol=11))
      colnames(loop_output) <- c("id", "latitude", "longitude", "datetaken", "url_l", "prob1", "cname1", "prob2", "cname2", "prob3", "cname3")
    }
    top_output <- top_output[-1,]
    rownames(top_output) <- 1:no_of_urls
    
    photo_meta$DAT <- cbind(photo_meta$DAT, top_output$cname1)
    colnames(photo_meta$DAT)[ncol(photo_meta$DAT)] <- "cname1"
    
    output$complete_plants <- renderTable(photo_meta$DAT)
    
    
    output$mymap <- renderLeaflet({
      map = leaflet() %>% addTiles() %>% setView(-0.096024, 51.531786,  zoom = 10) %>% addMarkers(data = photo_meta$DAT, lng = photo_meta$DAT$longitude, lat = photo_meta$DAT$latitude, popup = paste0(photo_meta$DAT$cname1, "<p>", photo_meta$DAT$tags, "<p><img src = ", photo_meta$DAT$url_l, " height='200px%'>"))
      
    })
    
  })
}

shinyApp(ui = ui, server = server)
