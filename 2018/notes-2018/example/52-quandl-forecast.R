# 52-quandl-forecast.R
# Quandl and Forecast
# Forecast using state space models and automatic ARIMA modelling.

library(Quandl)
library(dplyr)
library(xts)
library(lubridate)
library(forecast)
library(dygraphs)

# Start with daily data. Note that "type = raw" will download a data frame.
oil_daily <- Quandl("FRED/DCOILWTICO", type = "raw", collapse = "daily",  
                    start_date="2006-01-01", end_date=Sys.Date())
# Now weekely and let's use xts as the type.
oil_weekly <- Quandl("FRED/DCOILWTICO", type = "xts", collapse = "weekly",
                     start_date="2006-01-01", end_date = Sys.Date())
oil_monthly <- Quandl("FRED/DCOILWTICO", type = "xts", collapse = "monthly",  
                      start_date="2006-01-01", end_date = "2017-02-28")

# Have a quick look at our three  objects. 
str(oil_daily)
str(oil_weekly)
str(oil_monthly)

# Change index from month to day
head(index(oil_monthly))
index(oil_monthly) <- seq(mdy('01/01/2006'), mdy('02/28/2017'), by = 'months')
str(oil_monthly)
head(index(oil_monthly))

dygraph(oil_monthly, main = "Monthly oil Prices")

forebase1 <- oil_weekly["/2018-10-28"]
forecast1 <- forecast(forebase1, h = 4 * 24)

plot(forecast1, main = "Oil Forecast1")

oil_forecast_data1 <- data.frame(date = seq(last(index(forebase1)), 
                                           by = 'week', length.out = 4 * 24 + 1)[-1],
                                Forecast = forecast1$mean,
                                Hi_95 = forecast1$upper[,2],
                                Lo_95 = forecast1$lower[,2])

oil_forecast_xts1 <- xts(oil_forecast_data1[,-1], order.by = oil_forecast_data1[,1])

forebase2 <- oil_weekly["/2017-09-01"]
forecast2 <- forecast(forebase2, h = 4 * 3)

plot(forecast2, main = "Oil Forecast2")

oil_forecast_data2 <- data.frame(date = seq(last(index(forebase2)), 
                                            by = 'week', length.out = 4 * 3 + 1)[-1],
                                 Forecast2 = forecast2$mean,
                                 Hi_95_2 = forecast2$upper[,2],
                                 Lo_95_2 = forecast2$lower[,2])

oil_forecast_xts2 <- xts(oil_forecast_data2[,-1], order.by = oil_forecast_data2[,1])

# Combine the xts objects with cbind.
oil_combined_xts <- merge(oil_weekly, oil_forecast_xts1, oil_forecast_xts2)

# Add a nicer name for the first column.
colnames(oil_combined_xts)[1] <- "Actual"

dygraph(oil_combined_xts, main = "Oil Prices: Historical and Forecast") %>%
  dySeries("Actual", label = "Actual") %>%
  dySeries(c("Lo_95", "Forecast", "Hi_95")) %>%
  dySeries(c("Lo_95_2", "Forecast2", "Hi_95_2"))
