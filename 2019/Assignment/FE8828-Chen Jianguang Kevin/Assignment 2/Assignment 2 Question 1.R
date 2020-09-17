library(lubridate)

weekdays(as.Date("2019-09-26"))


count_bizdays <- function (year) {
  if ((year %% 400 == 0) | (year %% 4 == 0 & year %% 100 != 0)) { 
    if (weekdays(as.Date(paste0(year, "-01-01"))) == "Saturday")
      return (366-106)
    else if (weekdays(as.Date(paste0(year, "-01-01"))) == "Friday" | weekdays(as.Date(paste0(year, "-01-01"))) == "Sunday")
      return (366-105)
    else
      return (366-104)
  } else {
    if (weekdays(as.Date(paste0(year, "-01-01"))) == "Saturday" | weekdays(as.Date(paste0(year, "-01-01"))) == "Sunday")
      return (365-105)
    else
      return (365-104) 
  }
}

