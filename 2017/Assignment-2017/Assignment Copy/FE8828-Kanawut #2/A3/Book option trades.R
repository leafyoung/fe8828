# Book option trades
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)

#importdata
data<- read_csv("C:\Users\User\Desktop\Assignment3/assignment3data.csv")

#Count the total number of calls 
option1 <- mutate(data, Valuation=Quantity*OptionPrice)
summarise(dplyr::filter(option1,Type=="Call"), TotalCallValue=sum(Valuation))

#count the total number of puts
summarise(dplyr::filter(option1,Type=="Put"), TotalPutValue=sum(Valuation))

#count the total number of calls and puts
summarise(option1, TotalValuation=sum(Valuation))

#Find in the money option
mutate(data, Payoff=ifelse(StockPrice>Strike, StockPrice-Strike,0)) %>%
  dplyr::filter(.,Payoff>=0) %>%
  nrow(.)

#Volatility calculation
mutate(data, Time=as.numeric(as.Date(ExpiryDate, format="%d-%b-%y")-as.Date(ExtractionDate, format="%d-%b-%y"))/365) %>% 
  mutate(., type=ifelse(Type=="Call","c","p")) %>% 
  select(., OptionPrice, type, StockPrice, Strike, Time) %>% 
  rowwise(.) %>% 
  mutate(., Vol=GBSVolatility(price=OptionPrice, TypeFlag=type, S=StockPrice, X=Strike, Time=Time, r=0.01, b=0, tol=0.005, maxiter=100000)) -> option2 #To create a column of implied vol values

#Plot volatility curve
ggplot(option2) + 
  geom_point(data=dplyr::filter(option2, type=="c"), aes(Strike, Vol), color="red") +
  geom_point(data=dplyr::filter(option2, type=="p"), aes(Strike, Vol), color="blue") 



