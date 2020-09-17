#install.packages("fOptions")
library(fOptions)
library(tidyverse)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

GBSOption(TypeFlag = "c", S = 85, X = 2,
          Time = 1, r = 0.01, b = 0, sigma = 0.3)@price

prices=c()
for( i in 1:nrow(df)){
  # YY: S is for underlying, X is for strike
  prices=c(prices,GBSOption(TypeFlag = df$type[i], S = df$strike[i], X = df$underlying[i],
                            Time = df$Time[i], r = df$r[i], b = df$b[i], sigma = df$sigma[i])@price)
}
prices<- round(prices,6)
df2<-mutate(df,price=prices)
View(df2)
sum(prices)
sum(df2$price)
