library(Quandl)
library(dplyr)
library(xts)
library(lubridate)
library(forecast)
library(dygraphs)

# Start with daily data. Note that "type = raw" will download a data frame.
oil_daily <- Quandl("FRED/DCOILWTICO", type = "raw", collapse = "daily",  
                    start_date="2006-01-01", end_date="2017-02-28")
# Now weekely and let's use xts as the type.
oil_weekly <- Quandl("FRED/DCOILWTICO", type = "xts", collapse = "weekly",  
                     start_date="2006-01-01", end_date="2017-02-28")
# And monthly using xts as the type.
oil_monthly <- Quandl("FRED/DCOILWTICO", type = "xts", collapse = "monthly",  
                      start_date="2006-01-01", end_date="2017-02-28")

# Have a quick look at our three  objects. 
str(oil_daily)

## 'data.frame':    2809 obs. of  2 variables:
##  $ DATE : Date, format: "2017-02-28" "2017-02-27" ...
##  $ VALUE: num  54 54 54 54.5 53.6 ...
##  - attr(*, "freq")= chr "daily"

str(oil_weekly)

## An 'xts' object on 2006-01-08/2017-03-05 containing:
##   Data: num [1:583, 1] 64.2 63.9 68.2 67.8 65.4 ...
##   Indexed by objects of class: [Date] TZ: UTC
##   xts Attributes:  
##  NULL

str(oil_monthly)

## An 'xts' object on Jan 2006/Feb 2017 containing:
##   Data: num [1:134, 1] 67.9 61.4 66.2 71.8 71.4 ...
##   Indexed by objects of class: [yearmon] TZ: 
##   xts Attributes:  
##  NULL

index(oil_monthly) <- seq(mdy('01/01/2006'), mdy('02/01/2017'), by = 'months')
head(index(oil_monthly))

dygraph(oil_monthly, main = "Monthly oil Prices")

oil_6month <- forecast(oil_monthly, h = 6)

oil_6month

plot(oil_6month, main = "Oil Forecast")

oil_forecast_data <- data.frame(date = seq(mdy('03/01/2017'), 
                                           by = 'months', length.out = 6),
                                Forecast = oil_6month$mean,
                                Hi_95 = oil_6month$upper[,2],
                                Lo_95 = oil_6month$lower[,2])

head(oil_forecast_data)

oil_forecast_xts <- xts(oil_forecast_data[,-1], order.by = oil_forecast_data[,1])

# Combine the xts objects with cbind.
oil_combined_xts <- cbind(oil_monthly, oil_forecast_xts)

# Add a nicer name for the first column.
colnames(oil_combined_xts)[1] <- "Actual"

# Have a look at both the head and the tail of our new xts object. Make sure the
# NAs are correct.
head(oil_combined_xts)

##            Actual Forecast Hi_95 Lo_95
## 2006-01-01  67.86       NA    NA    NA
## 2006-02-01  61.37       NA    NA    NA
## 2006-03-01  66.25       NA    NA    NA
## 2006-04-01  71.80       NA    NA    NA
## 2006-05-01  71.42       NA    NA    NA
## 2006-06-01  73.94       NA    NA    NA

tail(oil_combined_xts)

##            Actual Forecast    Hi_95    Lo_95
## 2017-03-01     NA 53.99987 63.88081 44.11894
## 2017-04-01     NA 53.99987 68.00333 39.99642
## 2017-05-01     NA 53.99987 71.18763 36.81212
## 2017-06-01     NA 53.99987 73.88973 34.11002
## 2017-07-01     NA 53.99987 76.28590 31.71385
## 2017-08-01     NA 53.99987 78.46635 29.53340

dygraph(oil_combined_xts, main = "Oil Prices: Historical and Forecast") %>%
  # Add the actual series
  dySeries("Actual", label = "Actual") %>%
  # Add the three forecasted series
  dySeries(c("Lo_95", "Forecast", "Hi_95"))
