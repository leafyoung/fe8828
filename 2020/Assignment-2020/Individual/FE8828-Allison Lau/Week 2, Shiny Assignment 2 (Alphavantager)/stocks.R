library(alphavantager)
library(ggplot2)

av_api_key("70OGL0JJKXIMSMHC")

graph <- function(ticker){
  df_res <- av_get(ticker,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
  
  saveRDS(df_res, file = "/Users/allisonlau/Library/Mobile Documents/com~apple~CloudDocs/NTU /Y4 Masters/Mini Term 2/FE8828 Programming Web Applications/output.rds")
  
  out <- plot(df_res$timestamp, df_res$adjusted_close, xlab = "Date", ylab = "Adjusted Price")
  lines(df_res$timestamp, df_res$adjusted_close)
  return(out)
}


