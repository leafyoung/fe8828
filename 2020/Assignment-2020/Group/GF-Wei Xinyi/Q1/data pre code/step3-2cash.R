################################################
#balance - deposit, withdrawl, interest

#deposit
deposit <- data.frame()
save(deposit, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/deposit.Rdata')

for(i in 1:10){
  
  rm(list = ls())
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata')
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/deposit.Rdata')
  
  
# july deposit
    dep.time7 <- sample(1:2, 1)
    Date2 <- sample(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                             by = "day", length.out = 31), dep.time7) 
    deposit.sep.jul <- data.frame(Date = Date2,
                              TransactionType = c(rep("Deposit", dep.time7)),
                              Amount = sample(1000:2000, dep.time7),
                              Currency = "SGD",
                              AccountNo = i,
                              month = 7) 
# august deposit  
    dep.time8 <- sample(1:2, 1)
    rm(Date2)
    Date2 <- sample(seq.Date(from = as.Date("2020/08/01", format = "%Y/%m/%d"),
                             by = "day", length.out = 31), dep.time8) 
    deposit.sep.aug <- data.frame(Date = Date2,
                                  TransactionType = c(rep("Deposit", dep.time8)),
                                  Amount = sample(1000:2000, dep.time8),
                                  Currency = "SGD",
                                  AccountNo = i,
                                  month = 8) 
    
# sept deposit  
    dep.time9 <- sample(1:2, 1)
    rm(Date2)
    Date2 <- sample(seq.Date(from = as.Date("2020/09/01", format = "%Y/%m/%d"),
                             by = "day", length.out = 30), dep.time9) 
    deposit.sep.sept <- data.frame(Date = Date2,
                                  TransactionType = c(rep("Deposit", dep.time9)),
                                  Amount = sample(1000:2000, dep.time9),
                                  Currency = "SGD",
                                  AccountNo = i,
                                  month = 9)     
    
    deposit <- deposit %>%
      rbind(., deposit.sep.jul) %>%
      rbind(., deposit.sep.aug) %>%
      rbind(., deposit.sep.sept) 
    
    save(deposit, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/deposit.Rdata')
}




#####################################3
#withdraw
withdraw <- data.frame()
save(withdraw, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/withdraw.Rdata')

for(i in 1:10){
  
  rm(list = ls())
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata')
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/withdraw.Rdata')
  
  
  # july withdraw
  draw.time7 <- sample(31, 1)
  Date2 <- sample(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 31), draw.time7) 
  draw.sep.jul <- data.frame(Date = Date2,
                                Currency = sample(c("SGD","CNY", "USD"), draw.time7, replace = T),
                                Amount = -abs(rlnorm(draw.time7,0,3)),
                                TransactionType= "Withdraw",
                                AccountNo = i,
                                month = 7) 
  # august withdraw 
  draw.time8 <- sample(31, 1)
  Date2 <- sample(seq.Date(from = as.Date("2020/08/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 31), draw.time8) 
  draw.sep.aug <- data.frame(Date = Date2,
                             Currency = sample(c("SGD","CNY", "USD"), draw.time8, replace = T),
                             Amount = -abs(rlnorm(draw.time8,0,3)),
                             TransactionType= "Withdraw",
                             AccountNo = i,
                             month = 8) 
  
  # sept withdraw  
  draw.time9 <- sample(30, 1)
  Date2 <- sample(seq.Date(from = as.Date("2020/09/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 30), draw.time9) 
  draw.sep.sept <- data.frame(Date = Date2,
                             Currency = sample(c("SGD","CNY", "USD"), draw.time9, replace = T),
                             Amount = -abs(rlnorm(draw.time9,0,3)),
                             TransactionType= "Withdraw",
                             AccountNo = i,
                             month = 9)   
  
  withdraw <- withdraw %>%
    rbind(., withdraw.sep.jul) %>%
    rbind(., withdraw.sep.aug) %>%
    rbind(., withdraw.sep.sept) 
  
  save(withdraw, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/withdraw.Rdata')
}


#####################################3
#interest
interest.jul <- data.frame(
  Date = c(as.Date("2020-07-31")),
  Currency = rep("SGD", 10),
  Amount = 0,
  TransactionType= "Interest",
  AccountNo = c(1:10),
  month = 7
)

interest.aug <- data.frame(
  Date = c(as.Date("2020-08-31")),
  Currency = rep("SGD", 10),
Amount = 0,
TransactionType= "Interest",
AccountNo = c(1:10),
month = 8
)

interest.sept <- data.frame(
  Date = c(as.Date("2020-09-30")),
  Currency = rep("SGD", 10),
Amount = 0,
TransactionType= "Interest",
AccountNo = c(1:10),
month = 9
)

interest <- rbind(interest.jul, interest.aug, interest.sept) 
save(interest, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/interest.Rdata')



###################
#merge deposit, interest, withdraw

rm(list = ls())
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/deposit.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/withdraw.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/interest.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/credit.Rdata')

balance <- data.frame(
  Date = seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                   by = "day", length.out = 92),
  balance = 0
)

cash <- rbind(deposit, interest, withdraw) %>%
  arrange(AccountNo, Date) 

save(cash, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/cash.Rdata')



# for individual account
Balance <- data.frame()
save(Balance, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/balance.Rdata')



cash.sep <- cash %>%
  filter(AccountNo == 1) %>%
  full_join(., balance, by = "Date") %>%
  arrange(Date) %>%
  full_join(Currency.to.SGD, by = c("Date", "Currency"))

for(i in 1: length(cash.sep$Date)){
  cash.sep$month[i] = month(cash.sep$Date[i])
  if(is.na(cash.sep$Currency[i]) == TRUE){
    cash.sep$Currency[i] = "SGD"
    cash.sep$Conversion[i] = 0
    cash.sep$Amount[i] = 0
    cash.sep$AccountNo[i] = 1
  }
}

cash.sep <- cash.sep[1:94, ]
cash.sep$balance[1] = Account$Deposit[1] + cash.sep$Amount[1]*cash.sep$Conversion[1]

for(i in 2 : length(cash.sep$Date)){
  cash.sep$balance[i] = cash.sep$balance[i-1] + cash.sep$Amount[i]*cash.sep$Conversion[i]
}

for(i in 2:length(cash.sep$Date)){
  #calculte withdraw
  amount.max = 
    cash.sep$Credit[i-1]/cash.sep$Conversion[i]
  while(abs(cash.sep$Amount[i]) > amount.max){
    cash.sep$Amount[i] = -(rlnorm(1,0,3))
  }
  
  if(abs(cash.sep$Amount[i]) <= amount.max){
    cash.sep$Credit[i] = 
      cash.sep$Credit[i-1] + cash.sep$Amount[i]*cash.sep$Conversion[i]
  }
}

cash.sep <- cash.sep %>%
  mutate(interest = balance*0.005/360) %>%
  group_by(month) %>%
  mutate(cuminterest = cumsum(interest))

interestday <- which(cash.sep$TransactionType == "Interest")
cash.sep$balance[interestday[1]] = cash.sep$balance[interestday[1]] + cash.sep$cuminterest[interestday[1]]
for(i in (interestday[1]+1):(interestday[2])){
  cash.sep$balance[i] = cash.sep$balance[i] + cash.sep$Amount[i]*cash.sep$Conversion[i]
}

cash.sep$balance[interestday[2]] = cash.sep$balance[interestday[2]] + cash.sep$cuminterest[interestday[2]]
for(i in (interestday[2]+1):(interestday[3])){
  cash.sep$balance[i] = cash.sep$balance[i] + cash.sep$Amount[i]*cash.sep$Conversion[i]
}

cash.sep$balance[interestday[3]] = cash.sep$balance[interestday[3]] + cash.sep$cuminterest[interestday[3]]

Balance <- Balance %>%
  rbind(., cash.sep)

save(Balance, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/interest.Rdata')





















