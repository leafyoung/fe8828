library(dplyr)
library(lubridate)
library(ggplot2)
library(fOptions)

options <- read.csv("C:/Users/Bryan/Documents/Education/NTU MFE/Curriculum/FE8828 Programming Web Applications in Finance/amzn_optionchain.csv")

options <- optiondf

options_w_value <- mutate(options, Value = Quantity * OptionPrice)
summarise(filter(options_w_value, Type == "Call"), sum(Value))  # Ans: 24258325
summarise(filter(options_w_value, Type == "Put"), sum(Value))  # Ans:211586.1
summarise(options_w_value, sum(Value))  # Ans: 24469911


calls <- filter(options, Type == "Call")
puts <- filter(options, Type == "Put")
calls_w_payoff <- mutate(calls, Payoff = ifelse(StockPrice > Strike, StockPrice - Strike, 0))
puts_w_payoff <-mutate(puts, Payoff = ifelse(StockPrice < Strike, Strike - StockPrice, 0))
options_w_payoff <- rbind(calls_w_payoff,puts_w_payoff) 
options_inthemoney <- filter(options_w_payoff, Payoff >0)
nrow(options_inthemoney)  # Ans: 87

options_w_vol <- mutate(options, YearsToMaturity = as.numeric(as.Date(ExpiryDate, format="%d-%b-%y")-as.Date(ExtractionDate, format="%d-%b-%y"))/365) %>%
  mutate(., Type =ifelse(Type=="Call","c","p")) %>%
  select(., OptionPrice, Type, StockPrice, Strike, YearsToMaturity) %>%  
  rowwise(.) %>%
  mutate(., ImpliedVol=GBSVolatility(price=OptionPrice, TypeFlag=Type, S=StockPrice, X=Strike, Time=YearsToMaturity, r=0.01, b=0, tol=0.1, maxiter=100000)) 
  
ggplot(options_w_vol, aes(Strike, ImpliedVol, color = Type)) + 
  geom_smooth(method = "loess", se = FALSE) +
  geom_point()
   

