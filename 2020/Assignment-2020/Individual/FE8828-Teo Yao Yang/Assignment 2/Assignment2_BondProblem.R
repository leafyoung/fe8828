library(shiny)
library(jrvFinance)
library(tidyverse)


ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
    dateInput("date","Date please",format = "yyyy-mm-dd", value = "2020-01-01"),
    dateInput("tenor","Date of maturity please",format = "yyyy-mm-dd",value = "2020-12-31"),
    numericInput("coupon", "What is the coupon rate", .05, min=0, step=0.001),
    numericInput("frq", "How many times is the coupon paid a year?", 4, min=1, max=4, step=1),
    numericInput("ytm", "What is the yield to maturity", .1, min=0, step=0.001),
    actionButton("go", "Go"),
    dataTableOutput('mytable')),
    mainPanel(
        plotOutput("mygraph1"),
        plotOutput("mygraph2")
    )
    )
    
)

server <- function(input, output, session) {
    observeEvent(input$go, {
    x <- seq(as.Date(input$date),as.Date(input$tenor),by = 1)
    x <- x[!weekdays(x) %in% c('Saturday','Sunday')]
  
    price<-bond.prices(x, input$tenor, input$coupon, freq = input$frq, input$ytm,convention ="ACT/ACT",comp.freq = input$frq, redemption_value = 100)
    table <- data.frame(x,price)
    
    seq=c(1:nrow(table))
    accrue <- vector()
    for (i in seq){
        accrue <- c(accrue, bond.TCF(x[i], input$tenor, input$coupon, freq = input$frq,convention ="ACT/ACT", redemption_value = 100)[[3]])
        i=i+1
    }
    
    table <- data.frame("Date"=x,"Bond_price"=price, "Accrued_interest"=accrue)
    table<- table[-nrow(table),]
    output$mytable <- renderDataTable(table)
    output$mygraph1 <- renderPlot(ggplot(table, aes(x = Date, y=Bond_price)) + geom_line())
    output$mygraph2 <- renderPlot(ggplot(table, aes(x = Date, y=Accrued_interest)) + geom_line())          
    
    })
  
}

shinyApp(ui, server)