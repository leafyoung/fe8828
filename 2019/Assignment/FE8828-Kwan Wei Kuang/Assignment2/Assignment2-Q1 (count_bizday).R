#Assignment 2, Q1: count_bizday <- function(year) {  } with only base functions.

#This only remove weekends (i.e. not considering holidays)
count_bizday <- function(year) {
  all_dates <- weekdays(seq(as.Date(paste0(year,"-01-01")), 
                            as.Date(paste0(year,"-12-31")), by ="day"),abbreviate = TRUE)
  length(which("Sat" != all_dates & "Sun" != all_dates))
}

