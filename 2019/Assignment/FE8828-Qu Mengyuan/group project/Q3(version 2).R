library(readr)
library(lubridate)
library(tidyverse)
library(tidyquant)
library(fOptions)
library(dplyr)
library(xts)

stock <- read_csv("AMZN.csv", col_types = cols_only(Close = col_number(), Date = col_date(format = "%Y-%m-%d")))
VIX <- read_csv("VXAZNCLS.csv", col_types = cols(DATE = col_date(format = " %Y-%m-%d"),VXAZNCLS = col_number()))
names(VIX) <- c('Date','IV30')

option <- full_join(stock,VIX,on = 'Date') %>% na.omit()
option$volatility <- option$IV30/100

# one trade
one_trade <- dplyr::filter(option, between(Date,as.Date('2019-09-01'),as.Date('2019-09-30')))

start_date <- min(one_trade$Date)
end_date <- max(one_trade$Date)
end = nrow(one_trade) 
start_price <- one_trade$Close[1]
last_price <- one_trade$Close[end]
start_volatility <- one_trade$volatility[1]
one_trade$Time_to_expiry <- as.numeric(end_date - one_trade$Date) / 365

# Option side:
  # Vary S and Time everyday
  one_trade <- rowwise(one_trade) %>%
  mutate(premium = 100*GBSOption(TypeFlag = "c",
                             S = Close,
                             X = start_price,
                             Time = Time_to_expiry,
                             r = 0.8 / 100, # interest rate
                             b = 0, # dividend yield
                             sigma = start_volatility)@price) %>%
  ungroup %>%
  mutate(Option_DoD_PnL = c(premium[1]*(-1),diff(premium)))
one_trade$Option_DoD_PnL[end] <- ifelse(last_price>start_price,100*(last_price-start_price),0)

# Hedge side:
  one_trade <- one_trade %>%
  rowwise() %>%
  mutate(delta_hedge = GBSGreeks("delta", 
                                 TypeFlag = "c", 
                                 S = Close,
                                 X = start_price,
                                 Time = Time_to_expiry,
                                 r = 0.8 / 100, # interest rate
                                 b = 0, # dividend yield
                                 sigma = start_volatility) * 100 * (-1)) %>%
  ungroup() %>%
    mutate(Hedging_DoD_Pnl = dplyr::lag(delta_hedge) * (Close-dplyr::lag(Close)))
  
  one_trade$Hedging_DoD_Pnl[1] <- 0
  one_trade['Daily_PnL'] <- one_trade$Option_DoD_PnL+one_trade$Hedging_DoD_Pnl
  one_trade['Option_Final_PnL'] <- cumsum(one_trade$Option_DoD_PnL)
  one_trade['Hedging_Final_PnL'] <- cumsum(one_trade$Hedging_DoD_Pnl)
  one_trade['Final_PnL'] <- one_trade['Option_Final_PnL']+one_trade['Hedging_Final_PnL']
  max_drawdown <- max(cummax(one_trade$Final_PnL) - cummin(one_trade$Final_PnL))
  one_trade['portfolio_value'] <- one_trade$delta_hedge * one_trade$Close + one_trade$premium
  one_trade <- mutate(one_trade, return = Daily_PnL/dplyr::lag(portfolio_value))

  Sharpe_ratio <- (mean(one_trade$return[1:end-1],na.rm = TRUE)-0.008/250)/stdev(one_trade$return[1:end-1],na.rm = TRUE)

  
      
# backtest
  option$Option_Expiry_Date <- option$Date
  day(option$Option_Expiry_Date) <- days_in_month(option$Option_Expiry_Date)
  one_year <- dplyr::filter(option, between(Date,as.Date('2018-10-01'),as.Date('2019-09-30')))
  Option_Expiry_Date <- unique(one_year$Option_Expiry_Date)
  backtest <- tibble(Option_Expiry_Date = Option_Expiry_Date, S0 = rep(0,12),
                     implied_volatility = rep(0,12), realised_volatility = rep(0,12),
                     Final_PnL = rep(0,12), Max_Drawdown = rep(0,12), 
                     Sharpe_ratio = rep(0,12), K = rep(0,12))
  
  for (date in Option_Expiry_Date) {
    one_trade <- dplyr::filter(one_year, Option_Expiry_Date == date)
    one_trade <- mutate(one_trade, stock_return = Close/dplyr::lag(Close))
    
    start_date <- min(one_trade$Date)
    end_date <- max(one_trade$Date)
    end = nrow(one_trade) 
    start_price <- one_trade$Close[1]
    last_price <- one_trade$Close[end]
    start_volatility <- one_trade$volatility[1]
    one_trade$Time_to_expiry <- as.numeric(end_date - one_trade$Date) / 365
    
    # Option side:
    # Vary S and Time everyday
    one_trade <- rowwise(one_trade) %>%
      mutate(premium = 100*GBSOption(TypeFlag = "c",
                                     S = Close,
                                     X = start_price,
                                     Time = Time_to_expiry,
                                     r = 0.8 / 100, # interest rate
                                     b = 0, # dividend yield
                                     sigma = start_volatility)@price) %>%
      ungroup %>%
      mutate(Option_DoD_PnL = c(premium[1]*(-1),diff(premium)))
    one_trade$Option_DoD_PnL[end] <- ifelse(last_price>start_price,100*(last_price-start_price),0)
    
    # Hedge side:
    one_trade <- one_trade %>%
      rowwise() %>%
      mutate(delta_hedge = GBSGreeks("delta", 
                                     TypeFlag = "c", 
                                     S = Close,
                                     X = start_price,
                                     Time = Time_to_expiry,
                                     r = 0.8 / 100, # interest rate
                                     b = 0, # dividend yield
                                     sigma = start_volatility) * 100 * (-1)) %>%
      ungroup() %>%
        mutate(Hedging_DoD_Pnl = dplyr::lag(delta_hedge) * (Close-dplyr::lag(Close)))
    
    one_trade$Hedging_DoD_Pnl[1] <- 0
    one_trade['Daily_PnL'] <- one_trade$Option_DoD_PnL+one_trade$Hedging_DoD_Pnl
    one_trade['Option_Final_PnL'] <- cumsum(one_trade$Option_DoD_PnL)
    one_trade['Hedging_Final_PnL'] <- cumsum(one_trade$Hedging_DoD_Pnl)
    one_trade['Final_PnL'] <- one_trade['Option_Final_PnL']+one_trade['Hedging_Final_PnL']
    max_drawdown <- max(cummax(one_trade$Final_PnL) - cummin(one_trade$Final_PnL))
    one_trade['portfolio_value'] <- one_trade$delta_hedge * one_trade$Close + one_trade$premium
    one_trade <- mutate(one_trade, return = Daily_PnL/dplyr::lag(portfolio_value))

    Sharpe_ratio <- (mean(one_trade$return[1:end-1],na.rm = TRUE)-0.008/250)/stdev(one_trade$return[1:end-1],na.rm = TRUE)
    
    # 2nd-round analysis
    K <- start_price + 1
    while (GBSGreeks("delta","c",start_price, K,1/12,0.008,0,start_volatility) >= 0.26) {
      K = K + 1
    }
    while (GBSGreeks("delta","c",start_price, K,1/12,0.008,0,start_volatility) >= 0.25) {
      K = K + 0.1
    }
    K <- round(ifelse(abs(GBSGreeks("delta","c",start_price, K,1/12,0.008,0,start_volatility)-0.25) < abs(GBSGreeks("delta","c",start_price, K-0.1,1/12,0.008,0,start_volatility)-0.25),
                      K,K-0.1),2)
    
    backtest[which(Option_Expiry_Date==date),2:8] <- c(start_price, start_volatility, sd(one_trade$stock_return, na.rm = TRUE),
                                                       one_trade$Final_PnL[end], max_drawdown, Sharpe_ratio, K)
  }
  
  ggplot(backtest,aes(Final_PnL)) + geom_density()
  ggplot(backtest,aes(Max_Drawdown)) + geom_density()
  ggplot(backtest) +
    geom_col(aes(x = Option_Expiry_Date, y = Final_PnL))
  ggplot(backtest) +
    geom_col(aes(x = Option_Expiry_Date, y = Sharpe_ratio))
  
  lm.sol <- lm(backtest$K~backtest$S0)
  summary(lm.sol)
  formula <- sprintf("italic(K)==%.3f+%.3f*italic(S0)",
                   round(lm.sol$coefficients[1][1],3),round(lm.sol$coefficients[2],3))
  ggplot(backtest,aes(S0,K)) +
    geom_point() +
    geom_smooth(method = "lm") +
    geom_text(x=1750,aes(label=formula,y=1800),parse=TRUE,hjust=0,size=8)
  
  backtest$ratio <- backtest$implied_volatility/backtest$realised_volatility
  lm.sol <- lm(backtest$Sharpe_ratio~backtest$ratio)
  summary(lm.sol)
  formula <- sprintf("italic(Sharpe_ratio)==%.3f+%.3f*italic(sigma_impied)/italic(sigma_realised)",
                     round(lm.sol$coefficients[1],3),round(lm.sol$coefficients[2],3))
  ggplot(backtest,aes(implied_volatility/realised_volatility, Sharpe_ratio)) +
    geom_point() +
    geom_smooth(method = "lm") +
    geom_text(x=13,aes(label=formula,y=0.7),parse=TRUE,hjust=0,size=4)