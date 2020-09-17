
set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

rowwise(df) %>%
  # S is for underlying, K is for strike.
mutate(OptionValue = 
         GBSOption(type,strike,underlying,Time,r, b,sigma)@price) %>%
  ungroup() %>%
  summarise(.,totalvalue=sum(OptionValue,na.rm=TRUE))
