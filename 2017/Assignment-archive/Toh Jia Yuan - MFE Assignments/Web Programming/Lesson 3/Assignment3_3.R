# Assignment 3_3 : Book option trades
library(dplyr)
#1.1
options <- read.csv("D:\\Dropbox\\Docs\\MFE\\FE8828\\2017\\Toh Jia Yuan - MFE Assignments\\Web Programming\\Lesson 3\\Assignment3data.csv", sep=",")

#1.2
option1 <- mutate(options, Valuation=Quantity*OptionPrice)
summarise(dplyr::filter(option1,Type=="Call"), TotalCallValue=sum(Valuation))
summarise(dplyr::filter(option1,Type=="Put"), TotalPutValue=sum(Valuation))
summarise(option1, TotalValuation=sum(Valuation))

#1.3
mutate(options, Payoff=ifelse(StockPrice>Strike, StockPrice-Strike,0)) %>%
  dplyr::filter(.,Payoff>=0) %>%
  nrow(.)

#1.4
library(lubridate)
mutate(options, Time=as.numeric(as.Date(ExpiryDate, format="%d-%b-%y")-as.Date(ExtractionDate, format="%d-%b-%y"))/365) %>% #Create new column of time difference in years, note that date format is the format in csv doc
  mutate(., type=ifelse(Type=="Call","c","p")) %>% #To change format of type from call and put to 'c' and 'p' for feeding into GBSVol function
  select(., OptionPrice, type, StockPrice, Strike, Time) %>% #To select input columns for function and rearrange them 
  rowwise(.) %>% #To group each row as 1 data for feeding into GBSVol function
  mutate(., ImpliedVol=GBSVolatility(price=OptionPrice, TypeFlag=type, S=StockPrice, X=Strike, Time=Time, r=0.01, b=0, tol=0.005, maxiter=100000)) -> option2 #To create a column of implied vol values

#plot(option2$Strike, option2$ImpliedVol)

library(ggplot2)
ggplot(option2) + 
  geom_point(data=dplyr::filter(option2, type=="c"), aes(Strike, ImpliedVol), color="red") +
  geom_point(data=dplyr::filter(option2, type=="p"), aes(Strike, ImpliedVol), color="blue") 
  
  

