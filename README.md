
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hijread

<!-- badges: start -->
<!-- badges: end -->

The goal of hijread is to facilitate the conversion from dates in the
standard Gregorian calendar to Islamic dates following the Hijri
calendar. The package’s functions tap into the API of
<https://aladhan.com/islamic-calendar-api> in order to carry out the
conversion.

## Installation

You can install the development version of hijread from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Luka-Vasilj/hijread")
```

## Example

Below, we show the code required to convert a Gregorian date to a Hijri
date, as well as obtaining the names of the day of the week and Hijri
month in Arabic. Note that dates passed to the functions must be strings
in the dd-mm-yyyy format:

``` r
library(hijread)

x <- "12-12-2021"
hijdate(x)
#> [1] "07-05-1443"
hijday(x)
#> [1] "Al Ahad"
hijmonth(x)
#> [1] "Jumadá al-ulá"
```

The above functions can also be passed to the dplyr `mutate()` function
in order to convert an entire set of dates, however, this must be
mediated by the `rowwise()` function. Below, we create a dataset with
randomized dates from the beginning of the Islamic calendar until the
end of 2021. Then, we use the `mutate()` function to create a new column
containing the corresponding Hijri dates.

``` r
library(dplyr)
library(stringi)

#creating randomized dates
a <- as.character(sample(1:30, 20, replace = T))
b <- as.character(sample(1:12, 20, replace = T))
c <- as.character(sample(623:2021, 20, replace = T))

#making date format uniform
ds <- as.data.frame(cbind(a, b, c)) %>%
  mutate(a = ifelse(stri_length(a) < 2, paste0("0", a), a),
         b = ifelse(stri_length(b) < 2, paste0("0", b), b),
         c = ifelse(stri_length(c) < 2, paste0("000", c), 
                    ifelse(stri_length(c) < 3, paste0("00", c),
                           ifelse(stri_length(c) < 4, paste0("0", c), c))))
ds$dated <- as.character(paste(ds$a, ds$b, ds$c, sep = "-"))


#attempting to use function on dataset
ds <- ds %>%
  rowwise() %>%
  mutate(hijri = hijdate(dated))

ds %>%
  select(dated, hijri) %>%
  head(10)
#> # A tibble: 10 x 2
#> # Rowwise: 
#>    dated      hijri     
#>    <chr>      <chr>     
#>  1 21-07-1463 04-11-867 
#>  2 20-02-1362 24-04-763 
#>  3 02-09-1894 01-03-1312
#>  4 07-08-1346 17-04-747 
#>  5 27-05-1859 24-10-1275
#>  6 08-12-1762 21-05-1176
#>  7 08-11-0703 23-10-84  
#>  8 29-06-0885 12-01-272 
#>  9 16-01-0998 14-01-388 
#> 10 08-04-1054 26-12-445
```

The potential use cases extend to more easily tracking and visualizing
consumption, crime, and donation patterns in the Muslim world with
reference to the Islamic calendar. Due to the nature of the Islamic
calendar - it being a lunar calendar - the timing of certain events
takes place at differing times every year according to the Gregorian
calendar. For example, donations and food purchases increase drastically
during the holy month of Ramadan, a multi-year pattern more easily
identifiable if mapped against Islamic months, rather than Gregorian.
