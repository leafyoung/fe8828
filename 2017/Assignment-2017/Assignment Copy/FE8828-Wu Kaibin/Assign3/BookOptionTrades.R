library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)   #Book option trades

data<- read_csv("D:\Assign3\assign3data.csv")

option1 <- mutate(data, Valuation=Quantity*OptionPrice)
summarise(dplyr::filter(option1,Type=="Call"), TotalCallValue=sum(Valuation))   #Calculate the number of calls

summarise(dplyr::filter(option1,Type=="Put"), TotalPutValue=sum(Valuation))   #Calculate the number of puts

summarise(option1, TotalValuation=sum(Valuation))   #Calculate the number of calls and puts

mutate(data, Payoff=ifelse(StockPrice>Strike, StockPrice-Strike,0)) %>%
  dplyr::filter(.,Payoff>=0) %>%
  nrow(.)

mutate(data, Time=as.numeric(as.Date(ExpiryDate, format="%d-%b-%y")-as.Date(ExtractionDate, format="%d-%b-%y"))/365) %>% 
  mutate(., type=ifelse(Type=="Call","c","p")) %>% 
  select(., OptionPrice, type, StockPrice, Strike, Time) %>% 
  rowwise(.) %>% 
  mutate(., Vol=GBSVolatility(price=OptionPrice, TypeFlag=type, S=StockPrice, X=Strike, Time=Time, r=0.01, b=0, tol=0.005, maxiter=100000)) -> option2 #To create a column of implied vol values

ggplot(option2) + 
  geom_point(data=dplyr::filter(option2, type=="c"), aes(Strike, Vol), color="red") +
  geom_point(data=dplyr::filter(option2, type=="p"), aes(Strike, Vol), color="blue") 



