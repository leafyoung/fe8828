count_bizdays <- function(year) 
{
  # YY
  # return(sum(seq(as.Date("year-01-01",format = "%Y-%m-%d"), 
  #      as.Date("year-12-31",format = "%Y-%m-%d"), by="day") - 
  #       c("Saturday", "Sunday")))
  days <- weekdays(seq(as.Date(paste0(year, "-01-01"), format = "%Y-%m-%d"), 
                       as.Date(paste0(year, "-12-31"), format = "%Y-%m-%d"), by="day"))
  return(sum(days != "Saturday" & days != "Sunday"))
}

