library(lubridate)

is_leap_year <- function(yr) {
  if ((yr %% 400 == 0) | (yr %% 4 == 0 & yr %% 100 != 0)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

count_bizdays <- function(year) {
  
  weekday_first_jan <- wday(paste0(year,"-01-01"))
  num_of_business_days <- 52*5
  # if 1st Jan is Monday, Tuesday, Wednesday, Thursday or Friday, we need to add 1 extra day to the count
  if (weekday_first_jan %in% c(2,3,4,5,6))
  {
    num_of_business_days <- num_of_business_days + 1
  }
  # if the given year happens to be leap year and 1st Jan hppens to be
  # either Sunday, Monday, Tuesday, Wednesday or Thursday then last day of year will end in a weekday
  # and second last day of year will end on weekday equal to 1st Jan of that year
  if (is_leap_year(year))
  {
    if (weekday_first_jan %in% c(1,2,3,4,5))
    {
      num_of_business_days <- num_of_business_days + 1
    }
  }
  cat(num_of_business_days)
}

count_bizdays(2000)
count_bizdays(2005)
count_bizdays(2019)
