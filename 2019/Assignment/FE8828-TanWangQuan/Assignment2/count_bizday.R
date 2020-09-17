count_bizday <- function(year) {
  
  startDate= as.Date(paste0(year,"-01-01"))
  endDate= as.Date(paste0(year,"-12-31"))
  
  date_range=seq.Date(startDate,endDate,1)
  
  #convert the sequence into a list of T or False. T if weekdays
  weekdayOrWeekend=!weekdays(date_range) %in% c("Saturday","Sunday")
  # YY: no need to - 1
  length(which(weekdayOrWeekend, TRUE))
}

count_bizday(2005)
count_bizday(2001)

