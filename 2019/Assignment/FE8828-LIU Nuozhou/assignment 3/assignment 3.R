# P51 Exercise 3
library(fOptions)
library(tidyverse)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE), 
                 strike = round(runif(100) * 100, 0), 
                 underlying = round(runif(100) * 100, 0), 
                 Time = 1,
                 r = 0.01, 
                 b = 0, 
                 sigma = 0.3)

price<-df%>%
  rowwise() %>%
  transmute(price=GBSOption(TypeFlag = type,S=underlying,X=strike,Time=Time,r=r,b=b,sigma=sigma)@price)

TotalValue<-sum(price)
TotalValue


