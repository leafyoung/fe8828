install.packages(c("tidyquant", "Quandl", "fOptions", "fExoticOptions", "dygraph", "forecast"))
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

biorhythm <- function(dob, target = Sys.Date()) {
  dob <- as.Date(dob)
  target <- as.Date(target)
  t <- round(as.numeric(difftime(target, dob)))
  days <- (t - 14) : (t + 14)
  period <- tibble(Date = seq.Date(from = target - 15, by = 1, length.out = 29),
                   Physical = sin (2 * pi * days / 23) * 100,
                   Emotional = sin (2 * pi * days / 28) * 100,
                   Intellectual = sin (2 * pi * days / 33) * 100)
  period <- gather(period, key = "Biorhythm", value = "Percentage", -Date)
  ggplot(period, aes(x = Date, y = Percentage, col = Biorhythm)) +
    geom_line() +
    ggtitle(paste("DoB:", format(dob, "%d/%b/%Y"))) +
    geom_vline(xintercept = as.numeric(target)) +
    theme(legend.position = "bottom")
}

g1 <- biorhythm("1964-01-12", Sys.Date())
g2 <- biorhythm("1971-06-28", Sys.Date())
g3 <- biorhythm("1971-10-29", Sys.Date())
g4 <- biorhythm("1957-08-11", Sys.Date())
grid.arrange(g1, g2, g3, g4, ncol = 2, nrow = 2)

digi_wave <- function(days,up, down){
  cycle <- up+down
  rem <- days %% cycle
  if_else(rem < up, 1, -1)
}

#Test
digi_wave(3,1,2) == 1
digi_wave(5,1,2) == -1

digi_wave(0:6,1,2)
digi_wave(5,1,2) == 1



# Tidyquant/quantmod
library(tidyquant)
getSymbols('SPY', src = 'yahoo', adjusted = TRUE, output.size = 'full')
str(SPY)
head(SPY)
tail(SPY)
symbols <- c("MSFT", "AAPL")
getSymbols(symbols, src = 'yahoo', adjusted = TRUE, from = "2016-01-01")

tibble(Date = index(SPY),as_tibble(coredata(SPY)))
bind_cols(tibble(Date=))

# xts Object
library(xts)
# if df is a data frame.
# Date | V | GS
xts1 <- xts(x=df[, -1, drop = F], order.by = df[1])
# coredata: returns a matrix from xts objects
core_data <- coredata(SPY)
# index: vector of any Date, POSIXct, chron, yearmon, yearqtr, or DateTime classes
index(SPY)

str(SPY)
SPY2003 <- SPY["2003"]
SPY2 <- SPY["2003/2007"]
SPY3 <- SPY["2003-03-01/2007-07-01"]
SPY4 <- SPY["/2007-07-01"] # till
SPY5 <- SPY["2007-07-01/"] # from
SPY6 <- SPY["2007-07-01/", "SPY.High"]
SPY7 <- SPY["2007-07-01/", c("SPY.High", "SPY.Close")]
getSymbols('^RUT',src = 'yahoo',adjusted = TRUE, output.size = 'full')

# dygraph: dynamic graph
getSymbols('RUT', src = 'yahoo', adjusted = TRUE, output.size = 'full')
convert_xts <- function(x){
  bind_cols(tibble(Date = index(x)),as_tibble(coredata(x)))
}
df_RUT <- convert_xts(RUT)
df_SPY <- convert_xts(SPY)
g <- ggplot()+
  geom_line(data = df_RUT, aes(x=Date, y= RUT.Adjusted, color="RUT"))+
  geom_line(data = df_SPY, aes(x=Date, y= SPY.Adjusted*5, color="SPY"))
library(plotly)
ggplotly(g)
library(dygraphs)
dygraph(RUT,main = "Russell 2000") %>%
  dySeries("RUT.Adjusted",label = "Actual")

# Quandl
library(Quandl)
library(ggplot2)
library(tidyverse)
Quandl.api_key(token_qd) # Authenticate your token
# Build vector of currencies
rates <- Quandl(c("FRED/DEXUSAL", "FRED/DEXBZUS", "FRED/DEXUSUK", "FRED/DEXCHUS"),
                start_date="2000-01-01",
                end_date = "2018-11-28")
colnames(rates) <- c("Date", "AUD/USD", "USD/BRL", "GBP/USD", "USD/CNY")
meltdf <- gather(rates, key = "CCY", value = "Rate", -Date)
ggplot(meltdf, aes(x = Date, y = Rate, colour = CCY, group = CCY)) +
  geom_line() +
  scale_colour_manual(values=1:22)+
  ggtitle("Major Currency Exchange Rates in USD") +
  theme_minimal()

# Quandl and forecast
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
                      start_date="2006-01-01", end_date = Sys.Date())
# Have a quick look at our three objects.
str(oil_daily)
str(oil_weekly)
str(oil_monthly)
cat(paste0("daily: ", paste0(range(oil_daily$Date), collapse = ", "), "\n"))
cat(paste0("weekly: ", paste0(range(index(oil_weekly)), collapse = ", "), "\n"))
cat(paste0("monthly: ", paste0(range(index(oil_monthly)), collapse = ", "), "\n"))
# Change index from month to day
head(index(oil_monthly))
index(oil_monthly) <- seq(mdy('01/01/2006'), Sys.Date(), by = 'months')[1:length(oil_monthly)]
# index(oil_monthly) <- seq(mdy('01/01/2006'), (Sys.Date() - 365 * 2), by = 'months')
str(oil_monthly)
head(index(oil_monthly))
dygraph(oil_monthly, main = "Monthly oil Prices")
forebase1 <- oil_weekly[paste0("/", Sys.Date() - 365 * 2)]
forecast1 <- forecast(forebase1, h = 4 * 24)
plot(forecast1, main = "Oil Forecast1")
oil_forecast_data1 <- data.frame(date = seq(last(index(forebase1)),
                                            by = 'week', length.out = 4 * 24 + 1)[-1],
                                 Forecast = forecast1$mean,
                                 Hi_95 = forecast1$upper[,2],
                                 Lo_95 = forecast1$lower[,2])
oil_forecast_xts1 <- xts(oil_forecast_data1[,-1], order.by = oil_forecast_data1[,1])
forebase2 <- oil_weekly[paste0("/", Sys.Date() - 30)]
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

p1 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Width, color = Species)) +
  geom_smooth(method = "lm") +
  geom_point() +
  labs(title = "Petal.Width ~ Sepal.Length")
p2 <- ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
  geom_smooth(method = "lm") +
  geom_point() +
  labs(title = "Petal.Width ~ Petal.Length")
p3 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_smooth(method = "lm") +
  geom_point() +
  labs(title = "Sepal.Width ~ Sepal.Length")
p4 <- ggplot(iris, aes(x = Petal.Length, y = Sepal.Width, color = Species)) +
  geom_smooth(method = "lm") +
  geom_point() +
  labs(title = "Sepal.Width ~ Petal.Length")
grid.arrange(p1, p2, p3, p4, ncol = 2, nrow = 2)

library(caret)

set.seed(123)
trainIndex <- createDataPartition(iris$Species, p = .8,
                                  list = FALSE,
                                  times = 1)
train <- iris[ trainIndex,]
test <- iris[-trainIndex,]
train_x <- select(train, -Species)
train_y <- train$Species
test_x <- select(test, -Species)
test_y <- test$Species

# Cross validation
fitControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 5)
# first run may need to do package installation. Caret
# install.packages("e1071")
# recursive partition = decision tree
dt_fit <- train(Species ~ ., data = train,
                method = "rpart",
                trControl = fitControl,
                preProcess=c("center", "scale"))
dt_fit
plot(dt_fit)
predictions <- predict(dt_fit, test)
confusionMatrix(predictions, test$Species)
# random Forests
rf_fit <- train(Species ~ .,
                data = train,
                method = "ranger")
rf_fit
plot(rf_fit)
predictions <- predict(rf_fit, test)
confusionMatrix(predictions, test$Species)
which(test_y != predictions)
test_y[which(test_y != predictions)]


bank <- read.csv("https://goo.gl/PBQnBt", sep = ";")
unique(bank$y)
bank_fit <- bank %>% select(y,
                            loan,
                            default,
                            housing,
                            poutcome,
                            job,
                            marital) %>%
  mutate_if(is.factor, as.character) %>%
  mutate(y = ifelse(y == "yes", "y", "n"))
str(bank_fit)

# create dummy variables
dummies <- dummyVars("y ~ loan + default + housing + poutcome + job + marital",
                     data = bank_fit, fullRank = TRUE)
# generate data frame of dummy variables
bank_new <- data.frame(predict(dummies, newdata = bank_fit))
# add back y variable to data
bank_new <- bind_cols(bank_fit["y"], bank_new) %>% mutate(y = factor(y))
summary(bank_new)

# library(caret)
set.seed(1234)
trainIndex <- createDataPartition(bank_new$y, p = .8,
                                  list = FALSE,
                                  times = 1)
bank_train <- bank_new[ trainIndex,]
bank_test <- bank_new[-trainIndex,]
featurePlot(x = bank_new[-1],
            y = bank_new$y,
            plot = "density",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x = list(relation="free"),
                          y = list(relation="free")))

featurePlot(x = bank_new[-1],
           y = bank_new$y,
           plot = "density",
           strip=strip.custom(par.strip.text=list(cex=.7)),
           scales = list(x = list(relation="free"),
                         y = list(relation="free")))
train_control <- trainControl(
  method = 'repeatedcv', # k-fold cross validation
  number = 5, # number of folds
  savePredictions = 'final', # saves predictions for optimal tuning parameter
  classProbs = TRUE, # should class probabilities be returned
)
if (FALSE) {
  # Running time is too long. Skip running.
  adaboost_fit <- train(y ~ .,
                        data = bank_train,
                        method='adaboost',
                        tuneLength=2,
                        trControl = train_control)
  adaboost_fit
  predictions <- predict(adaboost_fit, newdata = bank_train)
  confusionMatrix(predictions, bank_train$y)
  predictions <- predict(adaboost_fit, bank_test)
  confusionMatrix(predictions, bank_test$y)
}

