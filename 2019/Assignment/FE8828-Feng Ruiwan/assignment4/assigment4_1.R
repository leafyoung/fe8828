library(readxl)
library(tidyverse)
library(ggplot2)
library(fOptions)
google <- read_excel("C:/Users/ruiwa/Desktop/google.xlsx", 
                     col_types = c("date", "numeric", "numeric", 
                                   "numeric", "text", "numeric", "numeric"))


#Valuation for call
data <- google %>% dplyr::filter(`Call/Put` == "c") %>% rowwise() %>% summarise(`Open Interest` * (Bid + Ask) / 2)
value_call <- sum(data)
print(value_call)


#Valuation for put
data <- google %>% dplyr::filter(`Call/Put` == "p") %>% rowwise() %>% summarise(`Open Interest` * (Bid + Ask) / 2)
value_put <- sum(data)
print(value_put)


#Valuation for total
data <- google["Open Interest"] * (google["Bid"] + google["Ask"]) / 2
value_total <- sum(data)
print(value_total)


#open interest for in the money
data1 <- google %>% dplyr::filter(`Call/Put` == "c", Strike < Underlying) %>% 
  rowwise() %>% summarise(`Open Interest`)
data2 <- google %>% dplyr::filter(`Call/Put` == "p", Strike > Underlying) %>% 
  rowwise() %>% summarise(`Open Interest`)
openInterest_inthemoney <- sum(data1)+sum(data2)
print(openInterest_inthemoney)


#Volatility Curve
strike <- c()
vol <- c()
data1 <- google %>% dplyr::filter(`Call/Put` == "c" & Strike > Underlying)
for(i in 1:nrow(data1)) {
  strike[i] <- data1$Strike[i]
  vol[i] <- GBSVolatility((data1$Bid[i] + data1$Ask[i]) / 2, "c", 
                          1202.31, data1$Strike[i],
                          as.numeric(as.Date("2019-12-20")-as.Date("2019-10-10"))/365,
                          r = 0.03, b = 0)
} 
data2 <- google %>% dplyr::filter(`Call/Put` == "p" & Strike < Underlying) 
for(i in 1:nrow(data2)) {
  strike[i+nrow(data1)] <- data1$Strike[i]
  vol[i+nrow(data1)] <- GBSVolatility((data2$Bid[i] + data2$Ask[i]) / 2, "p", 
                          data2$Underlying[i], data2$Strike[i],
                          as.numeric(as.Date("2019-12-20")-as.Date("2019-10-10"))/365,
                          r = 0.03, b = 0)
  }
curve<-data.frame(strike, vol)
ggplot(curve, aes(strike, vol)) + geom_point() + geom_smooth(color = "grey")



