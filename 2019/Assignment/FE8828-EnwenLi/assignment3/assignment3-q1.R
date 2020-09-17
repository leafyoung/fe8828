#question1-exercise3

#generate the data
library(tidyverse)
library(fOptions)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE), 
                 strike = round(runif(100) * 100, 0), 
                 underlying = round(runif(100) * 100, 0), 
                 Time = 1, 
                 r = 0.01, 
                 b = 0, 
                 sigma = 0.3)
df<-rowwise(df) %>% mutate(price=GBSOption(type,underlying,strike,Time,r,b,sigma)@price)
total_value=sum(df$price)
total_value
