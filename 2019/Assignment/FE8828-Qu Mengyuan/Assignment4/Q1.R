library(fOptions)
library(tidyverse)
library(timeDate)
library(timeSeries)
library(fBasics)
library(readxl)

# Step 1 Copy the options data
GOOG_Option <- read_excel("GOOG Option.xlsx", sheet = "call", col_types = c("text", "text", "numeric", "numeric", "numeric","numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
Call_Option <- mutate(GOOG_Option,Call_Put = "Call",Expiry = as.Date("2019-12-20"),Underlying = 1187.83)
GOOG_Option <- read_excel("GOOG Option.xlsx", sheet = "put", col_types = c("text", "text", "numeric", "numeric", "numeric","numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
Put_Option <- mutate(GOOG_Option,Call_Put = "Put",Expiry = as.Date("2019-12-20"),Underlying = 1187.83)
Option <- bind_rows(Call_Option,Put_Option)

# Step 2 Count the total valuation
Option <- mutate(Option,Value = `Open Interest`*(Bid+Ask)/2)
  # call alone and put alone
Option %>% group_by(Call_Put) %>% summarise(Total_value = sum(Value))
  # call and put
Option %>% summarise(Total_value = sum(Value))

# Step 3.1 Find those in the money
in_the_money <- dplyr::filter(Option,(Call_Put =="Call" & Strike < Underlying)|(Call_Put =="Put" & Strike > Underlying))
# Step 3.2 total Open Interest
sum(in_the_money['Open Interest'])

# Step 4 Plot the volatility curve
volSmile <- dplyr::filter(Option,(Call_Put =="Call" & Strike > Underlying)|(Call_Put =="Put" & Strike < Underlying))
Time <- as.numeric((as.Date("2019-12-20") - as.Date("2019-10-5")))/365
volSmile <- volSmile %>% 
  mutate(type = ifelse(Call_Put =="Call","c","p"),Implied_Volatility = 0)

for(i in 1:nrow(volSmile)) {
  df <- transmute(volSmile[i,,drop = FALSE],Implied_Volatility = GBSVolatility(`Last Price`, type, 1234.04, Strike, Time, r = 0.03, b = 0))
  volSmile[i,ncol(volSmile)] <- as.numeric(df[1,ncol(df),drop = FALSE])
}

ggplot(volSmile,aes(x = Strike, y = Implied_Volatility)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE)
