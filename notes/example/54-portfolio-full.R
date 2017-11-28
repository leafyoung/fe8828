library(tidyverse)
library(tidyquant)
library(timetk)

# The symbols vector holds our tickers. 
symbols <- c("SPY","EFA", "IJS", "EEM","AGG")

# The prices object will hold our raw price data throughout this book.
prices <- 
  getSymbols(symbols, src = 'google', from = "2005-01-01", 
             auto.assign = TRUE, warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`(symbols)

prices_monthly <- to.monthly(prices, indexAt = "last", OHLC = FALSE)
asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))

# Tidyverse method, to long, tidy format
asset_returns_long <- prices %>% 
  to.monthly(indexAt = "last", OHLC = FALSE) %>% 
  tk_tbl(preserve_index = TRUE, rename_index = "date") %>%
  gather(asset, returns, -date) %>% 
  group_by(asset) %>%  
  mutate(returns = (log(returns) - log(lag(returns))))

head(asset_returns_xts)
head(asset_returns_long)

w <- c(0.25, 0.25, 0.20, 0.20, 0.10)

asset_weights_sanity_check <- tibble(w, symbols)
asset_weights_sanity_check

sum(asset_weights_sanity_check$w)

w_1 <- w[1]
w_2 <- w[2]
w_3 <- w[3]
w_4 <- w[4]
w_5 <- w[5]

asset1 <- asset_returns_xts[,1]
asset2 <- asset_returns_xts[,2]
asset3 <- asset_returns_xts[,3]
asset4 <- asset_returns_xts[,4]
asset5 <- asset_returns_xts[,5]

portfolio_returns_byhand <-   
  (w_1 * asset1) + 
  (w_2 * asset2) + 
  (w_3 * asset3) +
  (w_4 * asset4) + 
  (w_5 * asset5)

names(portfolio_returns_byhand) <- "returns"

portfolio_returns_xts_rebalanced_monthly <- 
  Return.portfolio(asset_returns_xts, weights = w, rebalance_on = "months") %>%
  `colnames<-`("returns")

portfolio_returns_xts_rebalanced_yearly <- 
  Return.portfolio(asset_returns_xts, weights = w, rebalance_on = "years") %>%
  `colnames<-`("returns")

head(portfolio_returns_byhand)
head(portfolio_returns_xts_rebalanced_monthly)
head(portfolio_returns_xts_rebalanced_yearly)

# tidyquant way
portfolio_returns_tq_rebalanced_monthly <- 
  asset_returns_long %>%
  tq_portfolio(assets_col  = asset, 
               returns_col = returns,
               weights     = w,
               col_rename  = "returns",
               rebalance_on = "months")

portfolio_returns_tq_rebalanced_yearly <- 
  asset_returns_long %>%
  tq_portfolio(assets_col  = asset, 
               returns_col = returns,
               weights     = w,
               col_rename  = "returns",
               rebalance_on = "years")

head(portfolio_returns_tq_rebalanced_monthly)
head(portfolio_returns_tq_rebalanced_yearly)