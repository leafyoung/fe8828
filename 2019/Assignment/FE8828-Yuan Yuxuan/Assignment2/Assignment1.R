# Question: count_bizday <- function(year){} with only basic function

library(lubridate)

count_bizday <- function(year){
  first_date = paste0(year, "-01-01")
  first_dt = as.Date(first_date)
  first_wday = wday(first_dt)
  last_date = paste0(year, "-12-31")
  last_dt = as.Date(last_date)
  last_wday = wday(last_dt)
  
  firmed_week_days = round(365/7, 0)*5
  
  if(first_wday==last_wday){
    if(first_wday %in% c(1,7)){
      firmed_week_days
    }else{
      firmed_week_days+1
    }
  }else{
    if(all(c(first_wday, last_wday) %in% c(1,7))){
      firmed_week_days
    }else if(any(c(first_wday, last_wday) %in% c(1,7))){
      firmed_week_days+1
    }else{
      firmed_week_days+2
    }
  }
}
