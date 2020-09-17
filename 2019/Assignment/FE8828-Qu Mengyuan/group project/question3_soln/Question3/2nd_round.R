library(readxl)
library(tidyverse)
library(fOptions)
library(xts)
vol <- read_excel("C:/Users/Administrator/Desktop/VXAZNCLS.xls", 
                  sheet = "Sheet1")
close <- read_excel("C:/Users/Administrator/Desktop/VXAZNCLS.xls", 
                    sheet = "Sheet2", col_types = c("date", 
                                                    "numeric"))
df <- left_join(close,vol,by = c("Date"="observation_date"))
df <- mutate(df, month = as.numeric(substring(df$Date,6,7)))
max_drawdown <- rep(0,12)
sharpe_ratio <- rep(0,12)
type <- c("c","c","p","c","c","p","c","c","c","p","p","p")
df1 <- dplyr::filter(df, month == 0)
cal <- function(Type, Sp, maturity, sig){
  Str <- Sp
  for(jj in round(Sp-100):round(Sp+100)){
    if( (GBSGreeks("delta", TypeFlag = Type, S=Sp, X = jj , 
                 Time = maturity, r = 0.8/100, b = 0, sigma = sig ) >= 0.245)&(
                   GBSGreeks("delta", TypeFlag = Type, S=Sp, X = jj , 
                             Time = maturity, r = 0.8/100, b = 0, sigma = sig ) <= 0.255))
                   {
      Str <- jj
    }
  }
  return(Str)
}
  for(ii in 1:12){
  df_sub <- dplyr::filter(df, month == ii)
  start_date <- min(df_sub$Date)
  end_date <- max(df_sub$Date)
  start_price <- df_sub$Close[1]
  df_sub <- mutate(df_sub,volatility = VXAZNCLS/100)
  start_volatility <- df_sub$volatility[1]
  df_sub <- mutate(df_sub,time_to_M = as.numeric(difftime(as.POSIXct(end_date), as.POSIXct(df_sub$Date, tz="UTC"), 
                                                          units="days")/365))
  
  implied_strike <- cal(type[ii],start_price,df_sub$time_to_M[1],start_volatility)
  df_sub <-df_sub%>%mutate(premium = 100 * GBSOption(TypeFlag = type[ii],
                                                     S = df_sub$Close,
                                                     X = implied_strike,
                                                     Time = time_to_M,
                                                     r = 0.8/100, # interest rate
                                                     b = 0,
                                                     sigma = start_volatility)@price)%>%
    mutate(Option_DoD_PnL = ifelse(df_sub$Date == start_date,
                                   # On the 1st date, we count the cost of buying the option
                                   premium * (-1),
                                   premium - dplyr::lag(premium))) 
  
  
  df_sub <- df_sub %>%
    rowwise() %>%
    mutate(delta_hedge = 100 * GBSGreeks("delta", TypeFlag = type[ii], S=Close, X = implied_strike , Time = time_to_M, 
                                         r = 0.8/100, b = 0, sigma = start_volatility )  * (-1)) %>%
    ungroup()%>%
    mutate(Hedging_DoD_Pnl = ifelse(Date == start_date,
                                    0,
                                    dplyr::lag(delta_hedge) * (Close - dplyr::lag(Close))))
  
  df_sub <- df_sub%>%
    mutate(daily_PnL = Option_DoD_PnL + Hedging_DoD_Pnl,
           Option_Final_PnL = cumsum(Option_DoD_PnL),
           Hedging_Final_PnL = cumsum(Hedging_DoD_Pnl),
           Final_PnL = Option_Final_PnL + Hedging_Final_PnL,
           portfolio_value = Close * delta_hedge + premium,
           return = ifelse(Date == start_date,
                           0,
                           daily_PnL/dplyr::lag(portfolio_value)))
  df1 <- bind_rows(df1,df_sub)
  
  max_drawdown[ii] <- 
    {
      xs <- df_sub$Final_PnL
      max(cummax(xs) - cummin(xs))
    }
  
  sharpe_ratio[ii] <- (mean(df_sub$return[2:length(df_sub$return)])-0.008/250)/stdev(df_sub$return[2:length(df_sub$return)])
}