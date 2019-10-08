library(devtools)
devtools::install_github("nfox29/photosearcher")
library(sf)
library(photosearcher)

boundaries <- sf::st_read(".\\shape\\National_Parks_England.shp")

photo_meta <- photosearcher::photo_search(mindate_taken = "2018-12-25",
                                        tags = c("tree"),
                                        tags_any = FALSE,
                                        bbox = "-0.312836, 51.439050,-0.005219,51,590237")

devtools::install_github(repo = 'BiologicalRecordsCentre/plantnet')
library(plantnet)
