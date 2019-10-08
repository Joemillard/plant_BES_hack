#basic example
library(devtools)
devtools::install_github("nfox29/photosearcher")
library(photosearcher)


photo_meta <- photosearcher::photo_search(mindate_taken = "2018-12-25", 
                                          tags = c("tree"),
                                          tags_any = FALSE,
                                          bbox = "-0.312836,51.439050,-0.005219,51.590237")
urls <- data.frame(photo_meta$url_o)
