library(tidyverse)

setwd("D:\\gdrive\\MFECourse\\FE8828\\2017\\FE8828-LEEKwanghyuk\\Assignment3")

#Import data
call <- read.csv("Call.csv", header=T, stringsAsFactors=F)
put <- read.csv("Put.csv", header=T, stringsAsFactors=F)
call <- as.data.frame(data.matrix(call))
put <- as.data.frame(data.matrix(put))

date1 <- as.Date("2018-01-19")
date2 <- as.Date("2017-11-22")

#Insert Date, Long_Short, Call_Put
call <- mutate(call, Call_Put="Call", ExpiryDate = date1, ExtractionDate = date2, Long_Short = "long")
call <- select(call, ExpiryDate,ExtractionDate, Strike, Quantity = Open.Int, Underlying = Price, Long_Short, Call_Put, everything())
put <- mutate(put, Call_Put="Put", ExpiryDate = date1, ExtractionDate = date2, Long_Short = "long")
put <- select(put, ExpiryDate,ExtractionDate, Strike, Quantity = Open.Int, Underlying = Price, Long_Short, Call_Put, everything())

#Combine call and put
option <- rbind(call, put)

#insert StockPrice
StockPrice = cbind(rep(1156.16, nrow(option)))
option <- cbind(option, StockPrice)

#Valuation
option1 <- mutate(option, Valuation=Quantity*(Bid+Ask)/2)

summarise(dplyr::filter(option1,Call_Put=="Call"), TotalCallValue=sum(na.omit(Valuation)))
summarise(dplyr::filter(option1,Call_Put=="Put"), TotalPutValue=sum(na.omit(Valuation)))
summarise(option1, TotalValuation=sum(na.omit(Valuation)))

#Number of in-the-money options
mutate(option, Payoff=ifelse(StockPrice>Strike, StockPrice-Strike,0)) %>%
  dplyr::filter(.,Payoff>=0) %>%
  nrow(.)

#Volatility calculation
library(lubridate)
library(fOptions)

option2 <- mutate(option, Time=as.numeric(as.Date(ExpiryDate, format="%d-%b-%y")-as.Date(ExtractionDate, format="%d-%b-%y"))/365) %>%
  mutate(., Price = (Bid+Ask)/2, type=ifelse(Call_Put=="Call","c","p")) %>%
  select(., Price, type, StockPrice, Strike, Time) %>%
  na.omit(.) %>%
  rowwise(.) %>%
  mutate(., Vol=GBSVolatility(price=Price, TypeFlag=type, S=StockPrice, X=Strike, Time=Time, r=0.01, b=0, tol=0.005, maxiter=100000))


#Volatility curve : strike vs. col
ggplot(option2) + 
  geom_point(data=dplyr::filter(option2, type=="c"), aes(Strike, Vol), color="red") +
  geom_point(data=dplyr::filter(option2, type=="p"), aes(Strike, Vol), color="blue") 
  


