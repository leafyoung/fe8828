library(fOptions)
library(tidyverse)
library(readxl)

# https://www.nasdaq.com/market-activity/stocks/goog/option-chain?dateindex=1

df <- read_xlsx("goog_option_chain.xlsx", na = "--")

# Clean it to have following columns. Note the original data make calls and puts share the same strike column.
# Exp. Date | Strike | Open Int. | OptionType | Bid | Ask | Underlying | Today

clean_df <- df %>% 
  select(exp_date, strike, puts_open_int, calls_open_int, puts_bid, calls_bid, puts_ask, calls_ask) %>% 
  mutate(strike = as.numeric(strike),
         calls_open_int = as.numeric(calls_open_int),
         calls_bid = as.numeric(calls_bid),
         puts_bid = as.numeric(puts_bid),
         puts_ask = as.numeric(puts_ask),
         calls_ask = as.numeric(calls_ask)) %>% 
  pivot_longer(cols = c(-exp_date, -strike)) %>% 
  mutate(OptionType = ifelse(grepl("puts", name), "p", "c")) %>% 
  mutate(name = gsub("puts_|calls_", "", name)) %>% 
  mutate(exp_date = as.Date(exp_date, format = "%b %d")) %>% 
  pivot_wider(names_from = name, values_from = value) %>% 
  mutate(underlying = 1515.22, 
         today = 1515.22) %>% 
  dplyr::filter(!is.na(open_int))

# 2.2 Calculate the total valuation of call alone
clean_df %>% 
  dplyr::filter(OptionType == "c") %>% 
  mutate(total_valuation = open_int*(bid+ask)/2) %>% 
  summarise(total_valuation = sum(total_valuation))

# 2.2 Calculate the total valuation of put alone
clean_df %>% 
  dplyr::filter(OptionType == "p") %>% 
  mutate(total_valuation = open_int*(bid+ask)/2) %>% 
  summarise(total_valuation = sum(total_valuation))

# 2.2 Calculate the total valuation of call and put
clean_df %>% 
  mutate(total_valuation = open_int*(bid+ask)/2) %>% 
  summarise(total_valuation = sum(total_valuation))

# 2.3 Find those in the money (for calls, strike < underlying. for puts, strike > underlying.) and calculate their total Open Interest.
clean_df %>% 
  dplyr::filter((OptionType == "c" & strike < underlying ) | 
                  (OptionType == "p" & strike > underlying )) %>% 
  summarise(total_open_int = sum(open_int))

# 2.4. Plot the volatility curve, strike v.s. vol. For strike < current price, use puts’ price; for strike > current price, use calls’ price
# Use rowwise() %>% mutate(... = GBSVolatility) %>% ungroup(). rowwise()

vol_data <- clean_df %>% 
  mutate(price = (bid+ask)/2) %>% 
  rowwise() %>% 
  mutate(gbs = GBSVolatility(price = price, 
                             TypeFlag = OptionType, 
                             S = underlying, 
                             X = strike, 
                             Time = as.numeric((exp_date - as.Date("2020-10-11")))/365,
                             b = 0,
                             r = 0.03)) %>% 
  filter(OptionType == "p")

plot(vol_data$strike, vol_data$gbs, type="b", 
     xlab = "Strike Price", ylab = "Implied Volatility", main = "Volatility Curve")

