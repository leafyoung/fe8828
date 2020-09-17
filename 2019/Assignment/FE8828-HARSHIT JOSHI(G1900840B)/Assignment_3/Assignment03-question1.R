library(fOptions)
library(tidyverse)
library(dplyr)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0), Time = 1, r = 0.01, b = 0, sigma = 0.3)


df<-df %>%
  rowwise() %>%
  mutate(price=ifelse(type=="p", GBSOption(TypeFlag = "p", S = underlying, X = strike, Time = Time, r = r, b = 0, sigma = sigma)@price,
                      GBSOption(TypeFlag = "c", S = underlying, X = strike, Time = Time, r = r, b = 0, sigma = sigma)@price))

tot_portfolio_value<-df%>%
  ungroup() %>%
  summarise(ans=sum(price))

paste("Total portfolio value: ",tot_portfolio_value)
