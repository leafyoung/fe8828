#Question 1
set.seed(100)
portfolio <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

portfolio %>% group_by(type) %>%
  # YY: need rowwise() to split into every row.
  rowwise() %>%
  mutate(value = GBSOption(TypeFlag = type, S = underlying, X = strike,Time = 1, r = 0.01, b = 0, sigma = 0.3)@price) %>%
  ungroup %>%
  summarise(Total_value = sum(value,na.rm = TRUE))
