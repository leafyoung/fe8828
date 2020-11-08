library(tidyverse)
library(readr)

#Problem 1
#1.1     10 clients
Account <- data.frame(
  AccountNo = c(1:10),
  Name <- sample(LETTERS, 10, replace= FALSE), 
  Deposit <- sample(1000:2000, 10), 
  Credit <- rep(2000, 10)) %>%
  rename(Name = `Name....sample.LETTERS..10..replace...FALSE.`,
         Deposit = `Deposit....sample.1000.2000..10.`,
         Credit = `Credit....rep.2000..10.`)

save(Account,
     file='/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')




#1.2    3 currencies
Exchange_Rates <- read_csv("/Users/fanwenqing/Downloads/Exchange Rates.csv")

##generate date data for original exchange_rate file
jul = which(is.na(Exchange_Rates$X2) == FALSE)[1]
aug = which(is.na(Exchange_Rates$X2) == FALSE)[2]
sep = which(is.na(Exchange_Rates$X2) == FALSE)[3]
Exchange_Rates <- Exchange_Rates %>%
  mutate(month = rep(7, length(X2)))

for(i in aug:(sep-1)){
  Exchange_Rates$month[i] = 8
}
for(i in sep:length((Exchange_Rates$X2))){
  Exchange_Rates$month[i] = 9
}

time <- c()
for(i in 1: length(Exchange_Rates$X2)){
  time[i] <- paste("2020", Exchange_Rates$month[i], Exchange_Rates$X3[i], sep ="-")
}

Exchange_Rates <- Exchange_Rates %>%
  mutate(Date = as.Date(time)) 




# generate currencies type for data_frame 2
Currency <- c(rep("USD", 92))
Conversion <- c(rep(1, 92))
Date <- seq.Date(from = as.Date("2020/07/01",
                                    format = "%Y/%m/%d"), 
                     by = "day", length.out = 92)

# match actual exchange rate for 3 currencies individually
# a. USD
USD <- data.frame(Currency, Conversion, Date) %>%
  full_join(., Exchange_Rates, by = "Date") %>%
  mutate(Conversion = `S$ Per Unit of US Dollar`)

for(i in 1: 92){
  if(is.na(USD$Conversion[i]) == TRUE){
    USD$Conversion[i] = USD$Conversion[i-1]
  }
}

USD <- USD %>%
  select(Currency, Conversion, Date)

# b. CNY
Currency <- c(rep("CNY", 92))
CNY <- data.frame(Currency, Conversion, Date) %>%
  full_join(., Exchange_Rates, by = "Date") %>%
  mutate(Conversion = `S$ Per 100 Units of Chinese Renminbi`/100)

for(i in 1: 92){
  if(is.na(CNY$Conversion[i]) == TRUE){
    CNY$Conversion[i] = CNY$Conversion[i-1]
  }
}

CNY <- CNY %>%
  select(Currency, Conversion, Date)

# c. SGD
Currency <- c(rep("SGD", 92))
SGD <- data.frame(Currency, Conversion, Date) 

# genenrate the whole exchange rate for data.frame 2
Currency.to.SGD <- rbind(USD, CNY, SGD)  
save(Currency.to.SGD, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata' )

