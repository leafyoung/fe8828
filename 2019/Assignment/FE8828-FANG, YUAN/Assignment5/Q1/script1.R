library(stringr)
library(tidyverse)
library(ggplot2)
library(reshape)
library(plotly)


load('e://R working directory//ExchangeRates.Rda')

Account<-setClass("Account",
                  slots = c(
                    Information="data.frame"
                  ),
                  prototype = list(
                    Information=data.frame(
                      AccountNo=sample(100000:999999,10,replace=FALSE),
                      Name= paste0(sample(LETTERS,10),replicate(10,paste0(sample(letters,sample(2:5,1)),collapse = ""))),
                      Deposit=sample(1000:2000,10),
                      Credit=rep(2000,10),
                      OpenTime=rep(as.Date("2019-07-01"),10)
                    )
                  )
)

#Inherit info from Account
Transaction<-setClass(
  "Transaction",
  slots = c(
    TransactionInfo="data.frame",
    FXR="data.frame",
    Cbalance="list",
    PnL="data.frame"
    
  ),
  contains = "Account",
  prototype = list(
    TransactionInfo=data.frame(
      No=0,
      TransactionNo=str_pad(0, 10, "left",0),
      Date=as.Date("2019-07-01"),
      AccountNo=0,
      TransactionType="Null",
      Amount=0,
      Currency="Null"
    ),
    FXR=EXRS,                        
    Cbalance=list(),
    PnL=data.frame(
      Date=as.Date("2019-07-01"),
      TotalDeposit=0,
      TotalFXCredit=0,
      TotalDCredit=0,
      TotalCredit=0,
      PnLfromClientSpending=0
    )
    
  )
)


#setGeneric("Display",function(obj,...) standardGeneric("Display"))
setGeneric("Generate",function(obj,...) standardGeneric("Generate"))
setGeneric("Reset",function(obj,...) standardGeneric("Reset"))
setGeneric("Deposit",function(obj,...) standardGeneric("Deposit"))
setGeneric("Withdraw",function(obj,...) standardGeneric("Withdraw"))
setGeneric("Spend",function(obj,...) standardGeneric("Spend"))
setGeneric("Interest",function(obj,...) standardGeneric("Interest"))

#Initialize an object
setGeneric("Initial",function(obj,...) standardGeneric("Initial"))

#Generate historic transaction data
setGeneric("GenHisData",function(obj,...) standardGeneric("GenHisData"))

#Month Transaction History
setGeneric("MTHistory",function(obj,...) standardGeneric("MTHistory"))

#month summary
setGeneric("MTSummary",function(obj,...) standardGeneric("MTSummary"))


#Bank PnL
setGeneric("BankPnL",function(obj,...) standardGeneric("BankPnL"))

#RiskTable
setGeneric("RiskTable",function(obj,...) standardGeneric("RiskTable"))

#client's balance chart
setGeneric("BalanceChart",function(obj,...) standardGeneric("BalanceChart"))


#DCchart
setGeneric("DCchart",function(obj,...) standardGeneric("DCchart"))

#Open a new account
setGeneric("OpenAccount",function(obj,...) standardGeneric("OpenAccount"))

setMethod("Generate","Account",function(obj){
  obj@Information$AccountNo<-sample(100000:999999,10,replace=FALSE)
  obj@Information$Name <- paste0(sample(LETTERS,10),replicate(10,paste0(sample(letters,sample(2:5,1)),collapse = "")))
  obj@Information$Deposit<-sample(1000:2000,10)
  obj@Information$Credit<-rep(2000,10)
  obj # Yang: return obj here
})

setMethod("Reset","Account",function(obj,accountno,deposit,credit){
  obj@Information[obj@Information$AccountNo==accountno,]$Deposit<-deposit
  obj@Information[obj@Information$AccountNo==accountno,]$Credit<-credit
  obj # Yang: return obj here
})

setMethod("Reset","Transaction",function(obj,accountno,deposit,credit){
  obj@Information[obj@Information$AccountNo==accountno,]$Deposit<-deposit
  obj@Information[obj@Information$AccountNo==accountno,]$Credit<-credit
  obj # Yang: return obj here
})

setMethod("Initial","Transaction",function(obj){
  accounts<-obj@Information$AccountNo
  totaldeposit<-0
  #totalcredit<-0
  for (i in accounts) {
    data<-obj@Information[obj@Information$AccountNo==i,]
    obj@Cbalance[[as.character(i)]]<-data.frame(
      Date=as.Date("2019-07-01"),
      TransactionType = "Null",
      Currency = "Null",
      Amount = 0,
      Amount_in_SGD = 0,
      TotalFXSpend=0,
      TotalDSpend=0,
      Deposit_Balance = data$Deposit,
      Credit_Balance = data$Credit
    )
    totaldeposit<-totaldeposit+data$Deposit
    #totalcredit<-totalcredit+data$Credit
  }
  obj@PnL$TotalDeposit[1]<-totaldeposit
  #obj@PnL$TotalCredit[1]<-totalcredit
  return(obj)
})

#Three different transactions:Deposit, Withdraw & Spend 

#Deposit
setMethod("Deposit","Transaction",function(obj,date,accountno,amount,currency){
  account<-obj@Information$AccountNo
  if(accountno %in% account){
    date1<-as.Date(date)
    if(date1>as.Date("2019-10-01")){
      exr=case_when(
        currency=="USD" ~ 1.3813,
        currency=="CNY" ~ 0.1939,
        currency=="SGD" ~ 1,
      )
    }else {
      exr<-filter(obj@FXR,Date==date1)[currency][1,1]}
    amount1<-amount*exr
    newtrs<-Transaction()
    newtrs@TransactionInfo$No<-obj@TransactionInfo$No[length(obj@TransactionInfo$No)]+1
    newtrs@TransactionInfo$TransactionNo<-str_pad(newtrs@TransactionInfo$No, 10, "left",0)
    newtrs@TransactionInfo$Date<-as.Date(date)
    newtrs@TransactionInfo$AccountNo<-accountno
    newtrs@TransactionInfo$TransactionType<-"Deposit"
    newtrs@TransactionInfo$Amount<-amount
    newtrs@TransactionInfo$Currency<-currency
    obj@TransactionInfo<-rbind.data.frame(obj@TransactionInfo,newtrs@TransactionInfo,make.row.names = FALSE)
    obj<-Reset(obj,
               accountno,
               (obj@Information[obj@Information$AccountNo==accountno,]$Deposit+amount1),
               obj@Information[obj@Information$AccountNo==accountno,]$Credit)
    
    # change balance table
    nn<-nrow(obj@Cbalance[[as.character(accountno)]])
    nbl<-obj@Cbalance[[as.character(accountno)]][nn,]
    nbl$Date<-date1
    nbl$TransactionType<-"Deposit"
    nbl$Currency<-currency
    nbl$Amount<-amount
    nbl$Amount_in_SGD<-amount1
    nbl$Deposit_Balance<-nbl$Deposit_Balance+amount1
    cbl<-obj@Cbalance[[as.character(accountno)]]
    cbl<-rbind.data.frame(cbl,nbl,make.row.names = FALSE)
    obj@Cbalance[[as.character(accountno)]]<-cbl
    
    # change PnL table
    pnldate<-obj@PnL$Date
    if(date1 %in% pnldate){
      obj@PnL[pnldate==date1,]$TotalDeposit<-obj@PnL[pnldate==date1,]$TotalDeposit+amount1
    }else{
      oldeposit<-obj@PnL[nrow(obj@PnL),]$TotalDeposit
      
      #pnl<-obj@PnL[nrow(obj@PnL),]$TotalFXCredit*FXIR+obj@PnL[nrow(obj@PnL),]$TotalDCredit*IR
      #obj@PnL[nrow(obj@PnL),]$PnLfromClientSpending<-pnl
      
      t1<-obj@PnL[nrow(obj@PnL),]
      t1$PnLfromClientSpending<-0
      t1$Date<-date1
      t1$TotalDeposit<-oldeposit+amount1
      obj@PnL<-rbind.data.frame(obj@PnL,t1,make.row.names = FALSE)
    }
    
  }
  obj
})

#Withdraw
setMethod("Withdraw","Transaction",function(obj,date,accountno,amount,currency){
  account<-obj@Information$AccountNo
  if(accountno %in% account){
    date1<-as.Date(date)
    if(date1>as.Date("2019-10-01")){
      exr=case_when(
        currency=="USD" ~ 1.3813,
        currency=="CNY" ~ 0.1939,
        currency=="SGD" ~ 1,
      )
    }else {
      exr<-filter(obj@FXR,Date==date1)[currency][1,1]}
    amount1<-amount*exr
    account<-obj@Information[obj@Information$AccountNo==accountno,]
    if(account$Deposit>amount1){
      newtrs<-Transaction()
      newtrs@TransactionInfo$No<-obj@TransactionInfo$No[length(obj@TransactionInfo$No)]+1
      newtrs@TransactionInfo$TransactionNo<-str_pad(newtrs@TransactionInfo$No, 10, "left",0)
      newtrs@TransactionInfo$Date<-as.Date(date)
      newtrs@TransactionInfo$AccountNo<-accountno
      newtrs@TransactionInfo$TransactionType<-"Withdraw"
      newtrs@TransactionInfo$Amount<-(-1)*amount
      newtrs@TransactionInfo$Currency<-currency
      obj@TransactionInfo<-rbind.data.frame(obj@TransactionInfo,newtrs@TransactionInfo,make.row.names = FALSE)
      obj<-Reset(obj,
                 accountno,
                 (account$Deposit-amount1),
                 account$Credit)
      
      # change balance table
      nn<-nrow(obj@Cbalance[[as.character(accountno)]])
      nbl<-obj@Cbalance[[as.character(accountno)]][nn,]
      nbl$Date<-date1
      nbl$TransactionType<-"Withdraw"
      nbl$Currency<-currency
      nbl$Amount<-(-1)*amount
      nbl$Amount_in_SGD<-(-1)*amount1
      nbl$Deposit_Balance<-nbl$Deposit_Balance-amount1
      cbl<-obj@Cbalance[[as.character(accountno)]]
      cbl<-rbind.data.frame(cbl,nbl,make.row.names = FALSE)
      obj@Cbalance[[as.character(accountno)]]<-cbl
      
      # change PnL table
      pnldate<-obj@PnL$Date
      if(date1 %in% pnldate){
        obj@PnL[pnldate==date1,]$TotalDeposit<-obj@PnL[pnldate==date1,]$TotalDeposit-amount1
      }else{
        
        oldeposit<-obj@PnL[nrow(obj@PnL),]$TotalDeposit
        #pnl<-obj@PnL[nrow(obj@PnL),]$TotalFXCredit*FXIR+obj@PnL[nrow(obj@PnL),]$TotalDCredit*IR
        #obj@PnL[nrow(obj@PnL),]$PnLfromClientSpending<-pnl
        t1<-obj@PnL[nrow(obj@PnL),]
        t1$PnLfromClientSpending<-0
        t1$Date<-date1
        t1$TotalDeposit<-oldeposit-amount1
        obj@PnL<-rbind.data.frame(obj@PnL,t1,make.row.names = FALSE)
      }
      
    }
  }
  return(obj)
})


setMethod("Spend","Transaction",function(obj,date,accountno,amount,currency){
  account<-obj@Information$AccountNo
  if(accountno %in% account){
    date1<-as.Date(date)
    date2<-date1-1
    month1<-as.numeric(substring(date1,6,7))
    month2<-as.numeric(substring(date2,6,7))
    if(date1>as.Date("2019-10-01")){
      exr=case_when(
        currency=="USD" ~ 1.3813,
        currency=="CNY" ~ 0.1939,
        currency=="SGD" ~ 1,
      )
    }else {
      exr<-filter(obj@FXR,Date==date1)[currency][1,1]}
    amount1<-amount*exr
    account<-obj@Information[obj@Information$AccountNo==accountno,]
    if(account$Credit>amount1){
      newtrs<-Transaction()
      newtrs@TransactionInfo$No<-obj@TransactionInfo$No[length(obj@TransactionInfo$No)]+1
      newtrs@TransactionInfo$TransactionNo<-str_pad(newtrs@TransactionInfo$No, 10, "left",0)
      newtrs@TransactionInfo$Date<-as.Date(date)
      newtrs@TransactionInfo$AccountNo<-accountno
      newtrs@TransactionInfo$TransactionType<-"Spend"
      newtrs@TransactionInfo$Amount<-(-1)*amount
      newtrs@TransactionInfo$Currency<-currency
      obj@TransactionInfo<-rbind.data.frame(obj@TransactionInfo,newtrs@TransactionInfo,make.row.names = FALSE)
      obj<-Reset(obj,
                 accountno,
                 account$Deposit,
                 (account$Credit-amount1))
      
      # change balance table
      nn<-nrow(obj@Cbalance[[as.character(accountno)]])
      nbl<-obj@Cbalance[[as.character(accountno)]][nn,]
      nbl$Date<-date1   
      nbl$TransactionType<-"Spend"
      nbl$Currency<-currency
      nbl$Amount<-(-1)*amount
      nbl$Amount_in_SGD<-(-1)*amount1
      preTFXSpend<-nbl$TotalFXSpend
      preTDSpend<-nbl$TotalDSpend
      if(currency %in% c("USD","CNY")){
        nbl$TotalFXSpend<-nbl$TotalFXSpend+amount1
      }else{
        nbl$TotalDSpend<-nbl$TotalDSpend+amount1
      }
      nbl$Credit_Balance<-nbl$Credit_Balance-amount1
      cbl<-obj@Cbalance[[as.character(accountno)]]
      cbl<-rbind.data.frame(cbl,nbl,make.row.names = FALSE)
      obj@Cbalance[[as.character(accountno)]]<-cbl
      
      # change PnL table
      pnldate<-obj@PnL$Date
      if(date1 %in% pnldate){
        obj@PnL[pnldate==date1,]$TotalCredit<-obj@PnL[pnldate==date1,]$TotalCredit+amount1
        if(currency %in% c("USD","CNY")){
          obj@PnL[pnldate==date1,]$TotalFXCredit<-obj@PnL[pnldate==date1,]$TotalFXCredit+amount1
          # if(month1!=month2){
          #   #Interest payment would be levied on the 1st day of a month
          #   #according to total spending amount on the last day
          #   obj@PnL[pnldate==date1,]$PnLfromClientSpending<-preTFXSpend*FXIR
          #     
          # }else{
          #   obj@PnL[pnldate==date1,]$PnLfromClientSpending<-0
          # }
        }else{
          obj@PnL[pnldate==date1,]$TotalDCredit<-obj@PnL[pnldate==date1,]$TotalDCredit+amount1
          
          # if(month1!=month2){
          #   obj@PnL[pnldate==date1,]$PnLfromClientSpending<-preTDSpend*IR
          # }else{
          #   obj@PnL[pnldate==date1,]$PnLfromClientSpending<-0
          # }          
        }
        
      }else{
        
        oldcredit<-obj@PnL[nrow(obj@PnL),]$TotalCredit
        FXcredit<-obj@PnL[nrow(obj@PnL),]$TotalFXCredit
        Dcredit<-obj@PnL[nrow(obj@PnL),]$TotalDCredit
        #pnl<-obj@PnL[nrow(obj@PnL),]$TotalFXCredit*FXIR+obj@PnL[nrow(obj@PnL),]$TotalDCredit*IR
        #obj@PnL[nrow(obj@PnL),]$PnLfromClientSpending<-pnl
        t1<-obj@PnL[nrow(obj@PnL),]
        t1$PnLfromClientSpending<-0
        t1$Date<-date1
        t1$TotalCredit<-oldcredit+amount1
        if(currency %in% c("USD","CNY")){
          t1$TotalFXCredit<-FXcredit+amount1
        }else{
          t1$TotalDCredit<-Dcredit+amount1
        }
        obj@PnL<-rbind.data.frame(obj@PnL,t1,make.row.names = FALSE)
      }
    }
  }
  return(obj)
})


setMethod("Interest","Transaction",function(obj,date){
  date1<-as.Date(date)
  
  #
  for(accountno in obj@Information$AccountNo){
    nn<-nrow(obj@Cbalance[[as.character(accountno)]])
    nbl<-obj@Cbalance[[as.character(accountno)]][nn,]
    
    iearn<-nbl$Deposit_Balance[1]*DIR
    ifxpay<-nbl$TotalFXSpend[1]*FXIR
    idpay<-nbl$TotalDSpend[1]*IR
    
    
    amount1<-iearn-ifxpay-idpay
    newtrs<-Transaction()
    newtrs@TransactionInfo$No<-obj@TransactionInfo$No[length(obj@TransactionInfo$No)]+1
    newtrs@TransactionInfo$TransactionNo<-str_pad(newtrs@TransactionInfo$No, 10, "left",0)
    newtrs@TransactionInfo$Date<-as.Date(date)
    newtrs@TransactionInfo$AccountNo<-accountno
    newtrs@TransactionInfo$TransactionType<-"Interest"
    newtrs@TransactionInfo$Amount<-amount1
    newtrs@TransactionInfo$Currency<-"SGD"
    obj@TransactionInfo<-rbind.data.frame(obj@TransactionInfo,newtrs@TransactionInfo,make.row.names = FALSE)
    obj<-Reset(obj,
               accountno,
               (obj@Information[obj@Information$AccountNo==accountno,]$Deposit+amount1),
               obj@Information[obj@Information$AccountNo==accountno,]$Credit)
    
    # change balance table
    nn<-nrow(obj@Cbalance[[as.character(accountno)]])
    nbl<-obj@Cbalance[[as.character(accountno)]][nn,]
    nbl$Date<-date1
    nbl$TransactionType<-"Interest"
    nbl$Currency<-"SGD"
    nbl$Amount<-amount1
    nbl$Amount_in_SGD<-amount1
    nbl$Deposit_Balance<-nbl$Deposit_Balance+amount1
    cbl<-obj@Cbalance[[as.character(accountno)]]
    cbl<-rbind.data.frame(cbl,nbl,make.row.names = FALSE)
    obj@Cbalance[[as.character(accountno)]]<-cbl
  }
  # change PnL table
  pnldate<-obj@PnL$Date
  t<-obj@PnL[nrow(obj@PnL),]
  deposit<-t$TotalDeposit[1]*DIR-t$TotalFXCredit[1]*FXIR-t$TotalDCredit[1]*IR
  pnl<-t$TotalFXCredit[1]*FXIR+t$TotalDCredit[1]*IR
  #lastdate<-pnldate[length(pnldate)]
  if( date1 %in% pnldate){
    obj@PnL[pnldate==date1,]$TotalDeposit<-obj@PnL[pnldate==date1,]$TotalDeposit+deposit
    obj@PnL[pnldate==date1,]$PnLfromClientSpending<-obj@PnL[pnldate==date1,]$PnLfromClientSpending+pnl
    
  }else{
    t1<-obj@PnL[nrow(obj@PnL),]
    t1$Date<-date1
    t1$TotalDeposit<-t1$TotalDeposit+deposit
    t1$PnLfromClientSpending<-pnl
    obj@PnL<-rbind.data.frame(obj@PnL,t1,make.row.names = FALSE)
  }
  
  
  
  obj
})



Genmondata<-function(month){
  trsc<-c(rep("D",sample(1:2,1)),rep("W",sample(0:1000,1)),rep("S",sample(0:1000,1)))
  Monthtrs<-cbind(trsc,rep(1,length(trsc)))
  Alltrs<-Monthtrs
  for (i in 2:10) {
    trsc<-c(rep("D",sample(1:2,1)),rep("W",sample(0:1000,1)),rep("S",sample(0:1000,1)))
    Monthtrs<-cbind(trsc,rep(i,length(trsc)))
    Alltrs<-rbind.data.frame(Alltrs,Monthtrs)
  }
  Alltrs<-as.data.frame(Alltrs)
  names(Alltrs)<-c("Type","Client")
  Alltrs<-Alltrs[sample(1:nrow(Alltrs)),]
  Date<-sample(seq(as.Date(paste0("2019-",str_pad(month,2, "left",0),"-01")),
                   (as.Date(paste0("2019-",str_pad((month+1),2, "left",0),"-01"))-1),
                   by="day"),nrow(Alltrs),replace = TRUE)
  Alltrs<-cbind.data.frame(Date,Alltrs)
  Alltrs<-arrange(Alltrs,Date)
  return(Alltrs)
}


setMethod("GenHisData","Transaction",function(obj){
  # TRIF<-obj@TransactionInfo
  # obj@TransactionInfo<-TRIF[-1*(2:nrow(TRIF)),]
  data<-lapply(7:9,Genmondata)
  data<-rbind.data.frame(data[[1]],data[[2]],data[[3]],make.row.names = FALSE)
  lastdate<-data$Date[nrow(data)]
  for (i in 1:nrow(data)) {
    temp<-data[i,]
    accountno<-obj@Information$AccountNo[temp["Client"][1,]]
    type<-temp["Type"][1,]
    date<-temp["Date"][1,]
    
    #   monthdate<-seq(as.Date(paste0("2019-",str_pad(month,2, "left",0),"-01")),
    #             (as.Date(paste0("2019-",str_pad((month+1),2, "left",0),"-01"))-1),
    #             by="day")
    #   for (n in allaccounts) {
    #     acn<-obj@Cbalance[[as.character(n)]]
    #     acn<-mutate(acn,total)
    #     md<-MTHistory(obj,n,month1)
    #     depositInt<-acn[["Deposit_Balance"]][nrow(acn)]*DIR
    #     
    #     
    #     FXSpend<-filter(acn,(Currency %in% c("USD","CNY")) & TransactionType=="Spend")
    #     FXSpend<-mutate(FXSpend,TFXSpend=cumsum(unlist(Amount_in_SGD)))
    #     MonthFXSpend<-filter(FXSpend,Date %in% monthdate)
    #     FXInt<-(cumsum(unlist(FXpend))*FXIR)[range]
    #     TFXInt<-sum(FXInt)
    #     DSpend<-filter(acn,(Currency %in% c("SGD")) & TransactionType=="Spend")$Amount_in_SGD
    #     TDSpend<-sum(unlist(DSpend))
    #     DInt<-cumsum((unlist(DSpend))*IR)[range]
    #     TDInt<-sum(DInt)
    #     creditInt<-TFSpend*
    #   }
    # }
    
    if(type=="D"){
      amount<-sample(1000:2000,1)
      currency<-sample(c("SGD","USD","CNY"),1)
      obj<-Deposit(obj,date,accountno,amount,currency)
    }else if(type=="W"){
      amount<-round((rnorm(1,1,1))^2,2)+0.01
      currency<-sample(c("SGD","USD","CNY"),1)
      obj<-Withdraw(obj,date,accountno,amount,currency)
    }else if(type=="S"){
      amount<-round((rnorm(1,1,1))^2,2)+0.01
      currency<-sample(c("SGD","USD","CNY"),1)
      obj<-Spend(obj,date,accountno,amount,currency)
    }
    
    if(i<nrow(data)){
      nextdate<-data[i+1,]$Date[1]     
      month1<-as.numeric(substring(nextdate,6,7))
      month2<-as.numeric(substring(date,6,7))
      
      #monthly interest payment of deposit and credit,would be paid at the end of the month.
      
      if(month1!=month2){
        obj<-Interest(obj,date)
      }
    }
    
  }
  obj@TransactionInfo<-obj@TransactionInfo[-1,]
  if(lastdate==as.Date("2019-09-30")){
    obj<-Interest(obj,lastdate)
  }
  return(obj)
})


setMethod("MTHistory","Transaction",function(obj,clientname,month){
  accountno<-filter(obj@Information,Name==clientname)$AccountNo
  Data<-obj@Cbalance[[as.character(accountno)]]
  monthdate<-seq(as.Date(paste0("2019-",str_pad(month,2, "left",0),"-01")),
                 (as.Date(paste0("2019-",str_pad((month+1),2, "left",0),"-01"))-1),
                 by="day")
  MonthData<-Data[(Data$Date %in% monthdate),]
  return(MonthData)
})

setMethod("MTSummary","Transaction",function(obj,clientname,month){
  data<-MTHistory(obj,clientname,month)
  deposit<-data[(data$TransactionType)=="Deposit",]
  withdraw<-data[(data$TransactionType)=="Withdraw",]
  spend<-data[(data$TransactionType)=="Spend",]
  interest<-data[(data$TransactionType)=="Interest",]
  totalDeposit<-sum(unlist(deposit["Amount_in_SGD"]))
  totalwithdraw<-sum(unlist(withdraw["Amount_in_SGD"]))
  totalspend<-sum(unlist(spend["Amount_in_SGD"]))
  totalinterest<-sum(unlist(interest["Amount_in_SGD"]))
  df1<-data.frame(TransactionType=c("Deposit","Withdraw","Spend","Interest"))
  df2<-data.frame(Amount=c(totalDeposit,totalwithdraw,totalspend,totalinterest))
  df<-cbind.data.frame(df1,df2)
  return(df)
})

setMethod("BankPnL","Transaction",function(obj,month){
  pnl<-obj@PnL
  monthdate<-seq(as.Date(paste0("2019-",str_pad(month,2, "left",0),"-01")),
                 (as.Date(paste0("2019-",str_pad((month+1),2, "left",0),"-01"))-1),
                 by="day")
  monthpnl<-pnl[(pnl$Date %in% monthdate),]
  return(monthpnl)
})



setMethod("RiskTable","Transaction",function(obj,month){
  Names<-filter(obj@Information,
               OpenTime<=as.Date(paste0("2019-",str_pad((month+1),2, "left",0),"-01"))-1)$Name
  table<-data.frame()
  if(month<10){
  for (ClientName in Names) {
    dt<-MTHistory(obj,ClientName,month)
    enddata<-dt[nrow(dt),]
    Deposit<-enddata$Deposit_Balance
    Credit<-enddata$Credit_Balance
    Spread<-Credit-Deposit
    dt1<-cbind.data.frame(ClientName,Deposit,Credit,Spread)
    table<-rbind.data.frame(table,dt1)
  }
  }else{
    for (ClientName in Names) {
      accountno<-filter(obj@Information,Name==ClientName)$AccountNo
      dt<-obj@Cbalance[[as.character(accountno)]]
      enddata<-dt[nrow(dt),]
      Deposit<-enddata$Deposit_Balance
      Credit<-enddata$Credit_Balance
      Spread<-Credit-Deposit
      dt1<-cbind.data.frame(ClientName,Deposit,Credit,Spread)
      table<-rbind.data.frame(table,dt1)
    }
    }
  table<-arrange(table,by=desc(Spread))
  table<-table[c("ClientName","Deposit","Credit")]
  return(table)
  
})

setMethod("BalanceChart","Transaction",function(obj,clientname,month){
  data<-MTHistory(obj,clientname,month)
  monthdate<-unique(data$Date)
  balancetable<-data.frame()
  for (day in monthdate) {
    ddt<-filter(data, Date %in% day)
    lastddt<-ddt[nrow(ddt),]
    Credit_Balance<-lastddt$Credit_Balance
    Deposit_Balance<-lastddt$Deposit_Balance
    dt<-cbind.data.frame(day,Credit_Balance,Deposit_Balance)
    balancetable<-rbind.data.frame(balancetable,dt)
  }  
  names(balancetable)<-c("Date","Credit_Balance","Deposit_Balance")
  data1 <- melt(balancetable, id="Date") 
  chart<-ggplot(data=data1, aes(x=Date, y=value, colour=variable)) + geom_line()
  return(chart)
  
})


setMethod("DCchart","Transaction",function(obj,month){
  data<-BankPnL(obj,month)[c("Date","TotalDeposit","TotalCredit")]
  data1 <- melt(data, id="Date") 
  chart<-ggplot(data=data1, aes(x=Date, y=value, colour=variable)) + geom_line()
  return(chart)
})


setMethod("OpenAccount","Transaction",function(obj,clientname,deposit,credit){
  possibleaccountno<-setdiff(c(100000:999999),obj@Information$AccountNo)
  AccountNo<-sample(possibleaccountno,1)
  OpenTime<-Sys.Date()
  info<-cbind.data.frame(AccountNo,clientname,deposit,credit,OpenTime)
  names(info)<-c("AccountNo","Name","Deposit","Credit","OpenTime")
  obj@Information<-rbind.data.frame(obj@Information,info)
  date<-Sys.Date()
  obj@Cbalance[[as.character(AccountNo)]]<-data.frame(
    Date=date,
    TransactionType = "Null",
    Currency = "Null",
    Amount = 0,
    Amount_in_SGD = 0,
    TotalFXSpend=0,
    TotalDSpend=0,
    Deposit_Balance = deposit,
    Credit_Balance = credit
  )
  dt1<-obj@PnL[nrow(obj@PnL),]
  dt1$Date<-date
  dt1$TotalDeposit<-dt1$TotalDeposit+deposit
  obj@PnL<-rbind.data.frame(obj@PnL,dt1)
  return(obj)
})

# Create and Save dataframe
#codes are commented, but actually usable 


# tx<-Transaction()
# tx<-Initial(tx)
# tx<-GenHisData(tx)
# EXRS<-tx@FXR
# transactiondata<-tx@TransactionInfo
# clients<-tx@Information
# save("EXRS",file = 'e://R working directory//ExchangeRates.Rda')
# save("transactiondata",file = 'e://R working directory//transactiondata.Rda')
# save("clients",file = 'e://R working directory//clients.Rda')
# 

