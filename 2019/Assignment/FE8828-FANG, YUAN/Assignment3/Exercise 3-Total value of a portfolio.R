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

value <- rep(0,nrow(df))
for (i in 1:nrow(df)) {
  value[i] <- {rowwise(df[i, ]) %>%
    mutate(price = GBSOption(type, underlying, strike, Time, r, b, sigma)@price)}$price
}
sum(value)
