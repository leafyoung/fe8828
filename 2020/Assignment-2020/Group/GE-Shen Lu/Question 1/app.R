
library(tibble)
library(tidyverse)
library(bizdays)
library(lubridate)
library(conflicted)
conflict_prefer('last', 'dplyr')
conflict_prefer('lag', 'dplyr')
conflict_prefer('filter', 'dplyr')
library(shiny)

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GE-Shen Lu/Question 1')

ui <- fluidPage(
    div(titlePanel("Bank Bill"),style="font-size:230px;",align="center"),
    div(textInput("name","Name"),style = "font-size:20px;",align="center"),
    div(textInput("month","Month(please enter num)"),style = "font-size:20px;",align="center"),
    column(5,offset = 5,actionButton("go", "Go!")),
    div(h1("Transaction History"),align="center"),
    dataTableOutput("deal"),
    div(h1("PnL Table"),align="center"),
    dataTableOutput("PnL"),
    div(h1("Risk Table"),align="center"),
    dataTableOutput("Risk")
)


server <- function(input, output) {
    df1<-eventReactive(input$go,{
        name<-isolate(input$name)
        month<-isolate(input$month)
        Account<-readRDS(paste0(wd,"/Account.gz"))
        Currency<-readRDS(paste0(wd,"/Currency.gz"))
        Transaction_final<-readRDS(paste0(wd,"/Transaction_final.gz"))
        accid<-(Account%>%filter(Name==name))$AccountNo
        Transaction_final%>%filter(AccountNo==accid,month(Date)==month)%>%mutate(Credit.Blance=Credit)%>%select(Date,TransactionType,Currency,Amount,`Amount(in SGD)`,Deposit.Balance,Credit.Blance)
    })
    df2<-eventReactive(input$go,{
        name<-isolate(input$name)
        month<-isolate(input$month)
        Transaction_final<-readRDS(paste0(wd,"/Transaction_final.gz"))
        Transaction_final%>%filter(month(Date)==month)
        
    })
    
    output$deal<-renderDataTable(df1())
    
    output$PnL<-
        renderDataTable({
        
        df2()%>%group_by(Date)%>%summarise(`Total Deposit`=sum(ifelse(TransactionType!="Spend",`Amount(in SGD)`,0)),
                                                                              `Total Credit`=sum(ifelse(TransactionType=="Spend",`Amount(in SGD)`,0)),
                                                                                `PnL from Client Spending`=`Total Deposit`-`Total Credit`)
    })
    
    df3<-eventReactive(input$go,{
        name<-isolate(input$name)
        month<-isolate(input$month)
        Account<-readRDS(paste0(wd,"/Account.gz"))
        Transaction_final<-readRDS(paste0(wd,"/Transaction_final.gz"))
        Transaction_final<-merge(Transaction_final,Account[,c(1,2)])%>%arrange(Date)
        Transaction_final%>%filter(month(Date)==month)%>%group_by(Name)%>%summarise(Deposit=Deposit.Balance[length(Deposit.Balance)],Credit=Credit[length(Credit)])
        
    })
    output$Risk<-renderDataTable(df3())

}

# Run the application 
shinyApp(ui = ui, server = server)
