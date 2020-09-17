#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)
library(tidyverse)
library(ggplot2)
library(reshape)
library(plotly)
library(DT)
setwd("C:/Users/Nuozh/Desktop/programming for web application/project")

source("script1.R")

TX<-Transaction()
TX<-Initial(TX)
TX<-GenHisData(TX)
Months<-c(7,8,9,10,11)
Names<-TX@Information$Name


# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel(
        h1(strong("Warm Welcome"),align="center",style="font-family: 'STHupo';font-size: 44pt")
    ),
    navbarPage(
        title = strong("Views"),
        tabPanel(
            h3("Client View"),
            h3("Open a new account"),
            textInput("newclient","Please input your name here:"),
            h4("Please input your initial deposit and credit"),
            numericInput("deposit", "Deposit:", value = 0),
            numericInput("credit", "Credit:", value = 0),
            actionButton("confirm","Confirm"),
            #actionButton("add", "Add"),
            hr(),
            h3("Transaction"),
            fluidRow(    
                column(6, h3("Amount"),
                       numericInput("amount", "Amount:", value = 0)
                       ),    
                column(6, h3("Currency"),           
                       selectInput("Currency","Currency:",
                                   choices = c("USD","SGD","CNY"))
                       )),  
                fluidRow(    
                    column(4,"",
                           actionButton("save","Save")
                    ),    
                    column(4,"",           
                           actionButton("withdraw","Withdraw")
                           ),
                    
                    column(4,"",           
                           actionButton("spend","Spend")
                    )
                    ),
                
                
                
            h3("Client View"),
            selectInput("Name","Name:",
                        choices = Names),
            hr(), 
            selectInput("Month","Month:",
                        choices = Months),
            hr(), 
            h3("Balance Chart"),
            plotOutput("BalanceChart"),
            hr(),
            
            h3("Table of Transactions History"),
            dataTableOutput("TransactionHistory"),
            hr(),
            
            h3("Table of Monthly Summary"),
            dataTableOutput("Summary"),
            hr()
            
                ),
    tabPanel(
              h3("Bank View"),
              selectInput("Month1","Month:",
                          choices = Months),
              hr(),
              h3("Total Deposit and Credit Chart"),
              plotOutput("TDCC"),
              hr(),
              h3("PnL Table"),
              dataTableOutput("PnL"),
              hr(),
              h3("Risk Table"),
              dataTableOutput("RiskTable"),
              hr()

             )
    )
    )
 


Names<-TX@Information$Name




# Define server logic required to draw a histogram
server <- function(input, output, session) {  

    updateSelectInput(session,"Name",
                      choices = Names,
                      selected = Names
    )
    
    observeEvent(input$confirm, {        
         # newclient <- isolate(input$newclient)        
         # deposit<-isolate(input$deposit)
         # credit<-isolate(input$credit)
        
        #update 
        TX <<- OpenAccount(TX,input$newclient,input$deposit,input$credit)
        Names <<- TX@Information$Name
        updateSelectInput(session,"Name",                          
                          choices = Names,
                          selected = Names
        )
        cat(paste0("This function is being executed "))
        })
    
    observeEvent(input$save,{
        accountno<-filter(TX@Information,Name==input$Name)$AccountNo
        TX <<- Deposit(TX,Sys.Date(),accountno,input$amount,input$Currency)
    })
    observeEvent(input$withdraw,{
        accountno<-filter(TX@Information,Name==input$Name)$AccountNo
        TX <<- Withdraw(TX,Sys.Date(),accountno,input$amount,input$Currency)
    })
    observeEvent(input$spend,{
        accountno<-filter(TX@Information,Name==input$Name)$AccountNo
        TX <<- Spend(TX,Sys.Date(),accountno,input$amount,input$Currency)
    })    
    
    output$BalanceChart <- renderPlot({
             BalanceChart(TX,input$Name,as.numeric(input$Month))
    })
    
    output$TransactionHistory<-renderDataTable(
        MTHistory(TX,input$Name,as.numeric(input$Month)), 
        options = list( pageLength = 5)
    )
    
    output$TransactionHistory<-renderDataTable(
        MTHistory(TX,input$Name,as.numeric(input$Month)),
        options = list( pageLength = 5)
    )
    output$Summary<-renderDataTable(
        MTSummary(TX,input$Name,as.numeric(input$Month)),
        options = list( pageLength = 4)
    )
    output$TDCC<-renderPlot({
        DCchart(TX,as.numeric(input$Month1))
    })
    output$PnL<-renderDataTable(
        BankPnL(TX,as.numeric(input$Month1)),
        options = list( pageLength = 5)
    )
    output$RiskTable<-renderDataTable(
        RiskTable(TX,as.numeric(input$Month1)),
        options = list( pageLength = 5)
    )
    
    }

# Run the application 
shinyApp(ui = ui, server = server)

