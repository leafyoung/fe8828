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

total_value=0

for(i in 1:100)
{
  # YY: S is for underlying, S is for strike
  value=GBSOption(TypeFlag = df$type[i], S = df$strike[i], X = df$underlying[i],
            Time = df$Time[i], r = df$r[i], b = df$b[i], sigma = df$sigma[i])@price
  total_value=total_value+value
}

total_value
