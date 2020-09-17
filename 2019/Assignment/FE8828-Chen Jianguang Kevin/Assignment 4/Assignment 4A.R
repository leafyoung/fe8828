library(tidyverse)
library(fOptions)
library(readxl)
library(caret)
library(dplyr)
library(ggplot2)


GoogCall <- read_excel("C:/Users/kevin/Desktop/GoogCall.xlsx", 
                       col_types = c("date", "numeric", "numeric", 
                      "numeric", "text", "numeric", "numeric"))

GoogPut <- read_excel("C:/Users/kevin/Desktop/GoogPut.xlsx", 
                      col_types = c("date", "numeric", "numeric", 
                      "numeric", "text", "numeric", "numeric"))

GoogCallPut <- bind_rows(GoogCall, GoogPut)

gcp1 <- mutate(GoogCallPut, value = `Open Interest` * (Bid + Ask)/2)

sum(gcp1$value)
# Total Options value is $250,600.
gcp2 <- group_by(gcp1, CallOrPut) %>% 
        summarise (total_value = sum(value))
# Total Calls value is $149800.70.
# Total Puts value is $100799.20.

moneyopt <- group_by(gcp1, CallOrPut == "Call" & Strike < Underlying | CallOrPut == "Put" & Strike > Underlying) %>%
              summarise(totaloi = sum(`Open Interest`))
# Total Open Interest for all options that are in the money is 1163.

gcp3 <- dplyr::filter(gcp1, CallOrPut == "Call" & Strike > Underlying | CallOrPut == "Put" & Strike < Underlying)
# Filter data, Calls for Strike > Price, Puts for Strike < Price

gcp3$CallOrPut <- sub("Call", "c", gcp3$CallOrPut)
gcp3$CallOrPut <- sub("Put", "p", gcp3$CallOrPut)
gcp4 <- mutate(gcp3, time = as.numeric((as.Date("2019-12-20") - as.Date("2019-10-06")))/365)
gcp5 <- mutate(gcp4, price = (Bid + Ask)/2)
# Editing data for smooth input into function GBSVolatility

vol <- function(x) GBSVolatility(as.numeric(x["price"]), as.character(x["CallOrPut"]), as.numeric(x["Underlying"]),    
                                 as.numeric(x["Strike"]), as.numeric(x["time"]), r = 0.03, b = 0.00)
gcp6 <- mutate(gcp5, vol = apply(gcp5, 1, vol))

gcp6 %>%
  ggplot(aes(x=Strike, y=vol)) +
  geom_point(aes(size = 20), alpha = 1/2, color = "red") +
  geom_smooth(se=F)

                 
