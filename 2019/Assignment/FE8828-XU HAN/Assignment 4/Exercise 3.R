library(tidyverse)
library("RQuantLib")
library("fOptions")
library(dplyr)

option <- read.csv("/Users/xuhan/Desktop/Goog.option.csv")
option <- read.csv("E:/gdrive/MFECourse/FE8828/2019/FE8828-XU HAN/Assignment 4/Goog.option.csv")

#1.1
df=data.frame('Expiry Date'=as.Date("2019-12-20"),Strike=option$Strike,
              'Open Interest'=option$Open.Interest,Underlying=option$Last.Price,
              'Call/Put'=option$Call.Put,Bid=option$Bid,Ask=option$Ask)

#1.2
df["valuation"]=0
for(i in 1:length(df$Expiry.Date))
{
  df$valuation[i]=df$Open.Interest[i] * (df$Bid[i]+df$Ask[i]) / 2
}

Total.value_call=0
Total.value_put=0

for(i in 1:length(df$Expiry.Date))
{
  if(df$Call.Put[i]=='Call')
    Total.value_call=Total.value_call+df$valuation[i]
  if(df$Call.Put[i]=='Put')
    Total.value_put=Total.value_put+df$valuation[i]
}

Total.value_call
Total.value_put

Total.value=Total.value_put+Total.value_call
Total.value

#1.3
#The stock price is 1,215.45
total_Open_Interest=0

for(i in 1:length(df$Expiry.Date))
{
  if(df$Call.Put[i]=='Call')
  {
    if(df$Strike[i]<1215.45)
    {
      total_Open_Interest=total_Open_Interest+df$Open.Interest[i]
    }
  }
  if(df$Call.Put[i]=='Put')
  {
    if(df$Strike[i]>1215.45)
    {
      total_Open_Interest=total_Open_Interest+df$Open.Interest[i]
    }
  }
}

total_Open_Interest

#1.4
# GBSVolatility(price, TypeFlag, S, X, Time, r, b, tol, maxiter) 
# Use Price to back-out implied volatility. Assume r = 0.03
put.data=arrange(df,Strike) %>% dplyr::filter(Call.Put=="Put") %>% 
  dplyr::filter(Strike < 1215.45)
call.data=arrange(df,Strike) %>% dplyr::filter(Call.Put=="Call") %>% 
  dplyr::filter(Strike > 1215.45)

put.Strikes<- put.data$Strike
put.price<- put.data$Underlying

call.Strikes<- call.data$Strike
call.price<- call.data$Underlying

Strikes<- rep(0,length(put.Strikes)+length(call.Strikes))

for(i in 1:length(put.Strikes))
{
  Strikes[i]=put.Strikes[i]
}

for(i in 1:length(call.Strikes))
{
  Strikes[i+length(put.Strikes)]=call.Strikes[i]
}

volSmile<- rep(0,length(put.Strikes)+length(call.Strikes))

for(i in 1:length(put.Strikes)) {
  impVol<-GBSVolatility(price=put.price[i],TypeFlag = "p", 
                        S = 1215.45, 
                        X = put.Strikes[i], 
                        as.numeric((as.Date("2019-12-20") -as.Date("2019-10-13")))/365, 
                        r = 0.03, b = 0)
  volSmile[i]<- impVol
}

for(i in 1:length(call.Strikes)) {
  impVol<-GBSVolatility(price=call.price[i] , TypeFlag = "c", 
                        S = 1215.45, 
                        X = call.Strikes[i], 
                        as.numeric((as.Date("2019-12-20") -as.Date("2019-10-13")))/365, 
                        r = 0.03, b = 0)
  volSmile[i+length(put.Strikes)]<- impVol
}


plot(x = Strikes, y = volSmile,type="b",xlab="Strike",ylab="volatility")