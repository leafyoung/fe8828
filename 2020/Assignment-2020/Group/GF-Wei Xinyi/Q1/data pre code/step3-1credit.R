#step 3-spend

rm(list = ls())
library(lubridate)

load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')
load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata')

#spend - credit
credit <- data.frame()
save(credit, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/credit.Rdata')

for(p in 1:10){
  rm(list = ls())
  

  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/account.Rdata')
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/exchange.Rdata')
  load('/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/credit.Rdata')
  
  
  Date1 <- seq.Date(from = as.Date("2020/07/01", format = "%Y/%m/%d"),
                    by = "day", length.out = 92)
  TransactionType1 <- c(rep("Spend", 92))
  x <- c("USD", "CNY", "SGD")
  Currency1 <- sample(x,size=92,replace=T)
  Amount1 <- rlnorm(92,0,3)
  Credit1 <- rep(2000, 92)
  AccountNo1 <- rep(p, 92)
  
  spend.credit.sep <- data.frame(Date = Date1, 
                                 TransactionType = TransactionType1, 
                                 AccountNo = AccountNo1,
                                 Currency = Currency1, 
                                 Amount = Amount1, 
                                 Credit = Credit1) %>%
    mutate(Amount = -Amount) %>%
    full_join(., Currency.to.SGD, by = c("Date", "Currency")) %>%
    filter(is.na(TransactionType) == FALSE) %>%
    mutate(month = month(Date)) %>%
    mutate(charge = ifelse(
      isTRUE(Currency == "SGD"),
      1.01, 1.02
    ))
  
  spend.credit.sep$Credit[1] = 
    2000 + spend.credit.sep$Amount[1] * spend.credit.sep$Conversion[1] * spend.credit.sep$charge[1]
  
  for(i in 2:92){
    #calculte credit
    amount.max = 
      spend.credit.sep$Credit[i-1]/(spend.credit.sep$charge[i] * spend.credit.sep$Conversion[i])
    while(abs(spend.credit.sep$Amount[i]) > amount.max){
      spend.credit.sep$Amount[i] = -(rlnorm(1,0,3))
    }
    
    if(abs(spend.credit.sep$Amount[i]) <= amount.max){
      spend.credit.sep$Credit[i] = 
        spend.credit.sep$Credit[i-1] + spend.credit.sep$Amount[i]*spend.credit.sep$charge[i]*spend.credit.sep$Conversion[i]
    }
  }
  
  credit <- credit %>%
    rbind(., spend.credit.sep)
  
  
  save(credit, file = '/Users/fanwenqing/Desktop/R/FE8828-Fan Wenqing/group project/credit.Rdata')
}




