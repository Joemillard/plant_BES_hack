#basic example
library(devtools)
devtools::install_github("nfox29/photosearcher")
library(photosearcher)


photo_meta <- photosearcher::photo_search(mindate_taken = "2019-07-01",
                                          maxdate_taken = "2019-08-01",
                                          tags = c("tree, plant, flower"),
                                          tags_any = FALSE,
                                          bbox = "-0.312836,51.439050,-0.005219,51.590237")

urls <- data.frame(photo_meta$url_l)

write.csv(photo_meta, "photo_search_intial.csv")