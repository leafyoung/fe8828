library(fOptions)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE), 
                 strike = round(runif(100) * 100, 0), 
                 underlying = round(runif(100) * 100, 0), 
                 Time = 1, 
                 r = 0.01, 
                 b = 0, 
                 sigma = 0.3)

price <- GBSOption(df$type, df$underlying, df$strike, df$Time,
                   df$r, df$b, df$sigma)@price

print(sum(price))
