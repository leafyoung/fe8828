library(fOptions)
library(tidyverse)
GBSOption(TypeFlag = "p", S = 3500, X = 3765,
          Time = 1/12, r = 0, b = 0, sigma = 0.3)@price
## [1] 300.0049

# YY: reproducibility
set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

df %>%
  # S is for underlying and X is for strike.
  # need rowwise()
  rowwise() %>%
  mutate( amount = GBSOption(TypeFlag = type, S = strike, X = underlying,
          Time = Time, r = r, b = b, sigma = sigma)@price)%>%
  ungroup() %>%
  summarise(total=sum(amount))
  