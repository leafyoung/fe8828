library(fOptions)
library(tidyverse)
library(lubridate)
library(bizdays)
library(ggplot2)
library(ggthemes)
library(tidyr)
library(readxl)

# Assignment 1
#1.1
call <- read_excel("C:/Users/Nuozh/Desktop/option.xlsx", 
                   sheet = "Sheet1", col_types = c("text", 
                                                   "text", "numeric", "numeric", "numeric", 
                                                   "numeric", "numeric", "numeric", 
                                                   "numeric", "numeric", "numeric"))

put <- read_excel("C:/Users/Nuozh/Desktop/option.xlsx", 
                  sheet = "Sheet2", col_types = c("text", 
                                                  "text", "numeric", "numeric", "numeric", 
                                                  "numeric", "numeric", "numeric", 
                                                  "numeric", "numeric", "numeric"))

Book1<-mutate(call,Call_Put="Call",Expiry=as.Date("2019-12-20"),Underlying=174.91,Value=`Open Interest`*(Bid+Ask)/2) 
Book2<-mutate(put,Call_Put="Put",Expiry=as.Date("2019-12-20"),Underlying=174.91,Value=`Open Interest`*(Bid+Ask)/2) 
Book<-bind_rows(Book1,Book2)
Book<-mutate(Book,Value=`Open Interest`*(Bid+Ask)/2)
Option<-select(Book,'Contract Name',Strike,`Open Interest`,Underlying,Call_Put,Bid,Ask)
View(Option)

#1.2
TotalCallValue<-sum(Book1$Value[!is.na(Book1$Value)])
TotalPutValue<-sum(Book2$Value)
TotalValue<-TotalCallValue+TotalPutValue 

#1.3
Call_ITM<-filter(Book1,Underlying>Strike)
View(Call_ITM)
Put_ITM<-filter(Book2,Underlying<Strike)
TotalOpenInterest<-sum(Call_ITM$`Open Interest`)+sum(Put_ITM$`Open Interest`)

#1.4
Call_OTM<-filter(Book1,Underlying<Strike)
Put_OTM<-filter(Book2,Underlying>Strike)
OptionOTM<-rbind(Call_OTM,Put_OTM)

ggplot(OptionOTM,aes(x=OptionOTM$Strike,y = OptionOTM$`Implied Volatility`))+
  geom_point()+
  geom_smooth()

