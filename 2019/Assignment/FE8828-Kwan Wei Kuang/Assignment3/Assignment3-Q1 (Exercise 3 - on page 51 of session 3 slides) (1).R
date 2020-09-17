#Assignment 3, Q1: Exercise 3 - on page 51 of session 3 slides
library(fOptions)
library(tidyverse)

GBSOption(TypeFlag = "p", S = 3500, X = 3765,
          Time = 1/12, r = 0, b = 0, sigma = 0.3)@price

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

rowwise(df) %>% mutate(optionValue = GBSOption(TypeFlag=type, S=underlying, X=strike, Time=Time, r=r, b=b, sigma=sigma)@price) %>% 
  select(optionValue) %>% sum

#check total value of portfolio of options using a for-loop
#sum = 0
#for (i in 1:length(df$type)){
#  sum = sum + GBSOption(TypeFlag=df$type[i], S=df$underlying[i], X=df$strike[i], Time=df$Time[i], r=df$r[i], b=df$b[i], sigma=df$sigma[i])@price
#}
#cat(paste0(sum))
