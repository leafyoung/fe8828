library(fOptions)
library(dplyr)

set.seed(100)
df_jain <-data.frame(type =sample(c("c", "p"), 100, replace =TRUE),
                strike =round(runif(100) *100, 0),
                underlying =round(runif(100) *100, 0),
                Time =1,r =0.01,b =0,sigma =0.3)

df_jain = df_jain %>%
  rowwise() %>%
  mutate(option_price = round(GBSOption(TypeFlag = type,
                                        S = underlying,
                                        X = strike,
                                        Time = Time,
                                        r = r,
                                        b = b,
                                        sigma = sigma)@price, 4)) %>%
  ungroup()

cat(paste("The Portfolio Value is = ",sum(df_jain$option_price),"\n"))
