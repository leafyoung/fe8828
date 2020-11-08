library(alphavantager)
library(tidyverse)
setwd("~/Studies/NTU MFE/T1MT2 FE8828 Programming Web Applications in Finance (E)/Homeworks/Assignment4/data")
av_api_key("41Z15ZWB1H07CPWA")
df <- av_get("SPY", av_fun = "TIME_SERIES_DAILY_ADJUSTED")[c('timestamp','adjusted_close')] %>% rename(SPY = adjusted_close)
tickers <- c("BABA", "AAPL", "NFLX", "GOOG")
for (ticker in tickers) {
  # bind_rows(df,av_get(ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED")['adjusted_close'])
  # df <- mutate(df, "ticker" = av_get(ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED")['adjusted_close'])
  df[ticker] <- av_get(ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED")['adjusted_close']
}
saveRDS(df, file = "data.rds")