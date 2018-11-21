#Exercise 3: to evaluate a portfolio of options for its total value

library(fOptions)

GBSOption(TypeFlag = "p", S = 3500, X = 3765,
          Time = 1/12, r = 0, b = 0, sigma = 0.3)@price
## [1] 300.0049
df <- data.frame(type = sample(c("c", "p"), 100, replace = T),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

#price <- GBSOption(TypeFlag = "p", S = df$underlying, X = df$strike,
          # Time = df$Time, r = df$r, b = df$b, sigma = df$sigma)@price
#sum(price)

library(fOptions)
library(dplyr)
df %>%
  rowwise(.) %>%
  mutate(., price=GBSOption(TypeFlag=type, S=underlying, X=strike, Time=Time, r=r, b=b, sigma=sigma)@price) %>%
  ungroup %>%
  summarise(sum=sum(price))


