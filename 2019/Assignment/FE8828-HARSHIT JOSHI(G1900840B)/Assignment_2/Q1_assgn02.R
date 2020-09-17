count_bizday<-function(year)
{
  if((year%%4==0&&year%%100!=0)||year%%400==0)
  {
    days<-366
  }
  else
  {
    days<-365
  }
  
  n<-TRUE
  no_of_days<-0
  for(mon in c(1:12))
  {
    
    if(mon==1||mon==3||mon==5||mon==7||mon==8||mon==10||mon==12)
    {
      for(d in c(1:31))
      {
        fin<-weekdays(as.Date(paste0(year,"-",mon,"-",d)))
        if(fin!="Saturday" && fin!="Sunday")
        {
          no_of_days<-no_of_days+1
          #print(paste0(year,"-",mon,"-",d))
        }
        
      }
      mon<-mon+1
    }
    else if(mon==2&&days==366)
    {
      for(d in c(1:29))
      {
        fin<-weekdays(as.Date(paste0(year,"-",mon,"-",d)))
        if(fin!="Saturday" && fin!="Sunday")
        {
          no_of_days<-no_of_days+1
          #print(paste0(year,"-",mon,"-",d))
        }
      }
      mon<-mon+1
    }
    else if(mon==2&&days==365)
    {
      for(d in c(1:28))
      {
        fin<-weekdays(as.Date(paste0(year,"-",mon,"-",d)))
        if(fin!="Saturday" && fin!="Sunday")
        {
          no_of_days<-no_of_days+1
          #print(paste0(year,"-",mon,"-",d))
        }
      }
      mon<-mon+1
    }
    else
    {
      for(d in c(1:30))
      {
        fin<-weekdays(as.Date(paste0(year,"-",mon,"-",d)))
        if(fin!="Saturday" && fin!="Sunday")
        {
          no_of_days<-no_of_days+1
          #print(paste0(year,"-",mon,"-",d))
        }
      }
      mon<-mon+1
    }
  }
  print(paste("Total number of business days: ", no_of_days))
}
count_bizday(2018)
