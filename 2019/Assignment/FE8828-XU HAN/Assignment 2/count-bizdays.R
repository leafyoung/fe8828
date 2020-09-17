library(lubridate)
count_bizday <- function(year){
  count=0
  for(i in 1:12)
  {
    start=as.Date(paste0(year,"-", i, "-01"))
    end=as.Date(paste0(year,"-",i, "-01"))
    day(end)=days_in_month(start)
    date=seq(start,end,by="days")
    for(u in 1:length(date))
    {
      t=(12-month(date[u])) %/% 10
      y=year(date[u])-t
      m=month(date[u])+12*t
      c=y %/% 100
      Y=y %% 100
      w=(day(date[u])+Y+Y %/% 4+c %/% 4+5*c+((26*(m+1)) %/% 10)) %% 7
      if((w!=0)&(w!=1))   #w=0 means Saturday and w=1 means Sunday
      {
        count=count+1
      }
    }
  }
  cat("the bizday in",year,"is",count)
}

count_bizday(2019)
