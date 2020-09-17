# Author:Bai Haoyu
# Matric Number: G1900411H
# Date: 25 Sept 2019

#Question 1: Evaluate a portfolio of options for its total value
library(fOptions)
library(dplyr)

GBSOption(TypeFlag = "p", S = 3500, X = 3765,
          Time = 1/12, r = 0, b = 0, sigma = 0.3)@price
## [1] 300.0049

set.seed(100)
df_bhy <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

# # Calculate the total value of the portfolio - as we discussed, this way is wrong
# df2 <- mutate(df, price=GBSOption(TypeFlag=type, S=underlying, X=strike, Time=Time, r=r, b=b, sigma=sigma)@price)
# total_value <- sum(df2$price)
# total_value

# This way is correct
df_bhy3 <- rowwise(df_bhy)
df_bhy3 <- mutate(df_bhy3, price=GBSOption(TypeFlag=type, S=underlying, X=strike, Time=Time, r=r, b=b, sigma=sigma)@price) 
option_value <- sum(df_bhy3$price)
option_value

# df2
# df3