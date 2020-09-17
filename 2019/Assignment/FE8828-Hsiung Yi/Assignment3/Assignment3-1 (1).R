library(fOptions)
library(dplyr)
GBSOption(TypeFlag = "c", S = 34, X = 66,
          Time = 1, r = 0.01, b = 0, sigma = 0.3)@price
## [1] 300.0049

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

# S is for underlying, X is for strike
df <- rowwise(df) %>% mutate(Price = GBSOption(TypeFlag = type, S = strike, X = underlying,
                                     Time = Time, r = r, b = b, sigma = sigma)@price)
mean_price <- mean(df$Price)
total_value <- sum(df$Price)
total_value
          
          