#Question: To evaluate a portfolio of options for its total value  
#Exercise 3 - on page 51 of session 3 slides
#Select the whole script and run to see the final answer

library(fOptions)
library(dplyr)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

df <- mutate(df, 
             price = GBSOption(
               TypeFlag = type, 
               S = strike, 
               X = underlying,
               Time = Time, 
               r = r, 
               b = b, 
               sigma = sigma)@price)

summarise(df, total = sum(price*strike))