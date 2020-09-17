library(fOptions)
library(dplyr)

set.seed(100)
options <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE), strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

options <- rowwise(options) %>% 
  mutate(value=(GBSOption(TypeFlag = type, S = strike, X = underlying,
         Time = Time, r = r, b = b, sigma = sigma)@price))


total <-sum(options$value)