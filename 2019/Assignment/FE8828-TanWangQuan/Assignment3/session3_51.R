library("dplyr")
library("fOptions")

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

# YY: S is for underlying, X is for strike.
df_1<- rowwise(df) %>%
  mutate(price=GBSOption(TypeFlag = type, S = strike, X = underlying,
                               Time = 1, r = 0.01, b = 0, sigma = 0.3)@price,scientific=FALSE)

df_1%>%select(price)%>%sum()

