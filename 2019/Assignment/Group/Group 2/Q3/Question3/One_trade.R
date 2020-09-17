library(readxl)
library(tidyverse)
library(fOptions)

setwd("E:/gdrive/MFECourse/FE8828/2019/Group/Group 2/Q3/Question3")

df <- read_excel("../web3.xlsx", 
                 col_types = c("date", "numeric", "numeric"))

# Initialize
start_date <- min(df$Date)
end_date <- max(df$Date)
start_price <- df$Close[1]
df <- mutate(df,volatility = VIX/100)
start_volatility <- df$volatility[1]
df <- mutate(df,time_to_M = as.numeric(difftime(as.POSIXct(end_date), as.POSIXct(df$Date, tz="UTC"), units="days")/365))

# Daily Profit and Loss
# Option side
# Vary S and Time everyday
df_opt <-df%>%mutate(premium = 100 * GBSOption(TypeFlag = "p",
                                         S = df$Close,
                                         X = start_price,
                                         Time = time_to_M,
                                         r = 0.8/100, # interest rate
                                         b = 0,
                                         sigma = start_volatility)@price)%>%
  mutate(Option_DoD_PnL = ifelse(df$Date == start_date,
        # On the 1st date, we count the cost of buying the option
          0, # premium * (-1),
          premium - dplyr::lag(premium))) 

# Hedge side
df_opt <- df_opt %>%
    rowwise() %>%
    mutate(delta_hedge = 100 * GBSGreeks("delta", TypeFlag = "p", S=Close, X = start_price , Time = time_to_M, r = 0.8/100, b = 0, sigma = start_volatility )  * (-1)) %>%
    ungroup()%>%
    mutate(Hedging_DoD_Pnl = ifelse(Date == start_date,
                                  0,
                                  dplyr::lag(delta_hedge) * (Close - dplyr::lag(Close))))

# Daily PnL and Final PnL
df_opt <- df_opt%>%
          mutate(daily_PnL = Option_DoD_PnL + Hedging_DoD_Pnl,
                 Option_Final_PnL = cumsum(Option_DoD_PnL),
                 Hedging_Final_PnL = cumsum(Hedging_DoD_Pnl),
                 Final_PnL = Option_Final_PnL + Hedging_Final_PnL,
                 portfolio_value = Close * delta_hedge + premium,
                 return = ifelse(Date == start_date,
                                 0,
                                 daily_PnL/dplyr::lag(portfolio_value)))

# Max Drawdown      
max_drawdown <- 
  {
    xs <- df_opt$Final_PnL
    max(cummax(xs) - cummin(xs))
  }

max_drawdown

# Sharpe ratio
Sharpe_ratio <- (mean(df_opt$return[2:length(df_opt$return)])-0.008/250)/stdev(df_opt$return[2:length(df_opt$return)])
Sharpe_ratio


