library(readxl)
library(tidyverse)
library(fOptions)
df <- read_excel("web3.xlsx", 
                   col_types = c("date", "numeric", "numeric"))
start_date <- min(df$Date)
end_date <- max(df$Date)
start_price <- df$Close[1]
df <- mutate(df,volatility = VIX/100)
start_volatility <- df$volatility[1]
df <- mutate(df,time_to_M = as.numeric(difftime(as.POSIXct(end_date), as.POSIXct(df$Date, tz="UTC"), units="days")/365))
# Vary S and Time everyday
df_opt <- mutate(df, premium = 100 * GBSOption(TypeFlag = "c",
                                         S = df$Close,
                                         X = start_price,
                                         Time = time_to_M,
                                         r = 0.8/100, # interest rate
                                         b = 0,
                                         sigma = start_volatility)@price) %>%
  ungroup
tem <- diff(df_opt$premium)
df_opt <- mutate(df_opt, Option_DoD_PnL = c(-df_opt$premium[1], tem))
df_opt$Option_DoD_PnL[24] = 0
tem2 <- c(0,diff(df_opt$Close))
df_opt <- df_opt %>%
    rowwise() %>%
    mutate(delta_hedge = 100 * GBSGreeks("delta", TypeFlag = "c", S=Close, X = start_price , Time = time_to_M, r = 0.8/100, b = 0, sigma = start_volatility )  * (-1)) %>%
    ungroup()%>%
    mutate(Hedging_DoD_Pnl = delta_hedge * tem2)

df_opt['daily_PnL'] <- df_opt$Option_DoD_PnL+df_opt$Hedging_DoD_Pnl
df_opt['Option_Final_PnL'] <- cumsum(df_opt$Option_DoD_PnL)
df_opt['Hedging_Final_PnL'] <- cumsum(df_opt$Hedging_DoD_Pnl)
df_opt['Final_PnL'] <- df_opt['Option_Final_PnL']+df_opt['Hedging_Final_PnL']
df_opt['delta_Value'] <- df_opt$delta_hedge * df_opt$Close
df_opt['portfolio_value'] <- df_opt$delta_Value + df_opt$premium
df_opt['return'] <- df_opt$daily_PnL/df_opt$portfolio_value
#df_opt['annual_return'] <- df_opt['return']

max_drawdown <- 
  {
    xs <- df_opt$Final_PnL
    max(cummax(xs) - cummin(xs))
  }
  
Sharpe_ratio <- (mean(df_opt$return[1:23])-0.008)/stdev(df_opt$return[1:23])


