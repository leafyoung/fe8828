set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

df_2 <- df %>% 
  rowwise() %>%
  # YY: S is for underlying and X is for strike. Swap
  mutate(Price = GBSOption(type,strike,underlying,Time,r,b,sigma)@price) %>% 
  .$Price %>% 
  sum %>%
  {cat(paste0("The total value of the portfolio is ",. ))}
