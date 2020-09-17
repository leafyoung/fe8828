library(tidyverse)
library(fOptions)

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
# Generate 100 options with random strike and underlying prices

value <- GBSOption(df$type, df$underlying, df$strike, df$Time, df$r, df$b, df$sigma)
# Inputting the 100 options' characteristics into GBSOption function
price <- value@price
# Isolating the prices of the 100 options
port_ttl_value <- sum(price)
# Portfolio value is sum of the 100 option prices
port_ttl_value
