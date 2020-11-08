library(tibble)
library(tidyverse)
library(bizdays)
library(lubridate)
library(conflicted)
conflict_prefer('last', 'dplyr')
conflict_prefer('lag', 'dplyr')
conflict_prefer('filter', 'dplyr')


deposit<-runif(10,min=1000,max=2000)
Name<-c("Tom","Paul","Frank","Jack","Ryan","Lucy","Amy","Jackie","Andrea","James")
Account<-tibble(AccountNo=1:10,Name=Name,Deposit=deposit)
saveRDS(Account,"Account")

currency<-read.csv(file.choose())
currency<-currency%>%mutate(Date=as.Date(Date,format="%Y-%m-%d"),SGD=1)
Date<-currency$Date
USD<-currency$USD
SGD<-currency$SGD
CNY<-currency$CNY
for (i in 2:(as.numeric(as.Date("2020-09-30")-as.Date("2020-07-01"))+1)){
  if ((Date[i]-Date[i-1])!=1){
    Date<-c(Date[1:(i-1)],Date[i-1]+1,Date[i:length(Date)])
    USD<-c(USD[1:(i-1)],USD[i-1],USD[i:length(USD)])
    SGD<-c(SGD[1:(i-1)],SGD[i-1],SGD[i:length(SGD)])
    CNY<-c(CNY[1:(i-1)],CNY[i-1],CNY[i:length(CNY)])
  }
  
  
}
currency<-tibble(Date=Date,USD=USD,SGD=SGD,CNY=CNY)


Currency<-pivot_longer(currency,col=c("USD","CNY","SGD"),names_to="Currency",values_to="Conversion")%>%
          select(Currency,Currency,Conversion,Date)

saveRDS(Currency,"Currency")
Currency<-readRDS("Currency")


######deposit
deposit_no_Jul<-c()
date_Jul<-c()
for (i in Account$AccountNo){
  s1<-sample(c(1,2),1)
  deposit_no_Jul<-c(deposit_no_Jul,rep(i,s1))
  date_Jul<-c(date_Jul,sample(bizseq("2020-07-01","2020-07-31"),s1))
}
date_Jul<-as.Date(date_Jul)
deposit_Jul<-tibble(AccountNo=deposit_no_Jul,Date=date_Jul,Amount=runif(length(date_Jul),1000,2000))


deposit_no_Aug<-c()
date_Aug<-c()
for (i in Account$AccountNo){
  s1<-sample(c(1,2),1)
  deposit_no_Aug<-c(deposit_no_Aug,rep(i,s1))
  date_Aug<-c(date_Aug,sample(bizseq("2020-08-01","2020-08-31"),s1))
}
date_Aug<-as.Date(date_Aug)
deposit_Aug<-tibble(AccountNo=deposit_no_Aug,Date=date_Aug,Amount=runif(length(date_Aug),1000,2000))

deposit_no_Sep<-c()
date_Sep<-c()
for (i in Account$AccountNo){
  s1<-sample(c(1,2),1)
  deposit_no_Sep<-c(deposit_no_Sep,rep(i,s1))
  date_Sep<-c(date_Sep,sample(bizseq("2020-09-01","2020-09-30"),s1))
}
date_Sep<-as.Date(date_Sep)
deposit_Sep<-tibble(AccountNo=deposit_no_Sep,Date=date_Sep,Amount=runif(length(date_Sep),1000,2000))

deposit<-rbind(deposit_Jul,deposit_Aug,deposit_Sep)%>%arrange(AccountNo)%>%mutate(Currency="SGD",TransactionType="deposit")


########spend

spend_no<-c()
spend_date<-c()
for (i in Account$AccountNo){
  s1<-runif(1,0,1000)
  spend_date<-c(spend_date,sample(bizseq("2020-07-01","2020-09-30"),s1,replace=T))
  spend_no<-c(spend_no,rep(i,s1))
}

spend<-tibble(AccountNo=spend_no,Date=as.Date(spend_date),Amount=rlnorm(length(spend_date),0,3),Currency=sample(c("USD","SGD","CNY"),length(spend_date),replace=T),TransactionType="Spend")

withdraw_no<-c()
withdraw_date<-c()
for (i in Account$AccountNo){
  s1<-runif(1,0,1000)
  withdraw_date<-c(withdraw_date,sample(bizseq("2020-07-01","2020-09-30"),s1,replace=T))
  withdraw_no<-c(withdraw_no,rep(i,s1))
}

Withdraw<-tibble(AccountNo=withdraw_no,Date=as.Date(withdraw_date),Amount=-rlnorm(length(withdraw_date),0,3),Currency=sample(c("USD","SGD","CNY"),length(withdraw_date),replace=T),TransactionType="Withdraw")


Transaction<-rbind(deposit,spend,Withdraw)

Transaction<-merge(Transaction,Currency)%>%mutate(`Amount(in SGD)`=ifelse(Currency=="SGD",Amount*1.01,Amount*1.02*Conversion))%>%arrange(Date)



filter_invalid<-function(accnum){
  cnew_7<-Transaction%>%filter(month(Date)==7&AccountNo==accnum)
  credit_7<-c(ifelse(cnew_7$TransactionType[1]=="Spend",cnew_7$`Amount(in SGD)`[1],0))
  for (i in 2:length(cnew_7$Date)){
    if (cnew_7$TransactionType[i]=="Spend"){
      credit_7<-c(credit_7,cnew_7$`Amount(in SGD)`[i]+credit_7[i-1])
    }
    else{credit_7=c(credit_7,credit_7[i-1])}
  }
  threshhold1<-which(credit_7>=2000)[1]
  cnew_7$`Amount(in SGD)`[threshhold1]<-2000-credit_7[threshhold1-1]
  cnew_7$Amount[threshhold1]<-cnew_7$`Amount(in SGD)`[threshhold1]/cnew_7$Conversion[threshhold1]
  cnew_7<-cnew_7%>%mutate(Credit=credit_7)
  cnew_7$Credit[threshhold1]=2000
  cnew_7<-cnew_7%>%filter(!(TransactionType=="Spend"&Credit>2000))%>%mutate(Credit=ifelse(Credit>2000,2000,Credit))
  
  
  dnew_7<-cnew_7
  deposit_7<-c(ifelse(dnew_7$TransactionType[1]=="Spend",(Account%>%filter(AccountNo==accnum))$Deposit,(Account%>%filter(AccountNo==accnum))$Deposit+dnew_7$`Amount(in SGD)`[1]))
  for(i in 2:length(dnew_7$Date)){
    if (dnew_7$TransactionType[i]=="Spend"){
      deposit_7<-c(deposit_7,deposit_7[i-1])
    }
    else{
      if(dnew_7$`Amount(in SGD)`[i]+deposit_7[i-1]<0){
        deposit_7<-c(deposit_7,0)
      }
      else{deposit_7<-c(deposit_7,dnew_7$`Amount(in SGD)`[i]+deposit_7[i-1])}
    }
  }
  
  dnew_7<-cbind(dnew_7,data.frame(Deposit.Balance=deposit_7))
  dnew_7_almost<-dnew_7%>%filter(!(TransactionType!="Spend"&Deposit.Balance==0))
  
  a<-2
  while(a<=length(dnew_7_almost$Date)){
    if (dnew_7_almost$Deposit.Balance[a]==0&dnew_7_almost$Deposit.Balance[a-1]>0){
      dnew_7_almost<-rbind(dnew_7_almost[1:(a-1),],tibble(Date=dnew_7_almost$Date[a-1],Currency="SGD",AccountNo=dnew_7_almost$AccountNo[a-1],
                                                          Amount=0-dnew_7_almost$Deposit.Balance[a-1],TransactionType="Withdraw",Conversion=1,`Amount(in SGD)`=0-dnew_7_almost$Deposit.Balance[a-1],Credit=dnew_7_almost$Credit[a-1],Deposit.Balance=0),
                           dnew_7_almost[a:length(dnew_7_almost$Date),])
      
    }
    a<-a+1
  }
  result_7<-rbind(dnew_7_almost,tibble(Date=as.Date("2020-7-31"),Currency="SGD",AccountNo=accnum,
                                       Amount=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12,TransactionType="Interest",Conversion=1,`Amount(in SGD)`=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12,Credit=dnew_7_almost$Credit[length(dnew_7_almost$Credit)],Deposit.Balance=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)-1]+dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12),
                  make.row.names=F)
  
  
  
  cnew_7<-Transaction%>%filter(month(Date)==8&AccountNo==accnum)
  credit_7<-c(ifelse(cnew_7$TransactionType[1]=="Spend",cnew_7$`Amount(in SGD)`[1],0))
  for (i in 2:length(cnew_7$Date)){
    if (cnew_7$TransactionType[i]=="Spend"){
      credit_7<-c(credit_7,cnew_7$`Amount(in SGD)`[i]+credit_7[i-1])
    }
    else{credit_7=c(credit_7,credit_7[i-1])}
  }
  threshhold1<-which(credit_7>=2000)[1]
  cnew_7$`Amount(in SGD)`[threshhold1]<-2000-credit_7[threshhold1-1]
  cnew_7$Amount[threshhold1]<-cnew_7$`Amount(in SGD)`[threshhold1]/cnew_7$Conversion[threshhold1]
  
  cnew_7<-cnew_7%>%mutate(Credit=credit_7)
  cnew_7$Credit[threshhold1]=2000
  cnew_7<-cnew_7%>%filter(!(TransactionType=="Spend"&Credit>2000))%>%mutate(Credit=ifelse(Credit>2000,2000,Credit))
  
  
  dnew_7<-cnew_7
  deposit_7<-c(ifelse(dnew_7$TransactionType[1]=="Spend",result_7$Deposit.Balance[length(result_7$Deposit.Balance)],max(c(result_7$Deposit.Balance[length(result_7$Deposit.Balance)]+dnew_7$`Amount(in SGD)`[1]),0)))
  for(i in 2:length(dnew_7$Date)){
    if (dnew_7$TransactionType[i]=="Spend"){
      deposit_7<-c(deposit_7,deposit_7[i-1])
    }
    else{
      if(dnew_7$`Amount(in SGD)`[i]+deposit_7[i-1]<0){
        deposit_7<-c(deposit_7,0)
      }
      else{deposit_7<-c(deposit_7,dnew_7$`Amount(in SGD)`[i]+deposit_7[i-1])}
    }
  }
  
  dnew_7<-cbind(dnew_7,data.frame(Deposit.Balance=deposit_7))
  dnew_7_almost<-dnew_7%>%filter(!(TransactionType!="Spend"&Deposit.Balance==0))
  
  a<-2
  while(a<=length(dnew_7_almost$Date)){
    if (dnew_7_almost$Deposit.Balance[a]==0&dnew_7_almost$Deposit.Balance[a-1]>0){
      dnew_7_almost<-rbind(dnew_7_almost[1:(a-1),],tibble(Date=dnew_7_almost$Date[a-1],Currency="SGD",AccountNo=dnew_7_almost$AccountNo[a-1],
                                                          Amount=0-dnew_7_almost$Deposit.Balance[a-1],TransactionType="Withdraw",Conversion=1,`Amount(in SGD)`=0-dnew_7_almost$Deposit.Balance[a-1],Credit=dnew_7_almost$Credit[a-1],Deposit.Balance=0),
                           dnew_7_almost[a:length(dnew_7_almost$Date),])
      
    }
    a<-a+1
  }
  result_8<-rbind(dnew_7_almost,tibble(Date=as.Date("2020-8-31"),Currency="SGD",AccountNo=accnum,
                                       Amount=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12,TransactionType="Interest",Conversion=1,`Amount(in SGD)`=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12,Credit=dnew_7_almost$Credit[length(dnew_7_almost$Credit)],Deposit.Balance=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)-1]+dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12),
                  make.row.names=F)
  
  
  cnew_7<-Transaction%>%filter(month(Date)==9&AccountNo==accnum)
  credit_7<-c(ifelse(cnew_7$TransactionType[1]=="Spend",cnew_7$`Amount(in SGD)`[1],0))
  for (i in 2:length(cnew_7$Date)){
    if (cnew_7$TransactionType[i]=="Spend"){
      credit_7<-c(credit_7,cnew_7$`Amount(in SGD)`[i]+credit_7[i-1])
    }
    else{credit_7=c(credit_7,credit_7[i-1])}
  }
  threshhold1<-which(credit_7>=2000)[1]
  cnew_7$`Amount(in SGD)`[threshhold1]<-2000-credit_7[threshhold1-1]
  cnew_7$Amount[threshhold1]<-cnew_7$`Amount(in SGD)`[threshhold1]/cnew_7$Conversion[threshhold1]
 
  cnew_7<-cnew_7%>%mutate(Credit=credit_7)
  cnew_7$Credit[threshhold1]=2000
  cnew_7<-cnew_7%>%filter(!(TransactionType=="Spend"&Credit>2000))%>%mutate(Credit=ifelse(Credit>2000,2000,Credit))
  
  
  dnew_7<-cnew_7
  deposit_7<-c(ifelse(dnew_7$TransactionType[1]=="Spend",result_8$Deposit.Balance[length(result_8$Deposit.Balance)],max(c(result_8$Deposit.Balance[length(result_8$Deposit.Balance)]+dnew_7$`Amount(in SGD)`[1]),0)))
  for(i in 2:length(dnew_7$Date)){
    if (dnew_7$TransactionType[i]=="Spend"){
      deposit_7<-c(deposit_7,deposit_7[i-1])
    }
    else{
      if(dnew_7$`Amount(in SGD)`[i]+deposit_7[i-1]<0){
        deposit_7<-c(deposit_7,0)
      }
      else{deposit_7<-c(deposit_7,dnew_7$`Amount(in SGD)`[i]+deposit_7[i-1])}
    }
  }
  
  dnew_7<-cbind(dnew_7,data.frame(Deposit.Balance=deposit_7))
  dnew_7_almost<-dnew_7%>%filter(!(TransactionType!="Spend"&Deposit.Balance==0))
  
  a<-2
  while(a<=length(dnew_7_almost$Date)){
    if (dnew_7_almost$Deposit.Balance[a]==0&dnew_7_almost$Deposit.Balance[a-1]>0){
      dnew_7_almost<-rbind(dnew_7_almost[1:(a-1),],tibble(Date=dnew_7_almost$Date[a-1],Currency="SGD",AccountNo=dnew_7_almost$AccountNo[a-1],
                                                          Amount=0-dnew_7_almost$Deposit.Balance[a-1],TransactionType="Withdraw",Conversion=1,`Amount(in SGD)`=0-dnew_7_almost$Deposit.Balance[a-1],Credit=dnew_7_almost$Credit[a-1],Deposit.Balance=0),
                           dnew_7_almost[a:length(dnew_7_almost$Date),])
      
    }
    a<-a+1
  }
  result_9<-rbind(dnew_7_almost,tibble(Date=as.Date("2020-9-30"),Currency="SGD",AccountNo=accnum,
                                       Amount=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12,TransactionType="Interest",Conversion=1,`Amount(in SGD)`=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12,Credit=dnew_7_almost$Credit[length(dnew_7_almost$Credit)],Deposit.Balance=dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)-1]+dnew_7_almost$Deposit.Balance[length(dnew_7_almost$Deposit.Balance)]*0.005/12),
                  make.row.names=F)

  
  rbind(result_7,result_8,result_9)
  
  

}

Transaction_final<-tibble()


for (i in Account$AccountNo){
  Transaction_final<-rbind(Transaction_final,filter_invalid(i))
}
Transaction_final<-Transaction_final%>%arrange(Date)
saveRDS(Transaction_final,"Transaction_final")
Transaction_final<-readRDS("Transaction_final")


