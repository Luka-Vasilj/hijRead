hijdate <- function(x){
  query = list(date = x)
  retrieved_data <- httr::GET("http://api.aladhan.com/v1/gToH", query = query)
  Sys.sleep(runif(1, 0, 1))
  cont <- httr::content(retrieved_data, as = "text")
  date1 <- jsonlite::fromJSON(cont)
  date1$data$hijri$date
}
