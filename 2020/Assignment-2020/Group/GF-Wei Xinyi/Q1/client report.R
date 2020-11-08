library(shiny)
library(lubridate)
library(tidyverse)

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GF-Wei Xinyi/Q1/data')

load(paste0(wd,'/account.Rdata'))
load(paste0(wd,'/credit.Rdata'))
load(paste0(wd,'/client.Rdata'))
load(paste0(wd,'/exchange.Rdata'))

ui <- fluidPage(
    h3("Choose the client's name and time period:"),
    checkboxGroupInput("name", "Name", choices = c(), selected = c()),
    checkboxGroupInput("month", "Month", choices = c(), selected = c()),
    
    h3("Client Name:"),
    textOutput("text1"),
    h3("Month:"),
    textOutput("text2"),
    h3("1. Chart of balance: showing credit, deposit, balance along the axis of date"),
    plotOutput("p1"),
    h3("2. Transaction History"),
    tableOutput("t1"),
    h3("3. Summary"),
    tableOutput("t2")
)

name <- c("Z","O","Q","G","F", "C","X","A","B","S")
month <- c(7, 8, 9)

server <- function(input, output, session) {
    
    updateCheckboxGroupInput(session, "name",
                             choices = name,
                             selected = "Z")
    updateCheckboxGroupInput(session, "month",
                             choices = month,
                             selected = "8")
    
    output$text1 <- renderPrint(
        h3(input$name)
    )
    output$text2 <- renderPrint(
        h3(input$month)
    )
    
    output$p1 <- renderPlot({
        report1 %>%
            filter(month == input$month) %>%
            filter(Name == input$name) %>%
            ggplot()+
            geom_line(aes(x = Date, y = balance, color = "Deposit Balance")) +
            geom_line(aes(x = Date, y = Credit, color = "Credit Balance")) +
            scale_colour_manual("", 
                                values = c("Deposit Balance"="red",
                                           "Credit Balance"="blue"))+
            labs(title = "Chart of Balance")
    })
    
    output$t1 <- renderTable({
        client <-report1 %>%
            filter(month == input$month) %>%
            filter(Name == input$name) %>%
            filter(is.na(TransactionType) == FALSE)  %>%
            select(Date, TransactionType, Currency, Amount,'Amount in SDG', balance, Credit) %>%
            mutate(month = "Aug")%>%
            mutate(Date = as.character(Date)) %>%
            rename('Deposit Balance' = balance) %>%
            rename('Credit Balance' = Credit) %>%
            arrange(Date)
        
         client  
    })
    
    output$t2 <- renderTable({
       summary <- report1 %>%
           filter(month == input$month) %>%
           filter(Name == input$name) %>%
           filter(is.na(TransactionType) == FALSE)  %>%
           select(Date, TransactionType, Currency, Amount,'Amount in SDG', balance, Credit) %>%
           mutate(month = "Aug")%>%
           mutate(Date = as.character(Date)) %>%
           rename('Deposit Balance' = balance) %>%
           rename('Credit Balance' = Credit) %>%
           arrange(Date) %>%
           select(TransactionType,'Amount in SDG') %>%
           rename(quantity = 'Amount in SDG') %>%
           group_by(TransactionType) %>%
           summarise(Sum = sum(quantity))
       
       summary
         
    })
}


shinyApp(ui = ui, server = server)
