count_bizday <- function(year) {
  count <- 261
  if (weekdays(as.Date(paste0(year, "-01-01")))=="Saturday" | 
      weekdays(as.Date(paste0(year, "-01-01")))=="Sunday") {
    count <- count - 1}
  
  if ((year%%4==0 & year%%100!=0) | year%%400==0) {
    if (weekdays(as.Date(paste0(year, "-12-31")))!="Saturday" & 
        weekdays(as.Date(paste0(year, "-12-31")))!="Sunday") {
      count <- count+1}
  }
  cat(paste0(count))
}

count_bizday(2000)
count_bizday(2005)
count_bizday(2019)
