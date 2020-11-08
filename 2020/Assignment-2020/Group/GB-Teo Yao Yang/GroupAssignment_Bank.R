library(conflicted)
library(tidyverse)
library(shiny)
library(DT)
library(lubridate)
conflict_prefer("renderDataTable", "DT")
conflict_prefer("dataTableOutput", "DT")
conflict_prefer("filter", "dplyr")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("Month", "Choose the month:", choices = c('July'='July','August'='August','September'='September')),
      selectInput(inputId = "Accountno", label = "Select account", choices = c('3254'='3254','7858'='7858','2832'='2832',
                                                                               '4796'='4796','8238'='8238','2526'='2526',
                                                                               '5482'='5482','4877'='4877','1825'='1825',
                                                                               '4599'='4599')),
      actionButton("go", "Go")),
    mainPanel(
      h1("Client View"),
      textOutput("name"),
      textOutput("month"),
      plotOutput("mygraph1"),
      dataTableOutput("mytable1"),
      dataTableOutput("mytable2"),
      h1("Bank View"),
      plotOutput("bankgraph"),
      dataTableOutput("banktable"),
      dataTableOutput("risktable")
 
    )
  )
  
)

gen_data <- function() {
  levels(data1$AccountNo)
  
  set.seed(5)
  account_no <- sample(1000:9999,10)
  account_name <- c("Andrew","Boris","Cathy","Droopy","Elle","Fang","Gary","Hannibal","Irene","John")
  Account <- data.frame(AccountNo=account_no,Name=account_name)
  save(Account, file = "Account.rda")
  #Account <- load(file = "Account.rda")
  
  Currency <- read.csv("Exchange Rates.csv")
  Currency$Date <- as.Date(Currency$Date, format="%d/%m/%Y")
  Currency$SGD <- 1
  colnames(Currency) <- c("Date","USD","RMB","SGD")
  Currency <- Currency %>% mutate(RMB = 100/RMB, USD= 1/USD) %>% pivot_longer(2:4,"Temp")
  colnames(Currency) <- c("Date","Currency","Conversion")
  save(Currency, file = "Currency.rda")
  #Currency <- load(file = "Currency.rda")
  
  data1 <- data.frame()
  
  for (i in 1:10){
    
    #interest payment
    interest1 <- data.frame(Date=c("2020-07-31","2020-08-31","2020-09-30"),AccountNo=Account$AccountNo[i],
                            TransactionType="Interest",Amount=0,Currency="SGD")
    #deposit
    deposit_initial <- data.frame(Date="2020-06-30",AccountNo=Account$AccountNo[i],
                                  TransactionType="Deposit",Amount=sample(1000:2000,1),Currency="SGD")
    deposit_frq <- sample(1:2,1)
    deposit_jul <- data.frame(Date=sample(seq(as.Date("2020/07/01"), as.Date("2020/07/31"), by="day"), deposit_frq),
                              AccountNo=Account$AccountNo[i],
                              TransactionType="Deposit",Amount=sample(1000:2000,deposit_frq),Currency="SGD")
    deposit_frq <- sample(1:2,1)
    deposit_aug <- data.frame(Date=sample(seq(as.Date("2020/08/01"), as.Date("2020/08/31"), by="day"), deposit_frq),
                              AccountNo=Account$AccountNo[i],
                              TransactionType="Deposit",Amount=sample(1000:2000,deposit_frq),Currency="SGD")
    deposit_frq <- sample(1:2,1)
    deposit_sep <- data.frame(Date=sample(seq(as.Date("2020/09/01"), as.Date("2020/09/30"), by="day"), deposit_frq),
                              AccountNo=Account$AccountNo[i],
                              TransactionType="Deposit",Amount=sample(1000:2000,deposit_frq),Currency="SGD")
    deposit1 <- data.frame(rbind(deposit_jul,deposit_aug,deposit_sep))
    deposit1 <- data.frame(rbind(deposit1,deposit_initial))
    #withdraw
    withdraw_frq <- sample(0:100,1)
    withdraw1 <- data.frame(Date=sample(seq(as.Date("2020/07/01"), as.Date("2020/09/30"), by="day"), withdraw_frq,replace=TRUE),
                            AccountNo=Account$AccountNo[i],
                            TransactionType="Withdraw",Amount=0,Currency=0)
    #spend
    spend_frq <- sample(0:100,1)
    spend1 <- data.frame(Date=sample(seq(as.Date("2020/07/01"), as.Date("2020/09/30"), by="day"), spend_frq,replace=TRUE),
                         AccountNo=Account$AccountNo[i],
                         TransactionType="Spend",Amount=0,Currency=0)
    
    data <- data.frame(rbind(deposit1, spend1,withdraw1))
    data <- rbind(data,interest1)
    data$AccountNo <- as.factor(data$AccountNo)
    data$TransactionType <- as.factor(data$TransactionType)
    data$Date <- as.Date(data$Date)
    
    data_SGD <- data %>% filter(Currency=="SGD")
    data_nonSGD <- data %>% filter(Currency!="SGD") %>% rowwise() %>% mutate(Currency = sample(1:3,1) )%>% mutate(Currency = case_when(
      Currency == 1 ~ "USD",
      Currency == 2 ~ "RMB",
      TRUE ~ "SGD"))
    data <- rbind(data_SGD,data_nonSGD)
    data$Currency <- as.factor(data$Currency)
    data <- data %>% arrange(Date) %>% mutate(BegBalance=Amount[1], EndBalance=0, Credit=2000, EndCredit=0, LocalAmt=0)
    data <- merge(data, Currency, by = c("Date", "Currency"),all=TRUE)
    data <- data %>% group_by(Currency) %>% do(na.locf(.)) %>% arrange(Date)
    
    
    for (i in 2:(nrow(data)-1)){
      data$EndBalance[i] = ifelse(data$TransactionType[i] == "Withdraw", data$BegBalance[i] - min(data$BegBalance[i]/50,rlnorm(1,0,3)),
                                  ifelse(data$TransactionType[i] == "Interest", data$BegBalance[i]* (1+(0.05/12)), 
                                         ifelse(data$TransactionType[i] == "Deposit", data$BegBalance[i] + data$Amount[i],
                                                data$BegBalance[i])))
      
      data$EndCredit[i] = ifelse(data$TransactionType[i] == "Spend", data$Credit[i]- min(data$Credit[i]/50,rlnorm(1,0,3)),  data$Credit[i])
      data$BegBalance[i+1] = data$EndBalance[i]
      data$Credit[i+1] = data$EndCredit[i]
      
    }
    
    data1 <- rbind(data1,data)
  }
  
  df <- data1
  df <- df %>% mutate(Amount = ifelse(TransactionType=="Withdraw" | TransactionType=="Interest",EndBalance-BegBalance,
                                      ifelse(TransactionType=="Spend",EndCredit-Credit,
                                             Amount))) %>%
    mutate(Surcharge = ifelse(TransactionType=="Spend" & Currency=="SGD",Amount/1.01*.01,
                              ifelse(TransactionType=="Spend" &  Currency != "SGD", Amount/1.02*.02,
                                     0))) %>%
    mutate(LocalAmt = Amount*Conversion) %>% arrange(Date)
  
  df$TransactionNo <- 1:nrow(df)
  data1 <- df
  df <- df %>% select(TransactionNo, Date, AccountNo, TransactionType, Amount, Currency)
  save(df, file = "Transaction.rda")
  save(data1,file="data1.rda")
}

server <- function(input, output) {
  load("Account.rda")
  load("Currency.rda")
  load("Transaction.rda")
  data1 <- df
  # data1 <- load("data1.rda")
  
  observeEvent(input$go, {
    output$name <- renderText(filter(Account,AccountNo==input$Accountno)[,2])
    output$month <- renderText(ifelse(input$Month == 'July', 'July',ifelse(input$Month == 'August', 'August','September')))
    month_temp <- ifelse(input$Month == 'July',7,ifelse(input$Month=='August',8,9))
    table <- data1 %>% filter(AccountNo == input$Accountno) %>% filter(month(Date)==month_temp) %>%
    select(Date,TransactionType,Currency,Amount=LocalAmt,
                              AmountSGD=Amount,DepositBalance=EndBalance,
                              CreditBalance=EndCredit)
    graph <- data1 %>% filter(AccountNo == input$Accountno) %>% filter(month(Date)==month_temp)

    output$mytable1 <- renderDataTable({
      datatable(table) %>% 
        formatRound(columns = c(4:7), digits = 2)})
    table2 <- table %>% group_by(TransactionType) %>% summarize(Amount = sum(AmountSGD))
    output$mytable2 <- renderDataTable({
      datatable(table2) %>% 
        formatRound(columns = c(2:2), digits = 2)})
    
    output$mygraph1 <- renderPlot(ggplot(graph, aes(Date)) + geom_line(aes(y = EndCredit, color="creditbalance")) + 
                                    geom_line(aes(y = EndBalance, color ="depositbalance")))
    
    bankgraph <- data1 %>% filter(month(Date)==month_temp) %>% filter(TransactionType!="Spend") %>% group_by(Date) %>% 
      summarize(Deposit=sum(Amount))
    bankgraph$cumsum <- cumsum(bankgraph$Deposit)
   
    output$bankgraph <- renderPlot(ggplot(bankgraph, aes(Date)) + geom_line(aes(y = cumsum, color ="depositbalance")))

    banktable <- data1 %>% filter(month(Date)==month_temp) %>% group_by(Date, TransactionType) %>% 
      summarize(Total=sum(Amount), PnL=-sum(Surcharge)) 
    
    output$banktable <- renderDataTable(banktable)
    
    risktable <- data1 %>% filter(month(Date)==month_temp) %>% group_by(AccountNo) %>% filter(row_number()==n()) %>%
      select(AccountNo,EndBalance,EndCredit)
    
    output$risktable <- renderDataTable(risktable)
  })
}

shinyApp(ui = ui, server = server)
