library(shiny)
library(lubridate)
library(conflicted)
library(tidyverse)
library(ggplot2)
conflict_prefer("filter", "dplyr")

# 1. Customer View: Deposit Balance = all historical deposit number - all historical withdraw number
# 2. Customer View: Credit  Balance = all historical Spend number
# 3. Bank charges has been considered into the spend transaction data table.


ui <- fluidPage(
    selectInput("Month","Month",c(7,8,9)),
    textInput("Name","Name (Only applicable in Customer View) ","aaa"),
    
    actionButton("Customer_View","Customer_View"),
    actionButton("Bank_View","Bank_View"),
    
    navbarPage(title = "Transaction Data",
               tabPanel("Customer View", 
                        textOutput('Customer1'),
                        textOutput('Customer2'),
                        plotOutput("Customer_chart", height='auto',width='auto'),
                        dataTableOutput("Customer_table"),
                        textOutput('Customer4'), hr(),
                        fluidRow(
                            column(3,textOutput('Customer3_0')),
                            column(3,h5(''),textOutput('Customer3_1')),
                            column(3,textOutput('Customer3_2_label'),textOutput('Customer3_2')),
                            column(3,textOutput('Customer3_3_label'),textOutput('Customer3_3'))
                        ),hr(), br(), br(),
                        dataTableOutput("Customer_table2"),
               ),
               tabPanel("Bank View", 
                         textOutput('bank_1'),br(),
                         plotOutput("bank_chart", height='auto',width='auto'),hr(),
                         textOutput('bank_2'),br(),
                         dataTableOutput("PnL_table"), hr(),
                         textOutput('bank_3'), br(),
                         dataTableOutput("Risk_table")
               )
    )
)

server <- function(input, output,session) {
    Gen_customer_table <- function(){
        Account <- readRDS("Account.rds")
        EX_Rate <- readRDS("EX_Rate.rds")
        Transaction <- readRDS("Transaction.rds")

        NameInput  <- input$Name
        MonthInput <- input$Month

        AccountInput <- Account[Account$Name==NameInput,]$AccountNo
        TransactionInput <- Transaction[Transaction$AccountNo==AccountInput & month(Transaction$Date)==MonthInput,]
        TransactionInput <- left_join(TransactionInput, EX_Rate, by = c("Currency","Date")) %>%
                            mutate(`Amount (in SGD)`= Conversion * amount)
        TransactionInput <- mutate(TransactionInput, Deposit_tag = ifelse(TransactionType=="Spend",0,`Amount (in SGD)`),
                            Credit_tag  = ifelse(TransactionType=="Spend",`Amount (in SGD)`,0))

        Deposit_Balance  <- cumsum(TransactionInput$Deposit_tag)
        Credit_Balance   <- cumsum(TransactionInput$Credit_tag)
        TransactionInput <- mutate(TransactionInput,Deposit_Balance,Credit_Balance)
        TransactionHistory <- TransactionInput[,c(2,4:6,8,11,12)]
        TransactionHistory
    }

    Gen_bank_table <- function(){
        Account <- readRDS("Account.rds")
        EX_Rate <- readRDS("EX_Rate.rds")
        Transaction <- readRDS("Transaction.rds")

        MonthInput <- input$Month

        TransactionInput <- Transaction[month(Transaction$Date)==MonthInput,]
        TransactionInput <- left_join(TransactionInput, EX_Rate, by = c("Currency","Date")) %>%
            mutate(`Amount (in SGD)`= Conversion * amount)
        ## calculate expenses charged by bank from spend data
        TransactionInput <- mutate(TransactionInput, Expenses = case_when(
                            (TransactionType =="Spend" & Currency=="SGD") ~ `Amount (in SGD)`* .01,
                            (TransactionType =="Spend" & Currency!="SGD") ~ `Amount (in SGD)`* .02,
                             TransactionType !="Spend"                    ~ `Amount (in SGD)`*0 ),
                            Deposit_daily = ifelse(TransactionType!="Spend",`Amount (in SGD)`,0 ),
                            Credit_daily  = ifelse(TransactionType=="Spend",`Amount (in SGD)`,0 ))
        TransactionInput <- left_join(TransactionInput,Account,by=c("AccountNo"))
        TransactionInput
    }

    observeEvent(input$Customer_View,{
        t1 <- Gen_customer_table()
        Customer_Deposit <- t1 %>% filter(TransactionType != "Spend") %>%
                                  group_by(Date) %>% summarise(Deposit_Balance=sum(Deposit_Balance))
        Customer_Credit  <- t1 %>% filter(TransactionType == "Spend") %>%
                                  group_by(Date) %>% summarise(Credit_Balance=sum(Deposit_Balance))
        Customer_D_C <- left_join(Customer_Deposit, Customer_Credit, by = "Date")

        for(i in 1:nrow(Customer_D_C)){ ## Adjustment for NA
            output$Customer2 <- renderPrint({cat("Transaction History")})
            if(is.na(Customer_D_C[i,3])){Customer_D_C[i,3] <- Customer_D_C[i-1,3]}
            }
        end_month_Credit  <- Customer_D_C[nrow(Customer_D_C),3]
        end_month_Deposit <- Customer_D_C[nrow(Customer_D_C),2]
        t2 <- group_by(t1, TransactionType) %>% summarise(Amount = sum(`Amount (in SGD)`))


        ### output
        output$Customer1 <- renderPrint({cat("Chart of balance")})
        output$Customer_chart  <- renderPlot({
            ggplot(Customer_D_C, aes(x=Date)) + geom_line(aes(y=Deposit_Balance),color="red")+ geom_line(aes(y=Credit_Balance))
        }, width = 400, height = 200)

        output$Customer2 <- renderPrint({cat("Transaction History")})
        output$Customer_table  <- renderDataTable(t1,options = list(pageLength = 8))
        output$Customer3_1 <- renderPrint({cat("Month-End Balance")})
        output$Customer3_2 <- renderPrint({cat(as.character(end_month_Credit ))})
        output$Customer3_3 <- renderPrint({cat(as.character(end_month_Deposit))})
        output$Customer3_2_label <- renderPrint({cat("Deposit Balance")})
        output$Customer3_3_label <- renderPrint({cat("Credit Balance ")})

        output$Customer4 <- renderPrint({cat("Summary")})
        output$Customer_table2 <- renderDataTable(t2)
    })

    observeEvent(input$Bank_View,{
        t2 <- Gen_bank_table()

        PnL_Table <- group_by(t2,Date) %>%
                    summarise(`Total Deposit`=sum(Deposit_daily),
                              `Total Credit` = sum(Credit_daily),
                              `PnL from Client Spending`= -sum(Expenses))
        Risk_Table <- group_by(t2, Name)  %>%
                    summarise(Deposit=sum(Deposit_daily),
                              Credit = sum(Credit_daily)) %>%
                    mutate(risk=Deposit+Credit)
        Risk_Table <- Risk_Table[order(Risk_Table$risk),] 
        
        ## output
        
        output$bank_1 <- renderPrint({cat("Chart")})
        output$bank_chart  <- renderPlot({
            ggplot(PnL_Table, aes(x=Date)) + geom_line(aes(y=`Total Deposit`),color="red")+
                geom_line(aes(y=`Total Credit`))
        }, width = 400, height = 200)
        output$bank_2 <- renderPrint({cat("PnL table")})
        output$PnL_table <- renderDataTable(PnL_Table)
        output$bank_3 <- renderPrint({cat("Risk table")})
        output$Risk_table <- renderDataTable(Risk_Table[,1:3])
    })

}


shinyApp(ui = ui, server = server)
