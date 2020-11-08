library(shiny)
library(lubridate)
library(tidyverse)

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GF-Wei Xinyi/Q1/data')

load(paste0(wd,'/account.Rdata'))
load(paste0(wd,'/credit.Rdata'))
load(paste0(wd,'/client.Rdata'))
load(paste0(wd,'/exchange.Rdata'))

ui <- fluidPage(
    h3("Choose the time period:"),
    checkboxGroupInput("month", "Month", choices = c(), selected = c()),
    
    h3("1. Chart: showing aggregated total deposit and credit along the axis of date"),
    plotOutput("p1"),
    h3("2. PnL table: Detail table (for every day)"),
    tableOutput("t1"),
    h3("3. Risk table as of the end of month (sort descending by largest Credit-Deposit)"),
    tableOutput("t2")
)

month <- c(7, 8, 9)

server <- function(input, output, session) {
    
    updateCheckboxGroupInput(session, "month",
                             choices = month,
                             selected = "8")
    
    output$p1 <- renderPlot({
        report1 %>%
            filter(month == input$month) %>%
            group_by(Date) %>%
            summarise(cumbalance = sum(balance)/2, cumcredit = sum(Credit)/2) %>%
            ggplot()+
            geom_line(aes(x = Date, y = cumbalance, color = "Aggregated Total Deposit Balance")) +
            geom_line(aes(x = Date, y = cumcredit, color = "Aggregated Total Credit Balance")) +
            scale_colour_manual("", 
                                values = c("Aggregated Total Deposit Balance"="red",
                                           "Aggregated Total Credit Balance"="blue"))
    })
    
    output$t1 <- renderTable({
        #PnL from Client Spending
        bankreport <- report1 %>%
            filter(month == input$month) %>%
            group_by(Date) %>%
            summarise(sum1 = sum(balance)/2, 
                      sum2 = sum(Credit)/2,
                      pnl = sum1-sum2) %>%
            rename('Total Deposit' = sum1) %>%
            rename('Total Credit' = sum2) %>%
            rename('PnL from Client Spending' = pnl)%>%
            mutate(Date = as.character(Date))
    })
    
    output$t2 <- renderTable({
        bankreport2 <- report1 %>%
            filter(month == input$month) %>%
            filter(Date == Date[length(Date)]) %>%
            mutate(pnl = balance - Credit) %>%
            filter(TransactionType == "Interest") %>%
            arrange(pnl) %>%
            select(Name, balance, Credit) %>%
            unique() %>%
            mutate(month = as.character(month))
            
})
}

shinyApp(ui = ui, server = server)
