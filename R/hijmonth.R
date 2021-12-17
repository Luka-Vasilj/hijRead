#' Get name of Islamic month
#'
#' @param x a date as a string in dd-mm-yyyy format
#'
#' @return Arabic name of the month in the Hijri calendar
#' @export
#'
#' @examples
#' x <- "12-12-2021"
#' hijmonth(x)
hijmonth <- function(x){
  query = list(date = x)
  retrieved_data <- httr::GET("http://api.aladhan.com/v1/gToH", query = query)
  Sys.sleep(stats::runif(1, 0, 1))
  cont <- httr::content(retrieved_data, as = "text")
  date1 <- jsonlite::fromJSON(cont)
  date1$data$hijri$month$en
}
