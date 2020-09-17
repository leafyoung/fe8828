#
# Group Project Question 1: Bank
# Prepared for FE8828 Programming Web Applications in Finance, Dr. Yang Ye
# by Li Enwen, Feng Ruiwan, Yuan Yuxuan, Xiao Li jian, Li Jiajing
# Date: OCT-27-2019
#


library(shiny)
library(shinythemes)
library(leaflet)
library(shinyalert)
library(tidyverse)
library(LambertW)
library(ggplot2)

Ready = "Transaction data is ready to be viewed."
NotReady = "Transaction data is not ready, please press the trigger button below."

#Please change your working directory accordingly as below to have the program work

#initialize 10 accounts (Account)
AccountInfo <- data.frame("AccountNo" = sample(600000:900000, 10), 
                          "Name" = c("Charles Hamlin", "Hanchen Nan", "William Harding", "Juru Cao",
                                     "Daniel Crissinger", "Lijiao Hu", "Roy Young", "Xiyu Chen",
                                     "Eugene Meyer", "Baohua Li"),
                          "Deposit" = sample(1000:2000, 10),
                          "Credit" = 2000,
                          "Currency" = c("SGD"))
save(AccountInfo, file = "df_account.rda") #file will be saved to the environment
#load(file = "df_account.rda")


#create 3 currencies (Currency to SGD)
#data source: https://secure.mas.gov.sg/msb/ExchangeRates.aspx
#assumption: for holidays and weekends, assuming that exchange rates are the same as
#that of the last trading day
CurrencyInfo <- read.csv("C:\Users\xlj19\Desktop\FE8828 Group Assignment\Q_1\Exchange Rates.csv", header = TRUE)
CurrencyInfo$Date <- as.Date(CurrencyInfo$Date)
names(CurrencyInfo)[2] <- "USD"
names(CurrencyInfo)[3] <- "CNY"
save(CurrencyInfo, file = "df_currency.rda")

# Define UI for application that draws a histogram
ui <- fluidPage(
    useShinyalert(), 
    navbarPage(
        theme = shinytheme("flatly"),
        "MFE Bank ",
        tabPanel("Trigger Auto-generation",
                 div(style="display:inline-block;width:100%;text-align: center;",
                     h2("Transaction status: ")),
                 div(style="display:inline-block;width:100%;text-align: center;",
                     textOutput("selected_var")),
                 headerPanel(""),
                 div(style="display:inline-block;width:100%;text-align: center;",
                     actionButton("generate", "Generate Transaction Records", class="btn btn-success btn-lg"))
                 ), 
        tabPanel("Client View",
                 conditionalPanel(condition = paste0(paste0("output.selected_var == \"", Ready), "\""),
                                  selectInput('client', 'Select client', AccountInfo$Name, selectize=FALSE),
                                  selectInput('clientMonth', 'Select month', format(as.Date(CurrencyInfo$Date),"%m")[!duplicated(format(as.Date(CurrencyInfo$Date),"%m"))]),
                                  actionButton("clientgo", "Get client results", class="btn btn-success"),
                                  headerPanel(""),
                                  h2(textOutput("ifshowClientRes")),
                                  plotOutput("clientPlot"),
                                  headerPanel(""),
                                  h2(textOutput("ifshowTransactionDetails")),
                                  dataTableOutput("showTransactionDetails"),
                                  h4(textOutput("ifshowMonthEndBalance")),
                                  tableOutput("showMonthEndBalance"),
                                  headerPanel(""),
                                  h2(textOutput("ifshowaccountSummary")),
                                  tableOutput("showaccountSummary"),
                                  headerPanel("")
                                  ),
                 conditionalPanel(condition = paste0(paste0("output.selected_var == \"", NotReady), "\""),
                                  div(style="display:inline-block;width:100%;text-align: center;",
                                      h4("Transaction data has not been generated,"), 
                                      h4("please go to Trigger panel to trigger auto-generation.")))
                 ), 
        tabPanel("Bank View",
                 conditionalPanel(condition = paste0(paste0("output.selected_var == \"", Ready), "\""),
                                  selectInput('bankMonth', 'Select month', format(as.Date(CurrencyInfo$Date),"%m")[!duplicated(format(as.Date(CurrencyInfo$Date),"%m"))], selectize=FALSE),
                                  actionButton("bankgo", "Get bank results", class="btn btn-success"),
                                  headerPanel(""),
                                  h2(textOutput("ifshowBankChart")),
                                  plotOutput("bankPlot"),
                                  headerPanel(""),
                                  h2(textOutput("ifshowPnltable")),
                                  dataTableOutput("showPnLtable"),
                                  headerPanel(""),
                                  h2(textOutput("ifshowRiskTable")),
                                  tableOutput("showRiskTable")
                                  
                                  ),
                 conditionalPanel(condition = paste0(paste0("output.selected_var == \"", NotReady), "\""),
                                  div(style="display:inline-block;width:100%;text-align: center;",
                                      h4("Transaction data has not been generated,"), 
                                      h4("please go to Trigger panel to trigger auto-generation.")))),
        tabPanel("About Us",
                 h1("Group Project Question 1: Bank"),
                 h3("Prepared for FE8828 Programming Web Applications in Finance, Dr. Yang Ye"),
                 h3("by Li Enwen, Feng Ruiwan, Yuan Yuxuan, Xiao Li jian, Li Jiajing"),
                 h4("Date: OCT-27-2019")
            
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    values <- reactiveValues()
    
    values$dataSetup = FALSE
    values$pnl = data.frame()
    values$accountSummary = data.frame()
    values$transactionDetails = data.frame()
    values$showClientView = FALSE
    values$showBankView = FALSE
    values$riskTable = data.frame()
    values$monthEndBalance = data.frame()
    values$balance = data.frame()
    
    output$showMonthEndBalance <- renderTable({
        values$monthEndBalance
    })
    output$ifshowMonthEndBalance <- renderText({
        ifelse(values$showClientView, "Month-End Balance", "")
    })
    
    output$selected_var <- renderText({ 
        ifelse(values$dataSetup, Ready, NotReady)
    })
    
    output$ifshowPnltable <- renderText({
        ifelse(values$showBankView, "PnL Table", "")
    })
    
    output$ifshowBankChart <- renderText({
        ifelse(values$showBankView, "Interest Chart", "")
    })
    
    output$showPnLtable <- renderDataTable({
        values$pnl
    })
    
    output$ifshowRiskTable <- renderText({
        ifelse(values$showBankView, "Risk Table", "")
    })
    
    output$showRiskTable <- renderTable({
        values$riskTable
    })
    
    output$showClientRes <- renderText({
        input$month
    })
    output$ifshowClientRes <- renderText({
        ifelse(values$showClientView, "Chart of balance", "")
    })
    
    output$showaccountSummary <- renderTable({
        values$accountSummary
    })
    output$ifshowaccountSummary <- renderText({
        ifelse(values$showClientView, "Summary", "")
    })
    
    output$showTransactionDetails <- renderDataTable({
        values$transactionDetails
    })
    output$ifshowTransactionDetails <- renderText({
        ifelse(values$showClientView, "Transaction Details", "")
    })
    
    output$bankPlot <- renderPlot({
        if(!is_empty(values$pnl)){
            tmp <- values$pnl %>%
                select(Date, Deposit, Credit) %>%
                gather(key = "variable", value = "value", -Date)
            
            ggplot(tmp, aes(x = Date, y = value)) + 
                geom_line(aes(color = variable, linetype = variable)) + 
                scale_color_manual(values = c("darkred", "steelblue"))
        }
    })
    
    output$clientPlot <- renderPlot({
        if(!is_empty(values$balance)){
            ggplot(values$balance, aes(x = Date, y = value)) + 
                geom_line(aes(color = variable, linetype = variable)) + 
                scale_color_manual(values = c("darkred", "steelblue"))
        }
    })
    
    observeEvent(input$generate, {
        if(dataPreparation() == "Done"){
            values$dataSetup = TRUE
            shinyalert("Auto-generation Success!", "Please view the data from Clinet/Bank view.", type = "success")
        }else{
            shinyalert("Auto-generation Faied!", "Please try again.", type = "error")
        }
    })
    
    observeEvent(input$clientgo, {
        values$accountSummary = aggregate(. ~ TransactionType, 
                                                select(subset(Client, 
                                                              format.Date(Date, "%m")== input$clientMonth
                                                              & Name == input$client
                                                              & TransactionType != "Clear"),
                                                       TransactionType, SGAmount), sum)
        values$monthEndBalance = select(subset(Client, TransactionType == "Interest" & format.Date(Date, "%m")==input$clientMonth & Name == input$client), Deposit, Credit)
        values$transactionDetails = select(subset(Client, format.Date(Date, "%m")== input$clientMonth 
                                                  & Name == input$client), 
                                           Date, TransactionType, Currency, Amount,  SGAmount, Deposit, Credit)
        
        allDays = subset(CurrencyInfo, format.Date(Date, "%m")== input$clientMonth)
        transactionDetails = select(subset(Client, format.Date(Date, "%m")== input$clientMonth 
                                           & Name == input$client), 
                                    Date, Deposit, Credit)
        mergeDF = merge(allDays, transactionDetails, by="Date", all = TRUE)
        mergeDF = aggregate(. ~ Date, mergeDF[order(as.Date(Sys.Date()) - mergeDF$Date),], mean)
        print(mergeDF)
        values$balance <- mergeDF %>%
            select(Date, Deposit, Credit) %>%
            gather(key = "variable", value = "value", -Date)
        values$showClientView = TRUE
    })
    
    observeEvent(input$bankgo, {
        pnlTable = data.frame()
        allDays = subset(CurrencyInfo, format.Date(Date, "%m")== input$bankMonth)
        for(name in unique(AccountInfo$Name)){
            transactionDetails = select(subset(Client, format.Date(Date, "%m")== input$bankMonth 
                                               & Name == name), 
                                        Date, Deposit, Credit, PnL, SGAmount, TransactionType)
            mergeDF = merge(allDays, transactionDetails, by="Date", all = TRUE)
            mergeDF = mergeDF[order(mergeDF$Date),]
            for(row in 1:nrow(mergeDF)){
                if(is.na(mergeDF[row, "Deposit"])){
                    mergeDF[row, "Deposit"] = deposit
                }
                if(is.na(mergeDF[row, "Credit"])){
                    mergeDF[row, "Credit"] = credit
                }
                if(is.na(mergeDF[row, "PnL"])){
                    mergeDF[row, "PnL"] = 0
                }else{
                    mergeDF[row, "PnL"] = -mergeDF[row, "PnL"]
                }
                if(is.na(mergeDF[row, "SGAmount"])){
                    mergeDF[row, "SGAmount"] = 0
                }
                deposit <- mergeDF[row, "Deposit"]
                credit <- mergeDF[row, "Credit"]
            }
            mergeDF <- mergeDF %>% group_by(Date) %>% summarise(Deposit = max(Deposit), Credit = min(Credit), PnL = sum(PnL), SGAmount = sum(SGAmount))
            pnlTable <- rbind(pnlTable, mergeDF)
        }
        
        values$pnl = select(aggregate(. ~ Date, pnlTable, sum), Date, Deposit, Credit, PnL)
        riskT = select(subset(Client, TransactionType == "Interest" & format.Date(Date, "%m")==input$bankMonth), Name, Deposit, Credit)
        values$riskTable = riskT[order(riskT$Credit - riskT$Deposit),]
        values$showBankView = TRUE
    })
    
    dataPreparation <- function(){
        
        #generate random transaction data for 10 accounts from 2019-7-1 to 2019-9-30
        #assumption 1: for each spend, clients need to pay transaction fee each time and repay the money at end
        #assumption 2: set the first day of each month as clear day (for spend payment)
        #assumption 3: set the last day of each month as Interest day (for bank to summarise all clients)
        #process: 1. generate 300 unrestricted transactions for one client; 
        #2. select legal transactions under constrictions;
        #3. apply this process to other 9 clients;
        #4. use a list to store 10 transction data frames of each client
        #5. 
        
        AllClient <- list()
        
        #run for 10 times for 10 clients
        for (j in 1:10) {
            c1 <- data.frame("TransactionNo" = sample(1000:2000, 50),
                             "Date" = sample(seq(as.Date('2019/7/01'), as.Date('2019/9/30'), by="day"), 50,
                                             replace = TRUE),
                             "TransactionType" = "Deposit",
                             "SGAmount" = sample(1000:2000, 50),
                             "Currency" = sample(c("CNY", "SGD", "USD"), 50, replace = TRUE))
            
            #get a sequence of long-tail distributed numbers
            set.seed(1)
            lt = rLambertW(n=2000, distname = "normal", beta = c(0,1), delta = 0.5)
            lt <- as.data.frame(round(lt, digits = 2))
            names(lt)[1] <- "SGAmount"
            lt <- filter(lt, SGAmount < 0) %>%
                mutate(SGAmount = SGAmount * 100)
            
            c2 <- data.frame("TransactionNo" = sample(3000:9000, 250),
                             "Date" = sample(seq(as.Date('2019/7/01'), as.Date('2019/9/30'), by="day"), 250,
                                             replace = TRUE),
                             "TransactionType" = sample(c("Spend", "Withdraw"), 250, replace = TRUE),
                             "SGAmount" = sample_n(lt, 250),
                             "Currency" = sample(c("CNY", "SGD", "USD"), 250, replace = TRUE))
            c1 <- rbind(c1, c2)
            
            dpt1 <- c1 %>%
                filter(Date >= "2019-7-1" & Date <= "2019-7-31") %>%
                filter(TransactionType == "Deposit") %>%
                sample_n(sample(c(1, 2), 1), replace = TRUE)
            #in case of only one "Deposit", set replace == TRUE, though this may result in new problem
            
            dpt2 <- c1 %>%
                filter(Date >= "2019-8-1" & Date <= "2019-8-31") %>%
                filter(TransactionType == "Deposit") %>%
                sample_n(sample(c(1, 2), 1), replace = TRUE)
            
            
            dpt3 <- c1 %>%
                filter(Date >= "2019-9-1" & Date <= "2019-9-30") %>%
                filter(TransactionType == "Deposit") %>%
                sample_n(sample(c(1, 2), 1), replace = TRUE)
            
            spd <- c1 %>%
                filter(TransactionType == "Spend") %>%
                sample_n(sample(0:90, 1), replace = TRUE) #assume no. of Spend is less than 90
            
            wdw <- c1 %>%
                filter(TransactionType == "Withdraw") %>%
                sample_n(sample(0:30, 1), replace = TRUE) #assume no. of Withdraw is less than 30
            
            #Interest day and clear day
            Interestday <- data.frame("TransactionNo" = sample(3000:9000, 3),
                                     "Date" = c(as.Date('2019/7/31'), as.Date('2019/8/31'), as.Date('2019/9/30')),
                                     "TransactionType" = sample("Interest", 3, replace = TRUE),
                                     "SGAmount" = sample(0, 3, replace = TRUE),
                                     "Currency" = sample(c("SGD"), 3, replace = TRUE))
            
            clearday <- data.frame("TransactionNo" = sample(200:300, 3),
                                   "Date" = c(as.Date('2019/8/1'), as.Date('2019/9/1'), as.Date('2019/7/1')),
                                   "TransactionType" = sample("Clear", 3, replace = TRUE),
                                   "SGAmount" = sample(0, 3, replace = TRUE),
                                   "Currency" = sample(c("SGD"), 3, replace = TRUE))
            
            buffer <- arrange(rbind(dpt1, dpt2, dpt3, spd, wdw, clearday, Interestday), Date)
            buffer <- buffer[order(buffer$Date+buffer$TransactionNo*0.00000001),]
            buffer <- mutate(buffer,
                             "AccountNo" = AccountInfo$AccountNo[j],
                             "Name" = AccountInfo$Name[j],
                             "Deposit" = AccountInfo$Deposit[j],
                             "Credit" = AccountInfo$Credit[j])
            
            #create an initial transaction
            buffer <- rbind(data.frame(TransactionNo = 9999,
                                       Date = as.Date(buffer$Date[1]),
                                       TransactionType = "Meiyou",
                                       SGAmount = 0,
                                       Currency = "Demo",
                                       AccountNo = 000000,
                                       Name = "Demo",
                                       Deposit = AccountInfo$Deposit[j],
                                       Credit = AccountInfo$Credit[j]), buffer)
            
            b <- buffer %>%
                left_join(CurrencyInfo, by = "Date") %>%
                mutate(PnL = rep(0, nrow(buffer)),
                       Amount = rep(0, nrow(buffer))) 
            #use PnL to store transaction fee of credit spending
            #use Amount to store currency in foreign unit, SGAmount to store SGD
            
            sd <- 0 #for Interest day's use
            
            #go through all the transaction for each clients, the number of transaction is nrow(b)
            for(i in 2:nrow(b)){
                
                #transfer foreign exchange
                b$Amount[i] <- b$SGAmount[i]
                if(b$Currency[i] == "USD")
                    b$SGAmount[i] = round(b$USD[i] * b$SGAmount[i], digits = 2)
                if(b$Currency[i] == "CNY")
                    b$SGAmount[i] = round(b$CNY[i] * b$SGAmount[i], digits = 2)
                
                #first-of-month: restore credit
                if(b$TransactionType[i] == 'Clear'){
                    b$Deposit[i] <- b$Deposit[i-1] + b$PnL[i-1] + (b$Credit[i-1] - 2000)
                    if(b$Deposit[i] < 0){
                        b$Credit[i] <- b$Deposit[i] + 2000
                        b$Deposit[i] <- 0
                    }
                    else
                        b$Credit[i] <- 2000
                }
                
                #end-of-month: summarise deposit interest and spending transaction fee
                if(b$TransactionType[i] == 'Interest'){
                    #profit is all the transaction fees the bank earn through spending
                    profit <- 0
                    for (k in (sd+1):(i-1))
                        profit <- profit + b$PnL[k]
                    b$PnL[i] <- profit
                    #loss is interest for deposit
                    loss <- round(b$Deposit[i-1] * 0.005, digits = 2)
                    b$Deposit[i] <- b$Deposit[i-1] + loss
                    sd <- i
                    b$SGAmount[i] <- loss
                    b$Amount[i] <- loss
                    b$PnL[i] <- loss
                    b$Credit[i] <- b$Credit[i-1]
                }
                
                #for withdraw
                #SGAmount should be less than balance, but if it happens
                if(b$TransactionType[i] == 'Withdraw' & b$Deposit[i-1] < abs(b$SGAmount[i])){
                    b$SGAmount[i] <- sample(1:(b$Deposit[i-1] / 10), 1) * -1 #manually change a withdraw value
                    b$Deposit[i] <- b$Deposit[i-1] + b$SGAmount[i]
                    b$Credit[i] <- b$Credit[i-1]
                }
                
                #if there is no deposit, transfer withdraw to spend right now (this is an assumption)
                if(b$TransactionType[i] == 'Withdraw' & b$Deposit[i-1] == 0){
                    b$TransactionType[i] <- 'Spend'
                    b$SGAmount[i] <- sample(1:(b$Credit[i-1] / 10), 1) * -1
                }
                
                #in normal situation
                if(b$TransactionType[i] == 'Withdraw' & b$Deposit[i-1] >= abs(b$SGAmount[i])){
                    b$Deposit[i] <- b$Deposit[i-1] + b$SGAmount[i]
                    b$Credit[i] <- b$Credit[i-1]
                }
                
                #for spend, it's about credit
                #if credit can't cover the spend, then manually change the SGAmount
                if(b$TransactionType[i] == 'Spend' & abs(b$SGAmount[i]) > b$Credit[i-1]){
                    b$SGAmount[i] <- sample(1:(b$Credit[i-1] / 10), 1) * -1
                    if(abs(b$SGAmount[i]) > b$Credit[i-1]){
                        b$SGAmount[i] <- 0
                        b$Credit[i] <- b$Credit[i-1]
                        b$Deposit[i] <- b$Deposit[i-1]
                    }
                    else{
                        if(b$Currency[i] == "USD" | b$Currency[i] == "CNY")
                            b$PnL[i] <- round(b$SGAmount[i] * 0.02, digits = 2)
                        else
                            b$PnL[i] <- round(b$SGAmount[i] * 0.01, digits = 2)
                        b$Deposit[i] <- round(b$Deposit[i-1], digits = 2)
                        b$Credit[i] <- b$Credit[i-1] + b$SGAmount[i] + b$PnL[i]
                    }
                }
                
                #if everything is good
                if(b$TransactionType[i] == 'Spend' & b$Credit[i-1] >= abs(b$SGAmount[i])){
                    b$Deposit[i] <- b$Deposit[i-1]
                    if(b$Currency[i] == "USD" | b$Currency[i] == "CNY")
                        b$PnL[i] <- round(b$SGAmount[i] * 0.02, digits = 2)
                    else
                        b$PnL[i] <- round(b$SGAmount[i] * 0.01, digits = 2)
                    b$Credit[i] <- b$Credit[i-1] + b$SGAmount[i] + b$PnL[i]
                }
                
                #if there is no credit
                if(b$TransactionType[i] == 'Spend' & b$Credit[i-1] == 0){
                    b$SGAmount[i] <- 0
                    b$Credit[i] <- b$Credit[i-1]
                    b$Deposit[i] <- b$Deposit[i-1]
                }
                
                #for deposit, everybody is happy
                if(b$TransactionType[i] == 'Deposit'){
                    b$Credit[i] <- b$Credit[i-1]
                    b$Deposit[i] <- b$SGAmount[i] + b$Deposit[i-1]
                }
                
            }
            AllClient[[j]] <- b
            rm(lt, c1, c2, dpt1, dpt2, dpt3, spd, wdw, buffer, b, i, j)
        }
        
        Client <- do.call(rbind.data.frame, AllClient) %>%
            filter(!(TransactionNo == 9999))
        assign('AccountInfo', AccountInfo, envir=.GlobalEnv)
        assign('AllClient', AllClient, envir=.GlobalEnv)
        assign('clearday', clearday, envir=.GlobalEnv)
        assign('CurrencyInfo', CurrencyInfo, envir=.GlobalEnv)
        assign('Interestday', Interestday, envir=.GlobalEnv)
        assign('Client', Client, envir=.GlobalEnv)
        return("Done")
    }
}

# Run the application 
shinyApp(ui = ui, server = server)


