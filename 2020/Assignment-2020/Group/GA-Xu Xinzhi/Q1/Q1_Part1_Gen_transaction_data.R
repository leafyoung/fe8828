library(shiny)
library(ggplot2)
library(lubridate)
library(tidyverse)
# setwd("C:/Users/YANG XUANRUI/Desktop/NTU/course/MT2-Programming Web Applications in Finance/GroupProject/GroupProject1")

# The Account table and transaction table are generated in R
# The exchange table is downloaded from MAS


#### 1. Create and save Account ####
AccountNo <- 1:10
Name <- c("aaa","bbb","ccc","ddd","eee","fff","ggg","hhh","iii","jjj")
#Deposit <- runif(10,1000,2000)
Account <- data.frame(AccountNo,Name)
saveRDS(Account,file="Account.rds")

#### 2. Create and save Exchange Rate ####
# library(readxl)
# EX_Rate <- read_excel("C:/Users/YANG XUANRUI/Desktop/NTU/course/MT2-Programming Web Applications in Finance/GroupProject/GroupProject1/EX Rate.xlsx",
# col_types = c("text", "numeric", "date"))
# saveRDS(EX_Rate,file="EX_Rate.rds")


#### 3  Transaction  ####
Account <- readRDS("Account.rds")
EX_Rate <- readRDS("EX_Rate.rds")
Start_date <- as.Date("2020-07-01")

##  3.1  Initial deposit setting
AccountList <- Account$AccountNo
Transaction <- data.frame(Date=as.Date(character()), AccountNo=integer(),TransactionType=character(),
                            amount =double(),Currency=character())
Transaction1 <- data.frame(Date=Start_date, AccountNo = AccountList, TransactionType = "Deposit"
                          , amount = runif(nrow(Account), 1000, 2000), Currency = "SGD")

##  3.2  Generate Function _ Deposit  Withdraw  Spend
Gen_Fun <- function(times_max, AccountList, CurrencyList, Type) {
    
    Gen <- data.frame(Date=as.Date(character()), AccountNo=integer(),TransactionType=character(),amount =double(),Currency=character())
    
    for(i in AccountList){
        if(Type == "Deposit"){
        Jul_n <- sample(1:times_max,1)    ;    Jul_date <- as.Date("2020-07-01") +??sample(0:30, Jul_n, replace = TRUE)  
        Aug_n <- sample(1:times_max,1)    ;    Aug_date <- as.Date("2020-08-01") +??sample(0:30, Aug_n, replace = TRUE)
        Sep_n <- sample(1:times_max,1)    ;    Sep_date <- as.Date("2020-09-01") +??sample(0:29, Sep_n, replace = TRUE)
        temp_date <- c(Jul_date,Aug_date,Sep_date)}
        else  {n <- sample(1:times_max,1)   ;    temp_date <- as.Date("2020-07-01") +??sample(0:91, n, replace = TRUE)}
        
        if(Type == "Deposit")  {temp_amount <- runif(length(temp_date), 1000, 2000)}
        else     {temp_amount <- -rlnorm(length(temp_date), 0,3) }
        
        temp_currency <- sample(CurrencyList, length(temp_date), replace = TRUE)
        temp_df <- data.frame(Date = temp_date, AccountNo = i, 
                              TransactionType = Type, amount = temp_amount, Currency = temp_currency)
        Gen <- bind_rows(Gen, temp_df)
    } 
    Gen 
}

# Deposit 
Transaction <- bind_rows(Transaction, Gen_Fun(2, AccountList, CurrencyList=c("SGD"), Type = "Deposit") )
# Withdraw & Spend
Transaction <- bind_rows(Transaction, Gen_Fun(1000, AccountList, CurrencyList=c("SGD","USD","CNY"), Type = "Withdraw") )
Transaction <- bind_rows(Transaction, Gen_Fun(1000, AccountList, CurrencyList=c("SGD","USD","CNY"), Type = "Spend") )



#### 4. Adjustment for constraints ####

# 4.0 PreProcess
Transaction <- Transaction[sample(nrow(Transaction),replace = FALSE),] # remove Type clustering
Transaction <- Transaction[order(Transaction$Date),] # order by date
Transaction <- bind_rows(Transaction1,Transaction)
Transaction <- left_join(Transaction, EX_Rate, by = c("Currency","Date")) %>% 
        mutate(Currency_SGD= Conversion * amount)
Transaction <- bind_cols(data.frame(TransactionNo = 1:nrow(Transaction)), Transaction) # add TransactionNo

# 4.1 bank charges

Transaction <- mutate(Transaction, Currency_SGD = case_when(
                    (TransactionType =="Spend" & Currency=="SGD") ~ Currency_SGD* 1.01,
                    (TransactionType =="Spend" & Currency!="SGD") ~ Currency_SGD* 1.02,
                    TransactionType !="Spend"                     ~ Currency_SGD* 1
                ))


# 4.2 can??t withdraw more than deposit
WithdrawList <- filter(Transaction,TransactionType=="Withdraw") %>% 
                select(c("TransactionNo","AccountNo","TransactionType","Currency_SGD"))

for(i in WithdrawList$TransactionNo){
    temp_AccNo <- WithdrawList[WithdrawList$TransactionNo==i,]$AccountNo
    
    temp_balance <- Transaction[Transaction$TransactionNo<=i,] %>% 
        filter(AccountNo==temp_AccNo & TransactionType %in% c("Withdraw","Deposit")) %>% 
        summarise(sum =sum(Currency_SGD)) 
    temp_balance <- temp_balance$sum[1]
    
    if(temp_balance < 0){
        Transaction <- Transaction[Transaction$TransactionNo!=i,]
    }
}

# 4.3 can??t spend more than credit


# Transaction %>% filter(TransactionType=="Spend") %>%
#                 group_by(AccountNo) %>% summarise(sum = sum(Currency_SGD))
SpendList <- filter(Transaction,TransactionType=="Spend") %>% 
    select(c("TransactionNo","AccountNo","TransactionType","Currency_SGD"))
for(i in SpendList$TransactionNo){
    temp_AccNo <- SpendList[SpendList$TransactionNo==i,]$AccountNo
    
    temp_balance <- Transaction[Transaction$TransactionNo<=i,] %>% 
        filter(AccountNo==temp_AccNo & TransactionType %in% c("Spend")) %>% 
        summarise(sum =sum(Currency_SGD)) 
    temp_balance <- temp_balance$sum[1]
    
    if(temp_balance < -2000){
        Transaction <- Transaction[Transaction$TransactionNo!=i,]
    }
}


#### 5. Interest (for end-of-month balance) ####  

# 5.1 Interest calculation
Transaction %>% filter(month(Date) %in% c(7),     TransactionType %in% c("Deposit","Withdraw")) %>%
    group_by(AccountNo) %>% summarise(sum = sum(Currency_SGD)) %>% 
    mutate(Interest = sum * 0.005/12)   -> Interest_7

Transaction %>% filter(month(Date) %in% c(7,8),   TransactionType %in% c("Deposit","Withdraw")) %>%
    group_by(AccountNo) %>% summarise(sum = sum(Currency_SGD)) %>% 
    mutate(Interest = sum * 0.005/12)  -> Interest_8

Transaction %>% filter(month(Date) %in% c(7,8,9), TransactionType %in% c("Deposit","Withdraw")) %>%
    group_by(AccountNo) %>% summarise(sum = sum(Currency_SGD)) %>% 
    mutate(Interest = sum * 0.005/12)  -> Interest_9

# 5.2 Insert Interest in to Transaction Table
# TransactionNo should be updated later
Tran_Int_7 <- data.frame(TransactionNo = 0, Date=as.Date("2020-07-31"), AccountNo = Interest_7$AccountNo, 
                         TransactionType = "Interest", amount = Interest_7$Interest, Currency = "SGD",
                         Conversion=1,Currency_SGD=Interest_7$Interest)  

Tran_Int_8 <- data.frame(TransactionNo = 0, Date=as.Date("2020-08-31"), AccountNo = Interest_8$AccountNo, 
                         TransactionType = "Interest", amount = Interest_8$Interest, Currency = "SGD",
                         Conversion=1, Currency_SGD=Interest_8$Interest)

Tran_Int_9 <- data.frame(TransactionNo = 0, Date=as.Date("2020-09-30"), AccountNo = Interest_9$AccountNo, 
                         TransactionType = "Interest", amount = Interest_9$Interest, Currency = "SGD",
                         Conversion=1, Currency_SGD=Interest_9$Interest)

Transaction <- bind_rows( Transaction[month(Transaction$Date)==7,],Tran_Int_7,
                          Transaction[month(Transaction$Date)==8,],Tran_Int_8,
                          Transaction[month(Transaction$Date)==9,],Tran_Int_9)
Transaction <- bind_cols(data.frame(TransactionNo = 1:nrow(Transaction)), Transaction[,-1]) # add TransactionNo
Transaction <- Transaction[,1:6]

saveRDS(Transaction,file="Transaction.rds")
