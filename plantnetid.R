# Code to manage the plantnet id's

library(plantnet)

# imageURL <- 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Single_lavendar_flower02.jpg/800px-Single_lavendar_flower02.jpg'
# classifications <- identify(key, imageURL)

# Read csv test file of URL's
url_list <- read.csv("photo_search_intial.csv", stringsAsFactors = FALSE)

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
