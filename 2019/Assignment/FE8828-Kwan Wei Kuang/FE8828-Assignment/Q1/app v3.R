library(bizdays)
library(shiny)
library(tidyr)
library(dplyr)
library(randNames)
library(httr)
library(jsonlite)
library(readr)
library(lubridate)
library(tidyverse)
library(ggplot2)

############
#Assumptions
############

# Credit of 2000 is not refering to credit limit. This 2000 is an initial spending amount. 
# There is no repayment of credit in our assumption, and we assume that all clients have a high credit limit. 
# Hence sum of credit is monotonically increasing.
# The sum of credit in the table would then give us the total spendings. 
# Credit limit if imposed, is suggested to be stored outside the transaction table, instead of a row in the transaction table. 
# This suggestion is proposed due to the following advantages. Credit limit changes can be easily tracked,
# the credit amount a person has left can be easily calculated,
# and the sum of credit in the transaction table would then purely reflect spending which is in-lined with the purpose of the table description.  
# The graph in the client view is on three items: 1. Deposit
#                                                 2. Balance = Deposit - Withdraw
#                                                 3. Credit
# Deposit balance is only on deposit.

#specify functions
createCurrencydf<-function(){
  ############################
  # 1. Conversion rate table #
  ############################
  
  masURL = "https://eservices.mas.gov.sg/api/action/datastore/search.json?"
  resourceID ="95932927-c8bc-4e7a-b484-68a66a24edfe"
  betweenDate = "2019-07-01,2019-09-30"
  fields = "end_of_day,cny_sgd_100,usd_sgd"
  #specify requirement in URL
  url=paste0(masURL,"resource_id=",resourceID,"&between[end_of_day]=",betweenDate,"&fields=",fields)
    
  agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
    
  getCurrencyPage <- GET(url,user_agent(agent))       
  getCurrencytext <- content(getCurrencyPage, "text")
  getCurrenncyjson <- fromJSON(getCurrencytext, flatten = TRUE)
  dfCurrencyRateRaw <- as.data.frame(getCurrenncyjson)
  dfCurrencyRate <- select(dfCurrencyRateRaw,5,6,7)%>%rename(Date=result.records.end_of_day,CNY=result.records.cny_sgd_100,USD=result.records.usd_sgd)
  dfCurrencyRate$SGD <- 1
  dfCurrencyRate=transform(Date=as.Date(Date),dfCurrencyRate,CNY=as.numeric(CNY),USD=as.numeric(USD))%>%transform(CNY=CNY/100)
    
  #fill in the missing dates
  datesrange <- bizseq("2019-07-01","2019-09-30")
  numdays <- length(datesrange)
    
  dfCurrencyRateWithWkEnd<-left_join(data.frame(Date=datesrange),dfCurrencyRate,by="Date")
  for (i in 1:numdays){
    #if not found in MAS table, set the exchange rate as the day before
    if(is.na(dfCurrencyRateWithWkEnd$CNY[i])){
      dfCurrencyRateWithWkEnd$CNY[i]=dfCurrencyRateWithWkEnd$CNY[i-1]
      dfCurrencyRateWithWkEnd$USD[i]=dfCurrencyRateWithWkEnd$USD[i-1]
      dfCurrencyRateWithWkEnd$SGD[i]=1
    }
  }
    
  dfLongCurRate = gather(dfCurrencyRateWithWkEnd,Currency, Conversion, -Date)%>%arrange(Date) 
  save(dfLongCurRate,file="currencyrate.rda") 
  return(dfLongCurRate)
}

createTransactiondf<-function(n,dfCurRateLong){
  ########################
  # 2. Transaction table #
  ########################
  
  #n is mean number of spend or withdraw in a month
    
  #create a df to store bank charges from client spending
  dfCharges<- data.frame(Currency=c("USD","CNY","SGD"),Rate=c(1+(0.02/12),1+(0.02/12),1+(0.01/12)),stringsAsFactors = FALSE)
  
  #Initialize deposits
  dfTransaction <- data.frame(TransactionNo=1:10,Date=as.Date("2019-07-01"),AccountNo=1:10,TransactionType="Deposit",Amount=runif(10,1000,2000),Currency="SGD",stringsAsFactors=FALSE)
    
  #Initialize credit
  dfTransaction <- bind_rows(dfTransaction,data.frame(TransactionNo=11:20,Date=as.Date("2019-07-01"),AccountNo=1:10,TransactionType="Spend",Amount=-2000,Currency="SGD",stringsAsFactors=FALSE))
    
  #For everyday
  for(day in as.list(unique(dfCurRateLong$Date))){
    #For every person
    for(AccNo in 1:10){
      
      #Deposit fixed on certain day of the month for every person
      set.seed(AccNo)
                
      #Set the days for deposit for each person once or twice a month
      monthdeposit <- sample(1:2, 3, replace=T)
      depositJuly=sample(seq(as.Date("2019-07-01"),as.Date("2019-07-31"),"days"),monthdeposit[1])
      depositAug =sample(seq(as.Date("2019-08-01"),as.Date("2019-08-31"),"days"),monthdeposit[2])
      depositSept=sample(seq(as.Date("2019-09-01"),as.Date("2019-09-30"),"days"),monthdeposit[3])
      depositDates= sort(append(append(depositJuly,depositAug),depositSept),decreasing = FALSE)
      
      #Remove the fix seed used for deposit
      rm(list=".Random.seed", envir=globalenv())
        
      #1. Deposit - If today is deposit day, deposit for that person
      if (day %in% depositDates){
        dfTransaction[nrow(dfTransaction)+1,]=list(nrow(dfTransaction)+1,day,AccNo,"Deposit",Amount=runif(1,1000,2000),unique(dfCurRateLong$Currency)[[sample(1:3,1)]])
      }  
                
      #2. Spending (+ FX Charges)
      #chance of spending given n transaction / month, assuming 30days in a month
      if(runif(1,0,1)<n/30){
        spending <- rnorm(1,-2000/(3*n),5)
        ccy <- unique(dfCurRateLong$Currency)[[sample(1:3,1)]]
        
       
        if(spending*dfCurRateLong$Conversion[which(dfCurRateLong$Date == day & dfCurRateLong$Currency == ccy)]*dfCharges$Rate[which(dfCharges$Currency == ccy)] < 2000){
          #FX Charges included
          dfTransaction[nrow(dfTransaction)+1,]=list(nrow(dfTransaction)+1,day,AccNo,"Spend",Amount=spending*dfCharges$Rate[which(dfCharges$Currency == ccy)],ccy)
        }
      }
                
      #3. Withdraw
      #find the total deposit spending in SGD
      depositSGDTotal<-dfTransaction %>% dplyr::filter(AccountNo==AccNo,TransactionType=="Deposit") %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>% group_by(AccountNo) %>% summarise(totalsgd=sum(sgd)) %>% .[1,2] %>% as.numeric()
            
      #find the total withdrawal in SGD
      withdrawSGDTotal<-dfTransaction %>% dplyr::filter(AccountNo==AccNo,TransactionType=="Withdraw") %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>% group_by(AccountNo) %>% summarise(totalsgd=sum(sgd)) %>% .[1,2] %>% as.numeric()
      #if total withdrawal is 0, have to address the NA. Happens only before first withdrawal 
      if (is.na(withdrawSGDTotal)){
        withdrawSGDTotal = 0
      }
                
      #decide a withdrawal amount dependent on balance, but still a random variable
      withdrawAmount=rnorm(1,-(depositSGDTotal+withdrawSGDTotal)/(3*n),5)
      #decide a withdrawal currency
      withdrawCur = unique(dfCurRateLong$Currency)[[sample(1:3,1)]]
                
      #convert withdraw Amt to SGD
      withdrawAmountSGD = withdrawAmount*dfCurRateLong%>%dplyr::filter(Date==day,Currency==withdrawCur) %>% .$Conversion
                
      if (-withdrawAmountSGD<=(depositSGDTotal+withdrawSGDTotal)){
      #chance of withdrawing given n transaction / month, assuming 30days in a month
        if(runif(1,0,1)<n/30){
          dfTransaction[nrow(dfTransaction)+1,]=list(nrow(dfTransaction)+1,day,AccNo,"Withdraw",Amount=withdrawAmount,withdrawCur)
          withdrawSGDTotal<-dfTransaction %>% dplyr::filter(AccountNo==AccNo,TransactionType=="Withdraw") %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>% group_by(AccountNo) %>% summarise(totalsgd=sum(sgd)) %>% .[1,2] %>% as.numeric()
        }
      }
    
      #4. Interest Payments as deposit
      if (day %in% c(as.Date("2019-07-31"),as.Date("2019-08-31"),as.Date("2019-09-30"))){
        dfTransaction[nrow(dfTransaction)+1,]=list(nrow(dfTransaction)+1,day,AccNo,"Deposit",Amount=(depositSGDTotal+withdrawSGDTotal)*0.005/12,"SGD")
      }
    }#end of inner for-loop for going over each account
  }#end of outer for-loop for going over each day
  save(dfTransaction,file="dftransaction.rda") 
  #write_csv(dfTransaction,"C:/Users/weiku/Desktop/Masters Programme/NTU Masters programme/Year 2, Mini Term 2/FE8828/Project/trans.csv")
  return(dfTransaction)
}

createAccountdf<-function(AccNo){
  ####################
  # 3. Account table #
  ####################
  dfAccount<-data.frame(AccountNo = 1:AccNo, Name=paste(rand_names(AccNo)$name.first,rand_names(AccNo)$name.last))
  save(dfAccount,file="name.rda")
  return(dfAccount)
}

dfCurRateLong <- createCurrencydf()
dfTran <- createTransactiondf(5,dfCurRateLong)
dfAccount <- createAccountdf(10)

#Convert all transaction to SGD and break into Credit, Deposit and Balance (i.e. Deposit+Withdraw)
dfCreditSGD <- dfTran %>% dplyr::filter(TransactionType=="Spend") %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>% group_by(Date,AccountNo) %>% summarise(sgd=sum(sgd))
dfDepositSGD <- dfTran %>% dplyr::filter(TransactionType=="Deposit") %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>% group_by(Date,AccountNo) %>% summarise(sgd=sum(sgd))
dfBalanceSGD <- dfTran %>% dplyr::filter(TransactionType %in% c("Deposit","Withdraw")) %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>% group_by(Date,AccountNo) %>% summarise(sgd=sum(sgd))

datesrange <- bizseq("2019-07-01","2019-09-30")
numdays <- length(datesrange)
dfCreditSGDWithAllDays<-left_join(data.frame(Date=rep(datesrange,each=10), AccountNo=rep(1:10,numdays)),dfCreditSGD,by=c("Date","AccountNo"))
dfDepositSGDWithAllDays<-left_join(data.frame(Date=rep(datesrange,each=10), AccountNo=rep(1:10,numdays)),dfDepositSGD,by=c("Date","AccountNo"))
dfBalanceSGDWithAllDays<-left_join(data.frame(Date=rep(datesrange,each=10), AccountNo=rep(1:10,numdays)),dfBalanceSGD,by=c("Date","AccountNo"))

for (i in 1:(10*numdays)){
  #if no transaction, amount = 0
  if(is.na(dfCreditSGDWithAllDays$sgd[i])){
    dfCreditSGDWithAllDays$sgd[i]=0
  }
  if(is.na(dfDepositSGDWithAllDays$sgd[i])){
    dfDepositSGDWithAllDays$sgd[i]=0
  }
  if(is.na(dfBalanceSGDWithAllDays$sgd[i])){
    dfBalanceSGDWithAllDays$sgd[i]=0
  }
}

# Define UI for application
ui <- fluidPage(
  fluidPage(
    titlePanel("Client View"),
    sidebarLayout(
      sidebarPanel(
        selectInput("clientAccount", "Select client account", dfAccount$Name),
        br(),
        selectInput("month", "Select month", unique(format(dfCurRateLong$Date, format = "%B %Y")))
      ),
      mainPanel(
        uiOutput("clientView")
      )
    )
  ),
  fluidPage(
    titlePanel("Bank View"),
    sidebarLayout(
      sidebarPanel(
        selectInput("month_bank", "Select month", unique(format(dfCurRateLong$Date, format = "%B %Y")))
      ),
      mainPanel(
        uiOutput("bankView")
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$clientView <- renderUI({
    uiopt <- tagList(
      h3(paste0(input$clientAccount)),
      h3(paste0(input$month)),
      plotOutput("ChartofBalance"),
      h3("Transaction History"),
      tableOutput("transaction"),
      tableOutput("EndMonthBalance"),
      h3("Summary"),
      tableOutput("summary")
    )
    uiopt
  })
  
  output$ChartofBalance <- renderPlot({ 
    #Take abs on cumulative sum for the graph (for credit)
    dfCreditCumSum <- dfCreditSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = abs(cumsum(sgd)))
    dfDepositCumSum <- dfDepositSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    dfBalanceCumSum <- dfBalanceSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    
    ggplot() +
      geom_line(dfCreditCumSum %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}),
                mapping = aes(x=Date, y=cumsgd, colour = "Credit"), size = 1) +
      geom_line(dfDepositCumSum %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}),
                mapping = aes(x=Date, y=cumsgd, colour = "Deposit"), size = 1) +
      geom_line(dfBalanceCumSum %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}),
                mapping = aes(x=Date, y=cumsgd, colour = "Balance"), size = 1) +
      scale_color_discrete(name = "Legend") +
      ylim(0,max(dfDepositCumSum$cumsgd))  +
      theme_bw() + 
      theme(legend.position = "bottom") +
      ylab("SGD") +
      labs(title = "Chart of balance") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  #Print out the transaction history
  output$transaction <- renderTable({
    dfCreditCumSum <- dfCreditSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    dfDepositCumSum <- dfDepositSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    dfBalanceCumSum <- dfBalanceSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    
    dfSelected <- dfTran %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}, AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(`Amount (in SGD)`=Amount*Conversion) %>%
      left_join(.,data.frame(select(dfDepositCumSum,Date, AccountNo, cumsgd),TransactionType="Deposit"),by=c("Date","AccountNo","TransactionType")) %>%
      rename(`Deposit Balance`=cumsgd) %>%
      left_join(.,data.frame(select(dfCreditCumSum,Date, AccountNo, cumsgd),TransactionType="Spend"),by=c("Date","AccountNo","TransactionType")) %>%
      rename(`Credit Balance`=cumsgd) %>%
      select(., Date, TransactionType, Currency, Amount, `Amount (in SGD)`, `Deposit Balance`, `Credit Balance`)
    dfSelected$Date <- as.character(as.Date(dfSelected$Date))
    dfSelected
  })
  
  #Print out end of month balance
  output$EndMonthBalance <- renderTable({
    dfCreditCumSum <- dfCreditSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    dfDepositCumSum <- dfDepositSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    dfBalanceCumSum <- dfBalanceSGDWithAllDays %>% dplyr::filter(AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% mutate(cumsgd = cumsum(sgd))
    
    data.frame( `Month End Balance` = dfBalanceCumSum %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}) %>% tail(1) %>% .[1,4] %>% as.numeric(),
                `Month End Deposit` = dfDepositCumSum %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}) %>% tail(1) %>% .[1,4] %>% as.numeric(),
                `Month End Credit` = dfCreditCumSum %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}) %>% tail(1) %>% .[1,4] %>% as.numeric()
    )
  })
  
  #Summary
  output$summary <- renderTable({
    dfTran %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month}, AccountNo == dfAccount[dfAccount$Name == {input$clientAccount}, 1]) %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>% mutate(sgd=Amount*Conversion) %>%
      group_by(TransactionType) %>% summarise(`Amount (in SGD)`=sum(sgd))
  })
  
  output$bankView <- renderUI({
    uiopt <- tagList(
      h3(paste0(input$month_bank)),
      plotOutput("Chart"),
      h3("PnL table: Detail table (for every day)"),
      tableOutput("PnL"),
      h3("Risk table as of the end of month (sort descending by largest abs(Credit)-Deposit)"),
      tableOutput("Risk")
    )
    uiopt
  })
  
  output$Chart <- renderPlot({ 
    dfDepositCumSumBank <- dfDepositSGDWithAllDays %>% group_by(Date) %>% summarise(sumsgd = sum(sgd)) %>% mutate(cumsgd = cumsum(sumsgd))
    #Take abs on cumulative sum for the graph (for credit)
    dfCreditCumSumBank <- dfCreditSGDWithAllDays %>% group_by(Date) %>% summarise(sumsgd = sum(sgd)) %>% mutate(cumsgd = abs(cumsum(sumsgd)))
    
    ggplot() +
      geom_line(dfDepositCumSumBank %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}),
                mapping = aes(x=Date, y=cumsgd, colour = "Deposit"), size = 1) +
      geom_line(dfCreditCumSumBank %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}),
                mapping = aes(x=Date, y=cumsgd, colour = "Credit"), size = 1) +
      scale_color_discrete(name = "Legend") +
      ylim(0,max(dfDepositCumSumBank$cumsgd))  +
      theme_bw() + 
      theme(legend.position = "bottom") +
      ylab("SGD") +
      labs(title = "Chart") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  #PnL table: Detail table (for every day)
  output$PnL <- renderTable({
    dfDepositCumSumBank <- dfDepositSGDWithAllDays %>% group_by(Date) %>% summarise(sumsgd = sum(sgd)) %>% mutate(cumsgd = cumsum(sumsgd))
    dfCreditCumSumBank <- dfCreditSGDWithAllDays %>% group_by(Date) %>% summarise(sumsgd = sum(sgd)) %>% mutate(cumsgd = cumsum(sumsgd))
    
    dfChargesRev <- data.frame(Currency=c("USD","CNY","SGD"),Rate=c((0.02/12)/(1+(0.02/12)),(0.02/12)/(1+(0.02/12)),(0.01/12)/(1+(0.01/12))),stringsAsFactors = FALSE)
    
    dfPnL <- dfTran %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}, TransactionType == "Spend", Amount<0) %>% left_join(.,dfCurRateLong,by=c("Date","Currency")) %>%
      left_join(.,dfChargesRev,by=c("Currency")) %>% mutate(`PnL from Client Spending`=Amount*Conversion*Rate*(-1)) %>% 
      group_by(Date) %>% summarise(`PnL from Client Spending` = sum(`PnL from Client Spending`)) %>%
      left_join(data.frame(Date=dfDepositCumSumBank %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}) %>% .$Date),.,by="Date")
    
    dfPnL$`PnL from Client Spending`[is.na(dfPnL$`PnL from Client Spending`)] <- 0 
    
    dfSelected <- data.frame(Date = dfDepositCumSumBank %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}) %>% .$Date,
                             `Total Deposit` = dfDepositCumSumBank %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}) %>% .$sumsgd, 
                             `Total Credit` = dfCreditCumSumBank %>% dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}) %>% .$sumsgd, 
                             `PnL from Client Spending` = dfPnL$`PnL from Client Spending`)
    dfSelected$Date <- as.character(as.Date(dfSelected$Date))
    dfSelected
  })
  
  #Risk table
  output$Risk <- renderTable({
    dfDepositCumSumAccount <- dfDepositSGDWithAllDays %>% group_by(AccountNo, Date) %>% summarise(sumsgd = sum(sgd)) %>% mutate(cumsgd = cumsum(sumsgd)) %>% 
      dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}) %>% left_join(., dfAccount, by="AccountNo") %>% rename(Deposit = cumsgd) %>%
      group_by(AccountNo) %>% slice(c(n())) %>% ungroup %>% select(Name, Deposit) 
    
    dfCreditCumSumAccount <- dfCreditSGDWithAllDays %>% group_by(AccountNo, Date) %>% summarise(sumsgd = sum(sgd)) %>% mutate(cumsgd = cumsum(sumsgd)) %>% 
      dplyr::filter(format(Date, format = "%B %Y") == {input$month_bank}) %>% left_join(., dfAccount, by="AccountNo") %>% rename(Credit = cumsgd) %>%
      group_by(AccountNo) %>% slice(c(n())) %>% ungroup %>% select(Name, Credit) 
    
    #Take absolute of credit
    inner_join(dfDepositCumSumAccount, dfCreditCumSumAccount) %>% 
      mutate(diff = abs(Credit)-Deposit) %>%
      rename(`Client Name` = Name) %>%
      arrange(desc(diff)) %>%
      select(`Client Name`, Deposit, Credit)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
