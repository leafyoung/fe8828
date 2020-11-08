library(readxl)
library(tibble)
library(dplyr)
library(conflicted)
library(tidyverse)
conflict_prefer("lag", "dplyr")
conflict_prefer("filter", "dplyr")

#2.1
originaldata <- read_excel("C:/Users/win10/Desktop/NTU/NTU MFE/mini term 2/programming web applications in finance/assignment3/originaldata.xlsx",
col_types = c("date", "text", "text",
"numeric", "numeric", "text", "text",
"numeric", "numeric", "text", "numeric",
"numeric", "text", "numeric"))
#View(originaldata)

Calls<-originaldata[,c(1,8,7)]
bid<-originaldata$Bid...4
ask<-originaldata$Ask...5
Calls<-mutate(Calls, OptionType = "c")
Calls
#View(Calls)
Calls<-mutate(Calls, Bid=bid, Ask=ask)
colnames(Calls)[1] <- 'Exp. Date'
colnames(Calls)[2] <- 'Strike'
colnames(Calls)[3] <- 'Open Int.'
Calls$`Open Int.`<-as.numeric(Calls$`Open Int.`)
unl<-rep(1464.00,nrow(Calls))
unl
Calls<-mutate(Calls,Underlying=unl,Today=as.Date("2020-10-08","%Y-%m-%d"))
Calls

Puts <- originaldata[,c(1,8,14)]
bid2<-originaldata$Bid...11
ask2<-originaldata$Ask...12
Puts <- mutate(Puts, OptionType = "p")
Puts<-mutate(Puts,Bid=bid2,Ask=ask2)
colnames(Puts)[1] <- 'Exp. Date'
colnames(Puts)[2] <- 'Strike'
colnames(Puts)[3] <- 'Open Int.'
unl2<-rep(1464.00,nrow(Puts))
unl2
Puts<-mutate(Puts,Underlying=unl2,Today=as.Date("2020-10-08","%Y-%m-%d"))
Puts
option <- bind_rows(Calls, Puts)
View(option)

#2.2
total_valuation_call<-rep(0,nrow(Calls))
for(i in 1:nrow(Calls)){
  total_valuation_call[i]<-(Calls$`Open Int.`[i])*(bid[i]+ask[i])/2
}
total_valuation_call

total_valuation_put<-rep(0,nrow(Puts))
for(i in 1:nrow(Puts)){
  total_valuation_put[i]<-(Puts$`Open Int.`[i])*(bid2[i]+ask2[i])/2
}
total_valuation_put

total_valuation_callput<-rep(0,nrow(option))
for(i in 1:nrow(option)){
  total_valuation_callput[i]<-(option$`Open Int.`[i])*(option$Bid[i]+option$Ask[i])/2
}
total_valuation_callput

#2.3
call_in_money<-group_by(Calls) %>% filter(Calls$Strike < Calls$Underlying)
call_in_money
total_open_interest_call<-0
for(i in 1:nrow(call_in_money)){
  if(is.na(call_in_money$`Open Int.`[i])==FALSE){
    total_open_interest_call<-total_open_interest_call+call_in_money$`Open Int.`[i]
  }
}
total_open_interest_call

put_in_money<-group_by(Puts) %>% filter(Puts$Strike > Puts$Underlying)
put_in_money
total_open_interest_put<-0
for(i in 1:nrow(put_in_money)){
  if(is.na(put_in_money$`Open Int.`[i])==FALSE){
    total_open_interest_put<-total_open_interest_put+put_in_money$`Open Int.`[i]
  }
}
total_open_interest_put


#2.4
library(fOptions)
call_in_curve<-group_by(Calls) %>% filter(Calls$Strike > Calls$Underlying)
call_in_curve
put_in_curve<-group_by(Puts) %>% filter(Puts$Strike < Puts$Underlying)
put_in_curve
whole<-bind_rows(call_in_curve,put_in_curve)
whole
whole$Strike
price<-rep(0,nrow(whole))
for(i in 1:nrow(whole)){
  price[i]<-(whole$Bid[i]+whole$Ask[i])/2
}
price
whole<-mutate(whole,price)
whole<-whole %>% rowwise() %>% mutate(volatility = GBSVolatility(price=price, OptionType, Underlying, Strike,
                                                          as.numeric((as.Date("2020-12-18") - as.Date("2020-10-08")))/365,
                                                          r = 0.03, b = 0)) %>% ungroup()

View(whole)
plot(whole$Strike,whole$volatility)

