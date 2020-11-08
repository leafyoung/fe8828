library(tidyverse)
#Data Generator
#----------------------------------------------------------------------#
#                              1. Account                              #
#----------------------------------------------------------------------#
options(digits=2)
options(scipen = 200000)
df_Account <- data.frame(AccountNo = c(1:10),
                         Name =c("Leonardo Dicaprio", "Brad Pitt",
                                 "Timothee Chalamet", "Daniel Day Lewis",
                                 "Harry Potter","Hermione Granger",
                                 "Draco Malfoy","Ron Wesley",
                                 "Ben Affleck","Matt Damon"),
                         Deposit = round(runif(10, min=1000, max=2000),2),
                         Credit = rep(2000,10) )
df_Account
initial_Data <- data.frame(AccountNo = c(1:10), 
                           Deposit = df_Account[,'Deposit'],
                           Credit = rep(2000,10))
#----------------------------------------------------------------------#
#                            2.Conversion Rate                         #
#----------------------------------------------------------------------#
df_rate <- read.csv("C:/Users/18519/Desktop/Q1/Exchange Rate Report.csv",header=T,
                    sep=',',stringsAsFactors = FALSE)
colnames(df_rate) <- c("Date","CNY","SGD","USD")
df_rate <- format(df_rate, digits = 6)
df_rate
df_CNY_to_SGD <- data.frame(Currency = "CNY",
                            Conversion = round(as.numeric(df_rate[,'CNY'])/as.numeric(df_rate[,'SGD']),6),
                            Date = df_rate[,'Date'])
df_CNY_to_SGD <- format(df_CNY_to_SGD, digits = 6)
df_USD_to_SGD <- data.frame(Currency = "USD",
                            Conversion = round(as.numeric(df_rate[,'USD'])/as.numeric(df_rate[,'SGD']),7),
                            Date = df_rate[,'Date'])
df_USD_to_SGD <- format(df_USD_to_SGD, digits = 7)
df_USD_to_SGD
df_toSGD<- rbind(df_CNY_to_SGD,df_USD_to_SGD,make.row.names=FALSE)
df_toSGD

#----------------------------------------------------------------------#
#                             3.Date vector                            #
#----------------------------------------------------------------------#
date_list <- df_rate[,'Date']
date_list <- c(date_list)
date_list  #62 dates

#----------------------------------------------------------------------#
#                             4.Transaction                            #
#----------------------------------------------------------------------#
df_transaction <- data.frame(TransactionNo = numeric(),
                             Date = character(),
                             AccountNo = numeric(),
                             TransactionType = character(),
                             Amount = numeric(),
                             SGD_Amount = numeric(),
                             Currency = character(),
                             index = numeric(),
                             d_balance = numeric())
n <- 1 # Transaction No

#----------------------------------------------------------------------#
#          5.Deposit & Withdraw & Interest Date List by MONTH          #
#----------------------------------------------------------------------#
for (i in 1:10)
{ # For each customer
  #----------------------------------------#
  #      Withdraw Date List each Month     #
  #----------------------------------------#
  # how many withdraws -- 1-1000
  options(digits=1)
  w_index <- c()
  w_count <- runif(1, min=1, max=1000)
  cat("\n withdraw count: ",w_count)
  # Each has a date
  for (j in 1:round(w_count,0))
  {
    index <- round(runif(1, min=1, max=62),0)
    w_index <- c(w_index, index)
  }
  w_index <- sort(w_index,decreasing = FALSE)
  Jul_w_index <- c()
  Aug_w_index <- c()
  Sep_w_index <- c()
  for (x in 1:length(w_index))
  {
    index <- as.numeric(w_index[x])
    if (index <= 21){ Jul_w_index <- c(Jul_w_index,index)}
    else if (index >= 22 & index<=42){ Aug_w_index <- c(Aug_w_index,index)}
    else { Sep_w_index <- c(Sep_w_index,index)}
  }
  #==========================================#
  #                 July                     #
  #==========================================#
  #----------------------------------------#
  #            Deposit Date List           #
  #----------------------------------------#
  # how many deposits -- 1 or 2
  Jul_d_index <- c()
  d_count <- runif(1, min=1, max=2)
  cat("\n deposit count July: ",d_count)
  #Each has a date
  for (j in 1:round(d_count,0)){
    d_index <- round(runif(1, min=1, max=21),0)
    Jul_d_index <- c(Jul_d_index, d_index)
  }
  #----------------------------------------#
  #           Deposit & Withdraw           #
  #----------------------------------------#
  cat("\n For account ", i)
  Jul_d_index <- sort(Jul_d_index,decreasing = FALSE)
  Jul_w_index <- sort(Jul_w_index,decreasing = FALSE)
  Jul_index1 <- data.frame(transaction = "deposite",
                           index = Jul_d_index)
  Jul_index2 <- data.frame(transaction = "withdraw",
                           index = Jul_w_index)
  Jul_index <- rbind(Jul_index1,Jul_index2,stringsAsFactors = F)
  Jul_index <- Jul_index[order(Jul_index$index),]
  print(Jul_index)
  for(j in 1:nrow(Jul_index)){
    index <- Jul_index[j,'index']
    date <- date_list[index]
    # deposit
    if(as.character(Jul_index[j,'transaction'])=="deposite")
    {
      options(digits=3)
      amount <- runif(1, min=1000, max=2000)
      df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + amount
      deposit <- df_Account[i,'Deposit']
      row <- data.frame(n,date,i,"Deposit",amount,amount,"SGD",index,deposit)
      names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
      n <- n+1
      df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
    }
    # withdraw
    else
    {
      options(digits=3)
      deposit <- as.numeric(df_Account[i,"Deposit"])
      amount <- (-1)*rlnorm(1, 0, 3)
      if( amount+deposit > 0)
      {
        df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + amount
        deposit <- df_Account[i,'Deposit']
        row <- data.frame(n,date,i,"Withdraw",amount,amount,"SGD",index,deposit)
        names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
        n <- n+1
        df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
      }
    }
  }
  #----------------------------------------#
  #               Interest                 #
  #----------------------------------------#
  deposit <- df_Account[i,'Deposit']
  interest <- deposit * 0.00042 # monthly rate 0.042%
  df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + interest
  deposit <- df_Account[i,'Deposit']
  date <- "31-Jul-2020"
  row <- data.frame(n,date,i,"Interest",interest,interest,"SGD",22,deposit)
  names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
  n <- n+1
  df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)

  #==============================================================#
  #                          August                             #
  #==============================================================#
  #----------------------------------------#
  #            Deposit Date List           #
  #----------------------------------------#
  Aug_d_index <- c()
  # how many deposits -- 1 or 2
  options(digits=1)
  d_count <- runif(1, min=1, max=2)
  cat("\n deposit count Aug: ",d_count)
  # Each has a date
  for (j in 1:round(d_count,0))
  {
    d_index <- round(runif(1, min=22, max=42),0)
    Aug_d_index <- c(Aug_d_index, d_index)
  }
 
  #----------------------------------------#
  #           Deposit & Withdraw           #
  #----------------------------------------#
  cat("\n For account ", i)
  Aug_d_index <- sort(Aug_d_index,decreasing = FALSE)
  Aug_w_index <- sort(Aug_w_index,decreasing = FALSE)
  Aug_index1 <- data.frame(transaction = "deposite",
                           index = Aug_d_index)
  Aug_index2 <- data.frame(transaction = "withdraw",
                           index = Aug_w_index)
  Aug_index <- rbind(Aug_index1,Aug_index2,stringsAsFactors = F)
  Aug_index <- Aug_index[order(Aug_index$index),]
  print(Aug_index)
  for(j in 1:nrow(Aug_index))
  {
    index <- Aug_index[j,'index']
    date <- date_list[index]
    # deposit
    if(as.character(Aug_index[j,'transaction'])=="deposite")
    {
      options(digits=3)
      amount <- runif(1, min=1000, max=2000)
      df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + amount
      deposit <- df_Account[i,'Deposit']
      row <- data.frame(n,date,i,"Deposit",amount,amount,"SGD",index,deposit)
      names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
      n <- n+1
      df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
    }
    # withdraw
    else
    {
      options(digits=3)
      deposit <- as.numeric(df_Account[i,"Deposit"])
      amount <- (-1)*rlnorm(1, 0, 3)
      if(amount+deposit >= 0)
      {
        df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + amount
        deposit <- df_Account[i,'Deposit']
        row <- data.frame(n,date,i,"Withdraw",amount,amount,"SGD",index,deposit)
        names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
        n <- n+1
        df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
      }
    }
  }
  #----------------------------------------#
  #               Interest                 #
  #----------------------------------------#
  deposit <- as.numeric(df_Account[i,"Deposit"])
  interest <- deposit * 0.00042 # monthly rate 0.042%
  df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + interest
  date <- "31-Aug-2020"
  deposit <- df_Account[i,'Deposit']
  row <- data.frame(n,date,i,"Interest",interest,interest,"SGD",42,deposit)
  names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
  n <- n+1
  df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
  
  #==============================================================#
  #                         September                            #
  #==============================================================#
  #----------------------------------------#
  #            Deposit Date List           #
  #----------------------------------------#
  Sep_d_index <- c()
  # how many deposits -- 1 or 2
  options(digits=1)
  d_count <- runif(1, min=1, max=2)
  cat("\n deposit count Sep: ",d_count)
  # Each has a date
  for (j in 1:round(d_count,0))
  {
    d_index <- round(runif(1, min=43, max=62),0)
    Sep_d_index <- c(Sep_d_index, d_index)
  }
  #------------------------------------------------#
  #           Deposit & Withdraw & Spend           #
  #------------------------------------------------#
  cat("\n For account ", i)
  Sep_d_index <- sort(Sep_d_index,decreasing = FALSE)
  Sep_w_index <- sort(Sep_w_index,decreasing = FALSE)
  Sep_index1 <- data.frame(transaction = "deposite",
                           index = Sep_d_index)
  Sep_index2 <- data.frame(transaction = "withdraw",
                           index = Sep_w_index)
  Sep_index <- rbind(Sep_index1,Sep_index2,stringsAsFactors = F)
  Sep_index <- Sep_index[order(Sep_index$index),]
  print(Sep_index)
  for(j in 1:nrow(Sep_index))
  {
     index <- Sep_index[j,'index']
     date <- date_list[index]
     # deposit
     if(as.character(Sep_index[j,'transaction'])=="deposite")
     {
      options(digits=3)
      amount <- runif(1, min=1000, max=2000)
      df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + amount
      deposit <- df_Account[i,'Deposit']
      row <- data.frame(n,date,i,"Deposit",amount,amount,"SGD",index,deposit)
      names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
      n <- n+1
      df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
     }
     # withdraw
     else
     {
       options(digits=3)
       deposit <- as.numeric(df_Account[i,"Deposit"])
       amount <- (-1)*rlnorm(1, 0, 3)
       if(amount+deposit >= 0)
      {
        df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + amount
        deposit <- df_Account[i,'Deposit']
        row <- data.frame(n,date,i,"Withdraw",amount,amount,"SGD",index,deposit)
        names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
        n <- n+1
        df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
      }
    }
  }
  #----------------------------------------#
  #               Interest                 #
  #----------------------------------------#
  deposit <- as.numeric(df_Account[i,"Deposit"])
  interest <- deposit * 0.00042 # monthly rate 0.042%
  date <- "30-Sep-2020"
  df_Account[i,"Deposit"] <- df_Account[i,"Deposit"] + interest
  deposit <- df_Account[i,'Deposit']
  row <- data.frame(n,date,i,"Interest",interest,interest,"SGD",62,deposit)
  names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
  n <- n+1
  df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
}

#----------------------------------------------------------------------#
#                             6. Spend                                 #
#----------------------------------------------------------------------#
for (i in 1:10) # Spend for each customer
{
  options(digits=1)
  s_index <- c()
  # how many spends -- 1-1000
  s_count <- runif(1, min=1, max=1000)
  cat("\n total spend count: ",s_count)
  # Each has a date
  for (j in 1:round(s_count,0))
  {
    index <- round(runif(1, min=1, max=62),0)
    s_index <- c(s_index, index)
  }
  cat("\n For account ", i)
  s_index <- sort(s_index,decreasing = FALSE)
  print(s_index)
  
  credit <- 2000 # initial credit
  for(j in 1:length(s_index))
  {
    # date
    index <- s_index[j]
    date <- date_list[index]
    # amount
    options(digits=3)
    amount <- (-1)*rlnorm(1, 0, 2)
    cat("\n spend amount ",amount)
    # 1-CNY  2-SGD  3-USD
    options(digits=1)
    c_index <- runif(1, min=1, max=3)
    # CNY
    if( round(c_index,0) == 1)
    {      
      rate <- df_toSGD[which( (df_toSGD$Date==date) & (df_toSGD$Currency=="CNY")),'Conversion']
      options(digits=2)
      SGD <- as.numeric(amount * 1.02 * as.numeric(rate))
      print("CREDIT!!!!!")
      print(credit)
      if( (SGD+credit) >= 0 )
      {
         #TransactionNo | Date | AccountNo | TransactionType | Amount | Currency
         options(digits = 2)
         credit <- as.numeric(credit + SGD)
         df_Account[i,'Credit'] <- credit
         row <- data.frame(n,date,i,"Spend",round(amount,2),round(SGD,2),"CNY",index,credit)
         names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
         n <- n+1
         print(row)
         df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
       }
     }
    # SGD
    else if (round(c_index,0) == 2)
    {  
      credit <- as.numeric(as.character(credit))
      SGD <- as.numeric( amount * 1.01 )
      if(SGD + credit >= 0)
      {
        #TransactionNo | Date | AccountNo | TransactionType | Amount | Currency
        options(digits = 2)
        SGD <- as.numeric((-1)*to_SGD)
        credit <- credit + SGD
        df_Account[i,'Credit'] <- credit
        row <- data.frame(n,date,i,"Spend",round(SGD,2),round(SGD,2),"SGD",index,credit)
        names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
        n <- n+1
        print(row)
        df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
       }
    }
    # USD
    else
    {   # USD
      rate <- df_toSGD[which( (df_toSGD$Date==date) & (df_toSGD$Currency=="USD")),'Conversion']
      cat("\nrate",rate)
      options(digits=2)
      SGD <- as.numeric(amount * 1.02 * as.numeric(rate))
      cat("\nto SGD",to_SGD)
      if(SGD + credit > 0)
      {
        #TransactionNo | Date | AccountNo | TransactionType | Amount | Currency
        options(digits = 2)
        credit <- credit + SGD
        df_Account[i,'Credit'] <- credit
        row <- data.frame(n,date,i,"Spend",round(amount,2),round(SGD,2),"USD",index,credit)
        names(row)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","SGD_Amount","Currency","index","d_balance")
        n <- n+1
        print(row)
        df_transaction <- rbind(df_transaction,row,stringsAsFactors = F)
      }
     }
   }
}
options(digits=2)
df_transaction <- df_transaction[order(df_transaction$AccountNo,df_transaction$index),]
df_transaction <- rename(df_transaction, c("Balance"="d_balance"))
df_transaction 

write.csv(df_transaction,"C:/Users/18519/Desktop/Q1/transaction.csv",row.names = FALSE)

#----------------------------------------------------------------------#
#                  7. Credit, Deposit & Balance Sheet                  #
#----------------------------------------------------------------------#
#-------------------deposit---------------#
options(digits=2)
df_deposit<-subset(df_transaction,TransactionType=="Deposit"|TransactionType=="Withdraw"|TransactionType=="Interest",
                   select=c(AccountNo,index,SGD_Amount,Balance))
df_deposit%>%
    arrange(AccountNo,index) -> df_deposit
df_deposit

#-------------------credit---------------#
df_credit<-subset(df_transaction,TransactionType=="Spend",
                  select=c(AccountNo,index,SGD_Amount,Balance))
df_credit

df_credit %>%
  arrange(AccountNo,index) -> df_credit

df_deposit
df_credit
save(df_Account,df_rate,df_transaction,df_deposit,df_credit,date_list, file = "Bank Data.rda")

