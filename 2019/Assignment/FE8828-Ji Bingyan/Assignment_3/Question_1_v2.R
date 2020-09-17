library(fOptions)
library(tidyverse)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = T),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

mutate(rowwise(df), price = GBSOption(type, underlying, strike, Time, r, b, sigma)@price) %>%
    ungroup() %>%
    summarise(sum = sum(price), mean = mean(price))
