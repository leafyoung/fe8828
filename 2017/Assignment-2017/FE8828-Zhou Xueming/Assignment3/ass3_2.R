# Book option trades
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)

#importdata
data <- read_excel("D:/gdrive/MFECourse/FE8828/2017/FE8828-Zhou Xueming/Assignment3/data.xlsx")
# View(data)

#total number of calls
option1 <- mutate(data, Valuation=Quantity*OptionPrice)
summarise(dplyr::filter(option1,Type=="Call"), TotalCallValue=sum(Valuation))


#total number of puts
summarise(dplyr::filter(option1,Type=="Put"), TotalPutValue=sum(Valuation))


#total number of calls and puts
summarise(option1, TotalValuation=sum(Valuation))


#option in the money
mutate(data, Payoff=ifelse(StockPrice>Strike, StockPrice-Strike,0)) %>%
  dplyr::filter(.,Payoff>=0) %>%
  nrow(.)


#Volatility curve
mutate(data, Time=as.numeric(as.Date(ExpiryDate, format="%d-%b-%y")-as.Date(ExtractionDate, format="%d-%b-%y"))/365) %>% 
  mutate(., type=ifelse(Type=="Call","c","p")) %>% 
  select(., OptionPrice, type, StockPrice, Strike, Time) %>% 
  rowwise(.) %>% 
  mutate(., Vol=GBSVolatility(price=OptionPrice, TypeFlag=type, S=StockPrice, X=Strike, Time=Time, r=0.01, b=0, tol=0.005, maxiter=100000)) -> option2 #To create a column of implied vol values


#Plot volatility curve
ggplot(option2) + 
  geom_point(data=dplyr::filter(option2, type=="c"), aes(Strike, Vol), color="black") +
  geom_point(data=dplyr::filter(option2, type=="p"), aes(Strike, Vol), color="blue") 



