library(fOptions)
GBSOption(TypeFlag = "p", S = 3500, X = 3765,
          Time = 1/12, r = 0, b = 0, sigma = 0.3)@price

df <- data.frame(type = sample(c("c", "p"), 100, replace = T),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)
df$price <- GBSOption(df$type,df$underlying,df$strike,df$Time,df$r,df$b,df$sigma)@price
df

