rm(list = ls())
library(lubridate)

#step 3
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata')

#spend - credit
Date1 <- rep(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                   by = "day", length.out = 92),10)
TransactionType1 <- c(rep("Spend", 920))
x <- c("USD", "CNY", "SGD")
Currency1 <- sample(x,size=920,replace=T)
Amount1 <- rlnorm(920,0,3)
Credit1 <- rep(2000, 920)
AccountNo1 <- c(rep(1, 92), rep(2, 92), rep(3, 92), rep(4, 92),
                 rep(5, 92), rep(6, 92), rep(7, 92), rep(8, 92),
                 rep(9, 92), rep(10,92)
  )
  
spend.credit <- data.frame(Date = Date1, 
                           TransactionType = TransactionType1, 
                           AccountNo = AccountNo1,
                            Currency = Currency1, 
                           Amount = Amount1, 
                           Credit = Credit1) %>%
  mutate(Amount = -Amount) %>%
  full_join(., Currency.to.SGD, by = c("Date", "Currency")) %>%
  mutate(month = month(Date))

y <- seq(1, 829, by = 92)
for(p in y){
  spend.credit$Credit[p] = 2000 + spend.credit$Amount[p] * spend.credit$Conversion[p]
  
  for(i in 1:91){
    #calculte credit
    amount.max = ifelse(
      spend.credit$Currency[p+i] == "SGD",
      spend.credit$Credit[p+i-1]/(1.01 * spend.credit$Conversion),
      spend.credit$Credit[p+i-1]/(1.02 * spend.credit$Conversion)
    )
    if(abs(spend.credit$Amount[p+i]) > amount.max){
      spend.credit$Amount[p+i] = -(rlnorm(1,0,3))
    }
    spend.credit$Credit[p+i] = ifelse(
      spend.credit$Currency[p+i] == "SGD",
      spend.credit$Credit[p+i-1] + spend.credit$Amount[p+i]*1.01*spend.credit$Conversion,
      spend.credit$Credit[p+i-1] + spend.credit$Amount[p+i]*1.02* spend.credit$Conversion
    )}
}

  
################################################
#balance - deposit, withdrawl, interest

#deposit
deposit <- data.frame()
for(i in 1:10){
  dep.time <- sample(1:2, 1)
  Date2 <- sample(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 31), dep.time) 
  deposit.sep <- data.frame(Date = Date2,
                        TransactionType <- c(rep("Deposit", dep.time)),
                        Amount = sample(1000:2000, dep.time),
                        Currency = "SGD",
                        AccountNo = i) %>%
    rename(TransactionType = 'TransactionType....c.rep..Deposit...dep.time..')
  deposit <- deposit %>%
    rbind(., deposit.sep)
}


for(i in 1:10){
  dep.time <- sample(1:2, 1)
  Date3 <- sample(seq.Date(from = as.Date("2020/08/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 31), dep.time) 
  
  deposit2.sep <- data.frame(Date = Date3,
                            TransactionType <- c(rep("Deposit", dep.time)),
                            Amount = sample(1000:2000, dep.time),
                            Currency = "SGD",
                            AccountNo = i) %>%
    rename(TransactionType = 'TransactionType....c.rep..Deposit...dep.time..')
  deposit <- deposit %>%
    rbind(., deposit2.sep)
}

for(i in 1:10){
  dep.time <- sample(1:2, 1)
  Date4 <- sample(seq.Date(from = as.Date("2020/09/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 30), dep.time) 
  
  deposit3.sep <- data.frame(Date = Date4,
                             TransactionType <- c(rep("Deposit", dep.time)),
                             Amount = sample(1000:2000, dep.time),
                             Currency = "SGD",
                             AccountNo = i) %>%
    rename(TransactionType = 'TransactionType....c.rep..Deposit...dep.time..')
  deposit <- deposit %>%
    rbind(., deposit3.sep) %>%
    arrange(Date, AccountNo)
}


cash <- data.frame(
  Date = Date1,
  AccountNo = AccountNo1,
  balance = AccountNo1
) 

for(i in 1: length(cash$Date)){
  for(j in 1:10){
    if(cash$AccountNo[i] == j){
      cash$balance[i] = Account$Deposit[j]
    }
  }
}

cash <- cash %>% 
  full_join(., deposit, by = c("Date","AccountNo")) 

for(j in y){
  for(i in 1:91){
    if(is.na(cash$Amount[i+j]) == TRUE){
      cash$Amount[i+j] = 0
    }
    cash$balance[i+j] = cash$balance[i+j-1] +cash$Amount[i+j]
  }
}
 


#withdrawl
withdraw <- data.frame()
for(i in 1:10){
  withdraw.time <- sample(1:31, 1)
  sample(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                  by = "day", length.out = 31), dep.time) 
  Date3 <- sample(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                           by = "day", length.out = 31), withdraw.time)
  TransactionType3 <- c(rep("Withdraw", withdraw.time))
  Currency3 = sample(c("USD", "CNY", "SGD"), 
                    size = withdraw.time, replace = T)
  Amount3 = -abs(rlnorm(withdraw.time,0,3))
  
  withdraw.sep <- data.frame(Date = sample(seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                                              by = "day", length.out = 31), withdraw.time),
                        TransactionType = TransactionType3,
                        Currency = Currency3,
                        Amount = Amount3,
                        AccountNo = i)
  
  withdraw <- rbind(withdraw, withdraw.sep)
}

withdraw <- withdraw%>%
  mutate(balance = 0) %>%
  rbind(., cash) %>%
  arrange(AccountNo, Date) %>%
  full_join(., Currency.to.SGD)

withdraw <- withdraw %>%
  distinct() %>%
  filter(is.na(AccountNo) == FALSE)

freq <- c()
freq2 <- c()
freq2[1] = 1
for(i in 1:10){
  freq[i] = sum(withdraw$AccountNo == i)
  freq2[i+1] =freq[i] + freq2[i]
}
freq2 <- freq2[1:10]

for(i in freq2){
  withdraw$balance[i] = Account$Deposit[which(freq2 == i)]
}

interest <- data.frame(
  Date = rep(c(as.Date("2020-07-31"), as.Date("2020-08-31"), as.Date("2020-09-30")),10),
  AccountNo = c(rep(1, 3), rep(2, 3), rep(3, 3), rep(4, 3),
                 rep(5, 3), rep(6, 3), rep(7, 3), rep(8, 3),
                 rep(9, 3), rep(10, 3)),
  TransactionType  = rep("Interest", 30),
  Currency = rep("SGD", 30),
  Conversion = rep(1, 30),
  balance = rep(0, 30),
  Amount = rep(0, 30)
) 

withdraw <- rbind(withdraw, interest) %>%
  arrange(AccountNo, Date) %>%
  distinct() 

for(i in 1: length(withdraw$Date)){
  if(is.na(withdraw$Amount[i]) == TRUE){
    withdraw$Amount[i] = 0
  }
  if(is.na(withdraw$Conversion[i]) == TRUE){
    withdraw$Conversion[i] = 0
  }
}


freq2[1] = 1
for(i in 1:10){
  freq[i] = sum(withdraw$AccountNo == i)
  freq2[i+1] =freq[i] + freq2[i]
}
freq2 <- freq2[1:10]


for(j in freq2){
  if(withdraw$TransactionType == "Withdraw"){
    withdraw$balance[j] = ifelse(
      withdraw$Currency[j] == "SGD",
      withdraw$balance[j] + withdraw$Amount[j]*withdraw$Conversion[j]*1.01,
      withdraw$balance[j] + withdraw$Amount[j]*withdraw$Conversion[j]*1.02)
  }else{
    withdraw$balance[j] + withdraw$Amount[j]*withdraw$Conversion[j]
  }
}

withdraw <- withdraw %>%
  mutate(charge = 1.02) 

for(i in 1: length(withdraw$Date)){
  if(isTRUE(withdraw$TransactionType[i] == "Withdraw") == TRUE){
    if(isTRUE(withdraw$Currency[i] == "SGD") == TRUE){
      withdraw$charge[i] = 1.01
    }
  }
  
  
  if(isTRUE(withdraw$TransactionType[i] != "Withdraw") == TRUE){
    withdraw$charge[i] = 1
  }
}


for(j in 1:10){
  i1 = freq2[j]+1
  i2 = freq2[j+1]-1
  
  for(i in (i1):(i2)){
    withdraw$balance[i]= 
      withdraw$balance[i-1] + withdraw$Amount[i]*withdraw$Conversion[i]*withdraw$charge[i]
  }
}


#Transation <- rbind(spend.credit, withdraw) %>%
  #select(Date, AccountNo, TransactionType, Amount, Currency)

#delete dates appearing twice
m <- withdraw %>%
  group_by(AccountNo, Date) %>%
  mutate(index = n()) %>%
  ungroup() %>%
  filter(index == 2) %>%
  filter(is.na(TransactionType) == TRUE)

m2 <- anti_join(withdraw, m, by = c("Date", "AccountNo", "Currency")) 
m2 <- m2 %>%
  mutate(interest = balance * 0.005/360) %>%
  mutate(month = month(Date)) %>%
  group_by(AccountNo, month) %>%
  mutate(cuminterest = cumsum(interest)) %>%
  arrange(AccountNo, Date) %>%
  ungroup()
  
for(i in 1: length(m2$Date)){
  if(isTRUE(m2$TransactionType[i] == "Interest") == TRUE){
    m2$Amount[i] = m2$cuminterest[i]
  }
}


#m2: cash account(deposit, withdraw, interest)
#spend.credit: spend,

Transaction <- m2 %>%
  select(-month) %>%
  filter(is.na(TransactionType) == FALSE) %>%
  select(Date, AccountNo, Amount, Currency, TransactionType) %>%
  rbind(., spend.credit[1:5]) %>%
  arrange(Date, AccountNo) %>%
  mutate(TransactionNo = 1) 

for(i in 1:length(Transaction$Date)){
  Transaction$TransactionNo[i] = i
}

save(Transaction, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/transaction.Rdata' )
save(spend.credit, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/credit.Rdata' )
save(m2, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/cash.Rdata' )


