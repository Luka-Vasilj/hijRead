
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
#> No encoding supplied: defaulting to UTF-8.
#> [1] "07-05-1443"
hijday(x)
#> No encoding supplied: defaulting to UTF-8.
#> [1] "Al Ahad"
hijmonth(x)
#> No encoding supplied: defaulting to UTF-8.
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
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
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
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.
#> No encoding supplied: defaulting to UTF-8.

ds %>%
  select(dated, hijri) %>%
  head(10)
#> # A tibble: 10 x 2
#> # Rowwise: 
#>    dated      hijri     
#>    <chr>      <chr>     
#>  1 03-01-1819 06-03-1234
#>  2 18-08-1978 14-09-1398
#>  3 07-12-0879 18-04-266 
#>  4 27-09-0633 17-07-12  
#>  5 08-12-0811 18-03-196 
#>  6 28-04-1067 10-06-459 
#>  7 12-03-1740 13-12-1152
#>  8 19-03-1397 18-06-799 
#>  9 12-09-0770 16-09-153 
#> 10 08-04-1345 04-12-745
```

The potential use cases extend to more easily tracking and visualizing
consumption, crime, and donation patterns in the Muslim world with
reference to the Islamic calendar. Due to the nature of the Islamic
calendar - it being a lunar calendar - the timing of certain events
takes place at differing times every year according to the Gregorian
calendar. For example, donations and food purchases increase drastically
during the holy month of Ramadan, a multi-year pattern more easily
identifiable if mapped against Islamic months, rather than Gregorian.
