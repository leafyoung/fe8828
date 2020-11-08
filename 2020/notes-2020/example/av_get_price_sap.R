library(alphavantager)

av_api_key("QWM66H05ENYFRDPO")

df_intra <- av_get(symbol = "MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "15min", outputsize = "full")
av_get("MSFT", av_fun = "TIME_SERIES_DAILY_ADJUSTED")
df_spy <- av_get("SPY", av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="full")
tail(av_get(av_fun = "SECTOR"))

df_res <- tryCatch({
  df_res <- av_get("SPYsdf", av_fun = "TIME_SERIES_DAILY_ADJUSTED")
  df_res
}, error = function(e) {
  NA
})

is.na(df_res)


av_get("MSFT", av_fun = "OVERVIEW")

av_get("SPY", av_fun = "TIME_SERIES_DAILY_ADJUSTED")

# https://www.sectorspdr.com/sectorspdr/sectors

tickers <- c('XLB', 'XLC', 'XLE', 'XLF', 'XLI', 'XLK', 'XLP', 'XLU', 'XLV', 'XLY', 'XLRE')
tickers <- c('SPY')
for (tt in tickers) {
  df_xlc <- av_get(tt, av_fun = "TIME_SERIES_DAILY_ADJUSTED", outputsize="full")
  saveRDS(df_xlc, paste0("E:/Dropbox/MFE/FE8828/2020/notes-2020/example/spdr/",tt,".Rds"))
  cat(paste(tt,min(df_xlc$timestamp),max(df_xlc$timestamp),"\n"))
}

library(conflicted)
conflict_prefer('lag','dplyr')
conflict_prefer('filter','dplyr')
library(tidyverse)

df_xle <- readRDS(paste0("E:/Dropbox/MFE/FE8828/2020/notes-2020/example/spdr/XLE.Rds"))
df_xlk <- readRDS(paste0("E:/Dropbox/MFE/FE8828/2020/notes-2020/example/spdr/XLK.Rds"))

tibble(xlk_ret = tail(log(df_xlk$adjusted_close / lag(df_xlk$adjusted_close)),-1),
       xle_ret = tail(log(df_xle$adjusted_close / lag(df_xle$adjusted_close)),-1)) %>% {
         ggplot(., aes(xlk_ret, xle_ret)) +
           geom_point(colour = "grey60") +
           geom_density2d(size = 1, colour = "black") +
           geom_point(data = tail(., 250), colour = "blue", alpha = 0.7)
       }


tibble(xlc_ret = tail(log(df_xlc$adjusted_close / lag(df_xlc$adjusted_close)),-1),
       xle_ret = tail(log(df_xle$adjusted_close / lag(df_xle$adjusted_close)),-1)) %>% 
  ggplot(., aes(xlc_ret, xle_ret)) +
  geom_point(colour = "grey60") +
  geom_density2d(size = 1, colour = "black")

tibble(xlc_ret = tail(log(df_xlc$adjusted_close / lag(df_xlc$adjusted_close)),-1),
       xlv_ret = tail(log(df_xlv$adjusted_close / lag(df_xlv$adjusted_close)),-1)) %>% 
  ggplot(., aes(xlc_ret, xlv_ret)) +
  geom_point(colour = "grey60") +
  geom_density2d(size = 1, colour = "black")

av_get("SPY", av_fun = "GLOBAL_QUOTE")

GLOBAL_QUOTE

library(tidyverse)

sap_500 <- read_csv("https://raw.githubusercontent.com/leosmigel/analyzingalpha/master/sp500-historical-components-and-changes/sp500_history.csv")


