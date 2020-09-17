#holiday <- c("2018-09-17","2018-10-12","2018-12-31") # Holiday vector storing holidays
bizday_count <- function(year)
{
  start1 <- as.Date(paste0(year,"-01-01"))
  end1 <- as.Date(paste0(year,"-12-31"))
  tmp <- start1
  count <- 0
  while(tmp<=end1)
  {
    if((weekdays(tmp)!="Sunday")&&(weekdays(tmp)!="Saturday")) #&&(!tmp %in% as.Date(holiday)))
    {
      count <- count + 1
      #print(as.Date(tmp, format = "%Y-%m-%d"))
    }
    tmp <- tmp+1
  }
  return(count)
}

#Driver Code
cat(paste0("No. of Business days in 2019 are ",bizday_count(2019),".\n"))
cat(paste0("No. of Business days in 2018 are ",bizday_count(2018),".\n"))
