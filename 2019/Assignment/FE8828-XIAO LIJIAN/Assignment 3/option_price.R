library(fOptions)

GBSOption(TypeFlag = "p", S = 65, X = 93,
          Time = 1, r = 0.01, b = 0, sigma = 0.3)@price
#test the first option. price is 29.02299

set.seed(100)
df <- data.frame(type = sample(c("p", "c"), 100, replace = TRUE),
                 underlying = round(runif(100)*100, 0),                 
                 strike = round(runif(100)*100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)


price_list <- rowwise(df) %>%
  mutate(opt_price = GBSOption(TypeFlag = type, S = underlying, X = strike,
          Time = Time, r = r, b = b, sigma = sigma)@price) %>%
  ungroup() %>%
  .$opt_price %>%
  sum

price_list
#the first output of price_list is consistent with the test above. 
#so the answer is given by price_list

