#Read data from the created csv file (part 1)
goog_option_data <- read.csv("Book2.csv")

#Calculate the valuations of Call, Put and both (part 2)
valuations <- goog_option_data %>% group_by(Call.Put) %>%
  summarise(valuation = sum(Open.Int * (Bid + Ask)/2))
call_valuation <- valuations[1,2]
put_valuation <- valuations[2,2]
total_valuation <- sum(valuations[["valuation"]])

#GOOG closing price as of 23 Nov, 2018
goog_close <- 1023.88 #As of 23 Nov 2018

#Find all the ITM Calls and sum their Open Interest (part 3)
itm_open_int <- goog_option_data %>% 
  mutate(itm = ifelse(Call.Put=="Call", 
                      ifelse(goog_close>Strike, 1, 0), 
                      ifelse(goog_close<Strike, 1, 0))) %>% 
  dplyr::filter(itm==1) %>%
  summarize(total_open_int = sum(Open.Int))

#Calculate the volatilities for each strike level (part 4)
goog_volatilities <- goog_option_data %>% 
  mutate(itm = ifelse(Call.Put=="Call", ifelse(goog_close>Strike, 1, 0), 
                      ifelse(goog_close<Strike, 1, 0))) %>% 
  dplyr::filter(itm==0) %>% 
  arrange(Strike) %>% 
  rowwise() %>% 
  mutate(.,volatility = ifelse(Call.Put=="Call", 
                               GBSVolatility((Bid+Ask)/2, "c", goog_close, Strike, 
                                             as.numeric((as.Date("2018-12-14") - 
                                                           as.Date("2018-11-23")))/365, 
                                             r=0.03, b=0), 
                               GBSVolatility((Bid+Ask)/2, "p", goog_close, Strike, 
                                             as.numeric((as.Date("2018-12-14") - 
                                                           as.Date("2018-11-23")))/365, 
                                             r=0.03, b=0)))

#Plot the volatility smile (vol vs. strike)
plot(goog_volatilities$Strike, goog_volatilities$volatility, type = "l")


#Question - Portfolio

df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

df %>% rowwise() %>%
  mutate(valuation = 
           GBSOption(as.character(type), underlying, strike, Time, r, b, sigma)@price) %>%
  ungroup() %>%
  summarise(portfolio_price = sum(valuation), 
            portfolio_value = sum(ifelse(type=="c", max(underlying-strike, 0), 
                                         max(strike-underlying,0)))) %>% 
  View()



  
