#to evaluate a portfolio of options for its total value

library(fOptions)
library(dplyr)

GBSOption(TypeFlag = "p", S = 3500, X = 3765,
          Time = 1/12, r = 0, b = 0, sigma = 0.3)@price
## [1] 300.0049
df <- data.frame(type = sample(c("c", "p"), 100, replace = T),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)


df %>%
  rowwise(.) %>% #to group every row as 1 set of data 
  mutate(., price=GBSOption(TypeFlag=type, S=underlying, X=strike, Time=Time, r=r, b=b, sigma=sigma)@price) %>% 
  ungroup %>% #ungroup 
  summarise(sum=sum(price))

