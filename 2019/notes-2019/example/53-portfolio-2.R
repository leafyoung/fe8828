# 53-portfolio-2.R

library(purrr)
library(tidyverse)
library(tidyquant)
library(dygraphs)

# SPY: SPDR S&P 500 ETF Trust
# IJS: iShares S&P SmallCap 600 Value Idx
# EFA: iShares MSCI EAFE Index Fund (ETF): large- and mid-capitalization developed market equities, excluding the U.S. and Canada.
# EEM: iShares MSCI Emerging Markets Indx (ETF)
# AGG: iShares Barclays Aggregate Bond Fund: total U.S. investment-grade bond 

symbols <- c("SPY","IJS","EFA","EEM","AGG")

prices <- 
  getSymbols(symbols, src = 'yahoo', from = "2005-01-01", 
             auto.assign = TRUE, warnings = FALSE) %>% 
  map(~Cl(get(.))) %>%  # Cl is from quantmod: get Close price
  reduce(merge) %>%
  `colnames<-`(symbols)

prices_monthly <- to.monthly(prices, indexAt = "first", OHLC = FALSE)
portfolioComponentReturns <- na.omit(Return.calculate(prices_monthly, method = "log"))

plot_ticker <- function(ticker) {
  ts <- portfolioComponentReturns[, ticker, drop = F]
  sd_lt <- StdDev(ts)
  
  sd_overtime <- round(rollapply(ts, 20, function(x) StdDev(x)), 4)
  
  sd_overtime$SD_Longterm <- sd_lt
  
  dygraph(sd_overtime,
          main = paste("Volatility history of ", ticker)) %>%
    dyAxis("y", label = "%") %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = FALSE, drawGrid = TRUE) %>%
    dyRangeSelector()
}

plot_ticker("SPY")
plot_ticker("IJS")

w = c(0.25, 0.20, 0.20, 0.25, 0.10)

w_1 <- w[1]
w_2 <- w[2]
w_3 <- w[3]
w_4 <- w[4]
w_5 <- w[5]

asset1 <- portfolioComponentReturns[,1]
asset2 <- portfolioComponentReturns[,2]
asset3 <- portfolioComponentReturns[,3]
asset4 <- portfolioComponentReturns[,4]
asset5 <- portfolioComponentReturns[,5]

portfolio_returns_byhand <-
  (w_1 * asset1) + 
  (w_2 * asset2) + 
  (w_3 * asset3) +
  (w_4 * asset4) + 
  (w_5 * asset5)

names(portfolio_returns_byhand) <- "abs returns"

portfolio_returns_xts_rebalanced_monthly <- 
  Return.portfolio(portfolioComponentReturns, weights = w, rebalance_on = "months") %>%
  `colnames<-`("month-rebal returns")

portfolio_returns_xts_rebalanced_yearly <- 
  Return.portfolio(portfolioComponentReturns, weights = w, rebalance_on = "years") %>%
  `colnames<-`("year-rebal returns")

head(portfolio_returns_byhand)
head(portfolio_returns_xts_rebalanced_monthly)
head(portfolio_returns_xts_rebalanced_yearly)

plot_portfolio <- function(portfolio_returns) {
  portfolio_returns_cum <- cumprod(portfolio_returns + 1)
  
  library(htmltools)
  
  g1 <- dygraph(portfolio_returns,
          main = paste("Return")) %>%
    dyAxis("y", label = "%") %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = FALSE, drawGrid = TRUE) %>%
    dyRangeSelector()
  
  g2 <- dygraph(portfolio_returns_cum, 
          main = paste("Cumulative Return")) %>%
    dyAxis("y", label = "%") %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = FALSE, drawGrid = TRUE) %>%
    dyRangeSelector()
  
  sd_lt <- StdDev(portfolio_returns)
  
  sd_overtime <- 
    round(rollapply(portfolio_returns, 20, function(x) StdDev(x)), 4)
  
  sd_overtime$SD_Longterm <- sd_lt
  
  g3 <- dygraph(sd_overtime, 
          main = paste("Volatility history of ", "portfolio_returns_cum")) %>%
    dyAxis("y", label = "%") %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = FALSE, drawGrid = TRUE) %>%
    dyRangeSelector()
  
  browsable(
    tagList(g1, g2, g3)
  )
}

plot_portfolio(portfolio_returns_byhand)
plot_portfolio(portfolio_returns_xts_rebalanced_monthly)
plot_portfolio(portfolio_returns_xts_rebalanced_yearly)

plot_bband <- function(ticker, n_days = 93) {
  ts <- prices[, ticker, drop = F]
  sd_overtime <- round(rollapply(ts, n_days, function(x) StdDev(x)), 3)
  mean_overtime <- round(rollapply(ts, n_days, function(x) mean(x)), 3)
  new_ts <- ts
  new_ts$ma <- mean_overtime
  new_ts$u2 <- mean_overtime + sd_overtime * 2
  new_ts$d2 <- mean_overtime - sd_overtime * 2
  
  dygraph(new_ts,
          main = paste0("Bollinger Bands ", ticker)) %>%
    dyAxis("y", label = "") %>%
    dySeries("ma", strokePattern = "dashed") %>%
    dyOptions(axisLineWidth = 1.5, fillGraph = FALSE, drawGrid = TRUE) %>%
    dyRangeSelector()
}

plot_bband("SPY")

