#1.1
library(readxl)
library(dplyr)
setwd("/Users/yuxi/Desktop/FE8828 R/Grp Assignment")
AccountNo<-c("8801","8802","8803","8804","8805","8806","8807","8808","8809","8810")
Name<-c("A","B","C","D","E","F","G","H","I","J")
Deposit<-runif(10,1000,2000)
Credit<-rep(2000,10)
df1<-data.frame(AccountNo,Name,Deposit,Credit)
save(df1,file="df1.Rda")
load("df1.Rda")

#1.2-Display
Currency<-c("CNY","USD","SGD")
USDRate <- read_excel("Documents/MFE Material/FE8814/Conversion Rate.xlsx", 
                              sheet = "USD")

CNYRate <- read_excel("Documents/MFE Material/FE8814/Conversion Rate.xlsx", 
                              sheet = "CNY")

df2<-rbind(USDRate,CNYRate)
df2$Date <- format(as.POSIXct(df2$Date,format='%m/%d/%Y %H:%M:%S'),format='%Y-%m-%d')
save(df2,file="df2.Rda")
load("df2.Rda")

#1.2-Calculation
dfUSD<-data.frame(USDRate)
dfCNY<-data.frame(CNYRate)
dfusd<-split(dfUSD,format(as.Date(dfUSD$Date),"%Y-%m"))
dfcny<-split(dfCNY,format(as.Date(dfCNY$Date),"%Y-%m"))
dfusd$`2020-07`$Date<- as.character(dfusd$`2020-07`$Date)
dfcny$`2020-07`$Date<- as.character(dfcny$`2020-07`$Date)
dfusd$`2020-08`$Date<- as.character(dfusd$`2020-08`$Date)
dfcny$`2020-08`$Date<- as.character(dfcny$`2020-08`$Date)
dfusd$`2020-09`$Date<- as.character(dfusd$`2020-09`$Date)
dfcny$`2020-09`$Date<- as.character(dfcny$`2020-09`$Date)


#1.3
df4<-split(df2,format(as.Date(df2$Date),"%Y-%m"))
 #For July
TranscationNo1<-seq(1,10,by=1)
TranscationNo2<-seq(11,15,by=1)
TranscationNo3<-seq(16,80,by=1)
TranscationNo4<-seq(81,90,by=1)


TranscationDate1<-sample(df4$`2020-07`$Date,10,replace=TRUE)
TranscationDate2<-sample(df4$`2020-07`$Date,5,replace=TRUE)
TranscationDate3<-sample(df4$`2020-07`$Date,65,replace=TRUE)
TranscationDate4<-sample(df4$`2020-07`$Date,10,replace=TRUE)


TranscationAccountNo1<-sample(df1$AccountNo,10,replace=FALSE)
TranscationAccountNo2<-sample(df1$AccountNo,5,replace=TRUE)
TranscationAccountNo3<-sample(df1$AccountNo,65,replace=TRUE)
TranscationAccountNo4<-sample(df1$AccountNo,10,replace=FALSE)


TranscationType1<-rep("Deposit",10)
TranscationType2<-rep("Deposit",5)
TranscationType3<-rep("Spend",65)
TranscationType4<-rep("Withdraw",10)


Amount1<-runif(10,1000,2000)
Amount2<-runif(5,1000,2000)
Amount3<-runif(65,0,200)
Amount4<-runif(10,0,1000)


Currency1<-rep("SGD",10)
Currency2<-rep("SGD",5)
Currency3<-sample(c(rep("CNY",100),rep("USD",100),rep("SGD",100)),65,replace=TRUE)
Currency4<-sample(c(rep("CNY",100),rep("USD",100),rep("SGD",100)),10,replace=TRUE)

 
tableJul1<-cbind(TranscationNo1,TranscationDate1,TranscationAccountNo1,TranscationType1,Amount1,Currency1)
tableJul2<-cbind(TranscationNo2,TranscationDate2,TranscationAccountNo2,TranscationType2,Amount2,Currency2)
tableJul3<-cbind(TranscationNo3,TranscationDate3,TranscationAccountNo3,TranscationType3,Amount3,Currency3)
tableJul4<-cbind(TranscationNo4,TranscationDate4,TranscationAccountNo4,TranscationType4,Amount4,Currency4)
tableJul<-rbind(tableJul1,tableJul2,tableJul3,tableJul4)
dfa<-data.frame(tableJul)

dfCal<-dfa
colnames(dfCal)[2]<-"Date"
dfCal<-inner_join(dfCal,dfusd$`2020-07`,by="Date")
colnames(dfCal)[8]<-"ConversionRateUSD"
dfCal[7]<-NULL
dfCal<-inner_join(dfCal,dfcny$`2020-07`,by="Date")
colnames(dfCal)[9]<-"ConversionRateCNY"
dfCal[8]<-NULL
dfCal<-cbind(dfCal,SGDAmount1=0)
dfCal<-cbind(dfCal,Fees1=0)
dfCal<-cbind(dfCal,Combined1=0)
dfCal$Amount1<-as.numeric(dfCal$Amount1)

dfCal$SGDAmount1<-ifelse(dfCal$Currency1=="USD",dfCal$Amount1*dfCal$ConversionRateUSD,
                         ifelse(dfCal$Currency1=="CNY",dfCal$Amount1*dfCal$ConversionRateCNY/100,
                                dfCal$Amount1))
dfCal$Fees1<-ifelse(dfCal$TranscationType1=="Spend",
                    ifelse(dfCal$Currency1=="SGD",dfCal$SGDAmount1*0.01,dfCal$SGDAmount1*0.02),0)
dfCal$Combined1=dfCal$SGDAmount1+dfCal$Fees1


df_sum_Jul<-aggregate(dfCal$Combined1, by=list(dfCal$TranscationAccountNo1,dfCal$TranscationType1),FUN=sum)

colnames(df_sum_Jul)<-c("AccountNo","Type","Amount")
df_sum_Jul_deposit<-subset(df_sum_Jul,Type=="Deposit")
df_sum_Jul_spend<-subset(df_sum_Jul,Type=="Spend")
df_sum_Jul_withdraw<-subset(df_sum_Jul,Type=="Withdraw")

df_sum_Jul_account<-inner_join(df1,df_sum_Jul_deposit,by="AccountNo")
df_sum_Jul_account<-inner_join(df_sum_Jul_account,df_sum_Jul_spend,by="AccountNo")
df_sum_Jul_account<-inner_join(df_sum_Jul_account,df_sum_Jul_withdraw,by="AccountNo")

colnames(df_sum_Jul_account)<-c("AccountNo","Name","BegainningBalance","BegainningCredit",
                               "Type1","DepositAmount","Type2","SpendAmount","Type3","WithdrawAmount")

df_sum_Jul_account<-cbind(df_sum_Jul_account,DepositBalanceBeforeInterest=0)
df_sum_Jul_account<-cbind(df_sum_Jul_account,CreditBalance=0)
df_sum_Jul_account<-cbind(df_sum_Jul_account,InterestPayment=0)
df_sum_Jul_account<-cbind(df_sum_Jul_account,EndBalance=0)

df_sum_Jul_account$DepositBalanceBeforeInterest=
  df_sum_Jul_account$BegainningBalance+df_sum_Jul_account$DepositAmount-df_sum_Jul_account$WithdrawAmount
df_sum_Jul_account$CreditBalance=df_sum_Jul_account$BegainningCredit-df_sum_Jul_account$SpendAmount
df_sum_Jul_account$InterestPayment=df_sum_Jul_account$DepositBalanceBeforeInterest*0.05/12
df_sum_Jul_account$EndBalance=df_sum_Jul_account$DepositBalanceBeforeInterest+df_sum_Jul_account$InterestPayment



TranscationNoI1<-seq(91,100,by=1)
TranscationDateI1<-rep("2020-07-31",10)
TranscationAccountNoI1<-c("8801","8802","8803","8804","8805","8806","8807","8808","8809","8810")
TranscationTypeI1<-rep("Interest Payment",10)
AmountI1<-df_sum_Jul_account$InterestPayment
CurrencyI1<-rep("SGD",5)
tableJulI1<-cbind(TranscationNoI1,TranscationDateI1,TranscationAccountNoI1,TranscationTypeI1,AmountI1,CurrencyI1)
tableJul<-rbind(tableJul,tableJulI1)
dfa<-data.frame(tableJul)

SGDAmountI1<-AmountI1
FeesI1<-rep(0,10)
CombinedI1<-AmountI1
ConversionRateUSD<-rep("NA",10)
ConversionRateCNY<-rep("NA",10)
tableI1_<-cbind(TranscationNoI1,TranscationDateI1,TranscationAccountNoI1,TranscationTypeI1,AmountI1,CurrencyI1,ConversionRateUSD,ConversionRateCNY,
                SGDAmountI1,FeesI1,CombinedI1)
dfI1<-data.frame(tableI1_)
colnames(dfI1)<-c("TranscationNo1","Date","TranscationAccountNo1","TranscationType1","Amount1","Currency1","ConversionRateUSD","ConversionRateCNY",
                  "SGDAmount1","Fees1","Combined1")
df_with_I1<-rbind(dfCal,dfI1)

Month1<-rep("Jul",100)
tableM1<-cbind(df_with_I1,Month1)
df_with_M1<-data.frame(tableM1)
colnames(df_with_M1)<-c("TransNo","Date","TransAccountNo","TransType","Amount","Currency","ConverRateUSD","ConverRateCNY","Amount(in SGD)",
                        "Fees","Combined","Month")

df_with_bal<-df_with_M1[order(df_with_M1$Date),]

  

#For August
TranscationNo5<-seq(1,10,by=1)
TranscationNo6<-seq(11,15,by=1)
TranscationNo7<-seq(16,80,by=1)
TranscationNo8<-seq(81,90,by=1)


TranscationDate5<-sample(df4$`2020-08`$Date,10,replace=TRUE)
TranscationDate6<-sample(df4$`2020-08`$Date,5,replace=TRUE)
TranscationDate7<-sample(df4$`2020-08`$Date,65,replace=TRUE)
TranscationDate8<-sample(df4$`2020-08`$Date,10,replace=TRUE)


TranscationAccountNo5<-sample(df1$AccountNo,10,replace=FALSE)
TranscationAccountNo6<-sample(df1$AccountNo,5,replace=TRUE)
TranscationAccountNo7<-sample(df1$AccountNo,65,replace=TRUE)
TranscationAccountNo8<-sample(df1$AccountNo,10,replace=FALSE)


TranscationType5<-rep("Deposit",10)
TranscationType6<-rep("Deposit",5)
TranscationType7<-rep("Spend",65)
TranscationType8<-rep("Withdraw",10)


Amount5<-runif(10,1000,2000)
Amount6<-runif(5,1000,2000)
Amount7<-runif(65,0,200)
Amount8<-runif(10,0,1000)


Currency5<-rep("SGD",10)
Currency6<-rep("SGD",5)
Currency7<-sample(c(rep("CNY",100),rep("USD",100),rep("SGD",100)),65,replace=TRUE)
Currency8<-sample(c(rep("CNY",100),rep("USD",100),rep("SGD",100)),10,replace=TRUE)


tableAug5<-cbind(TranscationNo5,TranscationDate5,TranscationAccountNo5,TranscationType5,Amount5,Currency5)
tableAug6<-cbind(TranscationNo6,TranscationDate6,TranscationAccountNo6,TranscationType6,Amount6,Currency6)
tableAug7<-cbind(TranscationNo7,TranscationDate7,TranscationAccountNo7,TranscationType7,Amount7,Currency7)
tableAug8<-cbind(TranscationNo8,TranscationDate8,TranscationAccountNo8,TranscationType8,Amount8,Currency8)
tableAug<-rbind(tableAug5,tableAug6,tableAug7,tableAug8)
dfb<-data.frame(tableAug)


dfCal2<-dfb
colnames(dfCal2)[2]<-"Date"
dfCal2<-inner_join(dfCal2,dfusd$`2020-08`,by="Date")
colnames(dfCal2)[8]<-"ConversionRateUSD"
dfCal2[7]<-NULL
dfCal2<-inner_join(dfCal2,dfcny$`2020-08`,by="Date")
colnames(dfCal2)[9]<-"ConversionRateCNY"
dfCal2[8]<-NULL
dfCal2<-cbind(dfCal2,SGDAmount5=0)
dfCal2<-cbind(dfCal2,Fees5=0)
dfCal2<-cbind(dfCal2,Combined5=0)
dfCal2$Amount5<-as.numeric(dfCal2$Amount5)

dfCal2$SGDAmount5<-ifelse(dfCal2$Currency5=="USD",dfCal2$Amount5*dfCal2$ConversionRateUSD,
                         ifelse(dfCal2$Currency5=="CNY",dfCal2$Amount5*dfCal2$ConversionRateCNY/100,
                                dfCal2$Amount5))
dfCal2$Fees5<-ifelse(dfCal2$TranscationType5=="Spend",
                    ifelse(dfCal2$Currency5=="SGD",dfCal2$SGDAmount5*0.01,dfCal2$SGDAmount5*0.02),0)
dfCal2$Combined5=dfCal2$SGDAmount5+dfCal2$Fees5
df_sum_Aug<-aggregate(dfCal2$Combined5, by=list(dfCal2$TranscationAccountNo5,dfCal2$TranscationType5),FUN=sum)

colnames(df_sum_Aug)<-c("AccountNo","Type","Amount")
df_sum_Aug_deposit<-subset(df_sum_Aug,Type=="Deposit")
df_sum_Aug_spend<-subset(df_sum_Aug,Type=="Spend")
df_sum_Aug_withdraw<-subset(df_sum_Aug,Type=="Withdraw")


AccountNo<-c("8801","8802","8803","8804","8805","8806","8807","8808","8809","8810")
Name<-c("A","B","C","D","E","F","G","H","I","J")
Deposit<-df_sum_Jul_account$EndBalance
Credit<-rep(2000,10)
df1_for_Aug<-data.frame(AccountNo,Name,Deposit,Credit)

df_sum_Aug_account<-inner_join(df1_for_Aug,df_sum_Aug_deposit,by="AccountNo")
df_sum_Aug_account<-inner_join(df_sum_Aug_account,df_sum_Aug_spend,by="AccountNo")
df_sum_Aug_account<-inner_join(df_sum_Aug_account,df_sum_Aug_withdraw,by="AccountNo")

colnames(df_sum_Aug_account)<-c("AccountNo","Name","BegainningBalance","BegainningCredit",
                                "Type1","DepositAmount","Type2","SpendAmount","Type3","WithdrawAmount")

df_sum_Aug_account<-cbind(df_sum_Aug_account,DepositBalanceBeforeInterest=0)
df_sum_Aug_account<-cbind(df_sum_Aug_account,CreditBalance=0)
df_sum_Aug_account<-cbind(df_sum_Aug_account,InterestPayment=0)
df_sum_Aug_account<-cbind(df_sum_Aug_account,EndBalance=0)

df_sum_Aug_account$DepositBalanceBeforeInterest=
  df_sum_Aug_account$BegainningBalance+df_sum_Aug_account$DepositAmount-df_sum_Aug_account$WithdrawAmount

df_sum_Aug_account$CreditBalance=df_sum_Aug_account$BegainningCredit-df_sum_Aug_account$SpendAmount
df_sum_Aug_account$InterestPayment=df_sum_Aug_account$DepositBalanceBeforeInterest*0.05/12
df_sum_Aug_account$EndBalance=df_sum_Aug_account$DepositBalanceBeforeInterest+df_sum_Aug_account$InterestPayment



TranscationNoI2<-seq(91,100,by=1)
TranscationDateI2<-rep("2020-08-31",10)
TranscationAccountNoI2<-c("8801","8802","8803","8804","8805","8806","8807","8808","8809","8810")
TranscationTypeI2<-rep("Interest Payment",10)
AmountI2<-df_sum_Aug_account$InterestPayment
CurrencyI2<-rep("SGD",5)
tableAugI2<-cbind(TranscationNoI2,TranscationDateI2,TranscationAccountNoI2,TranscationTypeI2,AmountI2,CurrencyI2)
tableAug<-rbind(tableAug,tableAugI2)
dfb<-data.frame(tableAug)

SGDAmountI2<-AmountI2
FeesI2<-rep(0,10)
CombinedI2<-AmountI2
ConversionRateUSD<-rep("NA",10)
ConversionRateCNY<-rep("NA",10)
tableI2_<-cbind(TranscationNoI2,TranscationDateI2,TranscationAccountNoI2,TranscationTypeI2,AmountI2,CurrencyI2,ConversionRateUSD,ConversionRateCNY,
                SGDAmountI2,FeesI2,CombinedI2)
dfI2<-data.frame(tableI2_)
colnames(dfI2)<-c("TranscationNo5","Date","TranscationAccountNo5","TranscationType5","Amount5","Currency5","ConversionRateUSD","ConversionRateCNY",
                  "SGDAmount5","Fees5","Combined5")
df_with_I2<-rbind(dfCal2,dfI2)

Month2<-rep("Aug",100)
tableM2<-cbind(df_with_I2,Month2)
df_with_M2<-data.frame(tableM2)
colnames(df_with_M2)<-c("TransNo","Date","TransAccountNo","TransType","Amount","Currency","ConverRateUSD","ConverRateCNY","Amount(in SGD)",
                        "Fees","Combined","Month")



#For Sep
TranscationNo9<-seq(1,10,by=1)
TranscationNo10<-seq(11,15,by=1)
TranscationNo11<-seq(16,80,by=1)
TranscationNo12<-seq(81,90,by=1)


TranscationDate9<-sample(df4$`2020-09`$Date,10,replace=TRUE)
TranscationDate10<-sample(df4$`2020-09`$Date,5,replace=TRUE)
TranscationDate11<-sample(df4$`2020-09`$Date,65,replace=TRUE)
TranscationDate12<-sample(df4$`2020-09`$Date,10,replace=TRUE)


TranscationAccountNo9<-sample(df1$AccountNo,10,replace=FALSE)
TranscationAccountNo10<-sample(df1$AccountNo,5,replace=TRUE)
TranscationAccountNo11<-sample(df1$AccountNo,65,replace=TRUE)
TranscationAccountNo12<-sample(df1$AccountNo,10,replace=FALSE)


TranscationType9<-rep("Deposit",10)
TranscationType10<-rep("Deposit",5)
TranscationType11<-rep("Spend",65)
TranscationType12<-rep("Withdraw",10)


Amount9<-runif(10,1000,2000)
Amount10<-runif(5,1000,2000)
Amount11<-runif(65,0,200)
Amount12<-runif(10,0,1000)


Currency9<-rep("SGD",10)
Currency10<-rep("SGD",5)
Currency11<-sample(c(rep("CNY",100),rep("USD",100),rep("SGD",100)),65,replace=TRUE)
Currency12<-sample(c(rep("CNY",100),rep("USD",100),rep("SGD",100)),10,replace=TRUE)


tableSep9<-cbind(TranscationNo9,TranscationDate9,TranscationAccountNo9,TranscationType9,Amount9,Currency9)
tableSep10<-cbind(TranscationNo10,TranscationDate10,TranscationAccountNo10,TranscationType10,Amount10,Currency10)
tableSep11<-cbind(TranscationNo11,TranscationDate11,TranscationAccountNo11,TranscationType11,Amount11,Currency11)
tableSep12<-cbind(TranscationNo12,TranscationDate12,TranscationAccountNo12,TranscationType12,Amount12,Currency12)
tableSep<-rbind(tableSep9,tableSep10,tableSep11,tableSep12)
dfc<-data.frame(tableSep)

dfCal3<-dfc
colnames(dfCal3)[2]<-"Date"
dfCal3<-inner_join(dfCal3,dfusd$`2020-09`,by="Date")
colnames(dfCal3)[8]<-"ConversionRateUSD"
dfCal3[7]<-NULL
dfCal3<-inner_join(dfCal3,dfcny$`2020-09`,by="Date")
colnames(dfCal3)[9]<-"ConversionRateCNY"
dfCal3[8]<-NULL
dfCal3<-cbind(dfCal3,SGDAmount9=0)
dfCal3<-cbind(dfCal3,Fees9=0)
dfCal3<-cbind(dfCal3,Combined9=0)
dfCal3$Amount9<-as.numeric(dfCal3$Amount9)

dfCal3$SGDAmount9<-ifelse(dfCal3$Currency9=="USD",dfCal3$Amount9*dfCal3$ConversionRateUSD,
                          ifelse(dfCal3$Currency9=="CNY",dfCal3$Amount9*dfCal3$ConversionRateCNY/100,
                                 dfCal3$Amount9))
dfCal3$Fees9<-ifelse(dfCal3$TranscationType9=="Spend",
                     ifelse(dfCal3$Currency9=="SGD",dfCal3$SGDAmount9*0.01,dfCal3$SGDAmount9*0.02),0)
dfCal3$Combined9=dfCal3$SGDAmount9+dfCal3$Fees9
View(dfCal3)
df_sum_Sep<-aggregate(dfCal3$Combined9, by=list(dfCal3$TranscationAccountNo9,dfCal3$TranscationType9),FUN=sum)

colnames(df_sum_Sep)<-c("AccountNo","Type","Amount")


df_sum_Sep_deposit<-subset(df_sum_Sep,Type=="Deposit")
df_sum_Sep_spend<-subset(df_sum_Sep,Type=="Spend")
df_sum_Sep_withdraw<-subset(df_sum_Sep,Type=="Withdraw")


AccountNo<-c("8801","8802","8803","8804","8805","8806","8807","8808","8809","8810")
Name<-c("A","B","C","D","E","F","G","H","I","J")
Deposit<-df_sum_Aug_account$EndBalance
Credit<-rep(2000,10)
df1_for_Sep<-data.frame(AccountNo,Name,Deposit,Credit)

df_sum_Sep_account<-inner_join(df1_for_Sep,df_sum_Sep_deposit,by="AccountNo")
df_sum_Sep_account<-inner_join(df_sum_Sep_account,df_sum_Sep_spend,by="AccountNo")
df_sum_Sep_account<-inner_join(df_sum_Sep_account,df_sum_Sep_withdraw,by="AccountNo")

colnames(df_sum_Sep_account)<-c("AccountNo","Name","BegainningBalance","BegainningCredit",
                                "Type1","DepositAmount","Type2","SpendAmount","Type3","WithdrawAmount")

df_sum_Sep_account<-cbind(df_sum_Sep_account,DepositBalanceBeforeInterest=0)
df_sum_Sep_account<-cbind(df_sum_Sep_account,CreditBalance=0)
df_sum_Sep_account<-cbind(df_sum_Sep_account,InterestPayment=0)
df_sum_Sep_account<-cbind(df_sum_Sep_account,EndBalance=0)

df_sum_Sep_account$DepositBalanceBeforeInterest=
  df_sum_Sep_account$BegainningBalance+df_sum_Sep_account$DepositAmount-df_sum_Sep_account$WithdrawAmount

df_sum_Sep_account$CreditBalance=df_sum_Sep_account$BegainningCredit-df_sum_Sep_account$SpendAmount
df_sum_Sep_account$InterestPayment=df_sum_Sep_account$DepositBalanceBeforeInterest*0.05/12
df_sum_Sep_account$EndBalance=df_sum_Sep_account$DepositBalanceBeforeInterest+df_sum_Sep_account$InterestPayment



TranscationNoI3<-seq(91,100,by=1)
TranscationDateI3<-rep("2020-09-30",10)

TranscationAccountNoI3<-c("8801","8802","8803","8804","8805","8806","8807","8808","8809","8810")
TranscationTypeI3<-rep("Interest Payment",10)
AmountI3<-df_sum_Sep_account$InterestPayment
CurrencyI3<-rep("SGD",5)
tableSepI3<-cbind(TranscationNoI3,TranscationDateI3,TranscationAccountNoI3,TranscationTypeI3,AmountI3,CurrencyI3)
tableSep<-rbind(tableSep,tableSepI3)
dfc<-data.frame(tableSep)

SGDAmountI3<-AmountI3
FeesI3<-rep(0,10)
CombinedI3<-AmountI3
ConversionRateUSD<-rep("NA",10)
ConversionRateCNY<-rep("NA",10)
tableI3_<-cbind(TranscationNoI3,TranscationDateI3,TranscationAccountNoI3,TranscationTypeI3,AmountI3,CurrencyI3,ConversionRateUSD,ConversionRateCNY,
                SGDAmountI3,FeesI3,CombinedI3)
dfI3<-data.frame(tableI3_)
colnames(dfI3)<-c("TranscationNo9","Date","TranscationAccountNo9","TranscationType9","Amount9","Currency9","ConversionRateUSD","ConversionRateCNY",
                  "SGDAmount9","Fees9","Combined9")
df_with_I3<-rbind(dfCal3,dfI3)

Month3<-rep("Sep",100)
tableM3<-cbind(df_with_I3,Month3)
df_with_M3<-data.frame(tableM3)
colnames(df_with_M3)<-c("TransNo","Date","TransAccountNo","TransType","Amount","Currency","ConverRateUSD","ConverRateCNY","Amount(in SGD)",
                        "Fees","Combined","Month")


colnames(dfa)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","Currency")
colnames(dfb)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","Currency")
colnames(dfc)<-c("TransactionNo","Date","AccountNo","TransactionType","Amount","Currency")
df3<-data.frame(rbind(dfa,dfb,dfc))

df_with_M123<-rbind(df_with_M1,df_with_M2,df_with_M3)
df_op_client<-df_with_M123[c("TransNo","TransAccountNo","Date","TransType","Currency","Amount","Amount(in SGD)","Month")]

df_sum_Jul_account<-cbind(df_sum_Jul_account,Month=rep("Jul",10))
df_sum_Aug_account<-cbind(df_sum_Aug_account,Month=rep("Aug",10))
df_sum_Sep_account<-cbind(df_sum_Sep_account,Month=rep("Sep",10))
df_sum<-rbind(df_sum_Jul_account,df_sum_Aug_account,df_sum_Sep_account)
colnames(df_sum)<-c("AccountNo","Name","BegainningBalance","BegainningCredit","Type1","DepositAmount","Type2",
                    "SpendAmount","Type3","WithdrawAmount","DepoBalanceWithoutInterest","CreditBalance","InterestPayment",
                    "EndBalance","Month")
View(df_sum)

df_op_client<-df_op_client[order(df_op_client$Date),]
View(df_op_client)


df_with_M123<-df_with_M123[order(df_with_M123$Date),]

View(df_with_M123)

save(df3,file="df3.Rda")
save(df_with_M123,file="df_with_M123.Rda")
save(df_op_client,file="df_op_client.Rda")
save(df_sum,file="df_sum.Rda")



