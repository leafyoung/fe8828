#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(tidyverse)
library(DT)
ui <- fluidPage(
    titlePanel("Get Coupon Calendar"),
    dateInput("startdate", "Start Date", value = Sys.Date()),
    selectInput("coupon_freq", "Coupon Frequency:",c("Annually" = "anl",
                  "Semi-annually" = "sem",
                  "Quarterly" = "qrt")),
    tableOutput("data"),
    numericInput("rate", "Coupon Rate(%)", 10),
    numericInput("yield", "Yield to Maturity(%)", 5),
    numericInput("tenor", "Tenor(Years)", 5),
    h2("Coupon Calendar"),
    tableOutput("table1"),
    h2("Plot of Cash Flow"),
    plotOutput("plot1"),
    h2("Plot of Discounted Cash Flow"),
    plotOutput("plot2")
)
server <- function(input, output, session) {
    gettable <- function(input){
        finaldate <- input$startdate
        year(finaldate) <- year(finaldate) + input$tenor
        if (input$coupon_freq == "anl"){
            freq <- "1 year"
            cal_freq <- 1
        }
        else if (input$coupon_freq == "sem"){
            freq <- "6 month"
            cal_freq <- 0.5
        }
        else if (input$coupon_freq == "qrt"){
            freq <- "3 month"
            cal_freq <- 0.25
        }
        paydates <- seq.Date(from = as.Date(input$startdate), 
                             to = as.Date(finaldate), by = freq)
        for (i in c(1:length(paydates))){
            if(weekdays(paydates[i]) == 'Sunday'){paydates[i] <- paydates[i] + 1}
            if(weekdays(paydates[i]) == 'Saturday'){paydates[i] <- paydates[i] + 2}
        }
        year(finaldate) <- year(finaldate)+input$tenor
        cash_flow <- 1000 * input$rate * cal_freq/100
        cash_flow_tl <- rep(cash_flow, length(paydates))
        cash_flow_tl[[length(cash_flow_tl)]] <-
            cash_flow_tl[[length(cash_flow_tl)]] + 1000
        cash_flow_tl[[1]] <- 
            - cash_flow * (1-(1/((1+input$yield/100)^(input$tenor))))/(input$yield/100) - 1000 * 1/((1+input$yield/100)^(input$tenor))
        discounted_cash_flow_tl <- rep(0, length(paydates))
        for (i in c(1:length(cash_flow_tl))){
            discounted_cash_flow_tl[[i]] <-
                cash_flow_tl[[i]]/(1+input$yield/100)^(i-1)
        }
        df <- tibble("Date" = as.character(paydates), "Cash Flow" = cash_flow_tl,
                     "Discounted Cash Flow"=discounted_cash_flow_tl)
        df
    }
    output$table1 <- renderTable(gettable(input))
    output$plot1 <- renderPlot({ggplot(gettable(input), 
                                       aes(x=gettable(input)$"Date",
                                       y=gettable(input)$"Cash Flow")) +
                                       geom_bar(stat="identity") + xlab("Date") + ylab("Cash Flow")})
    output$plot2 <- renderPlot({ggplot(gettable(input), 
                                       aes(x=gettable(input)$"Date",
                                       y=gettable(input)$"Discounted Cash Flow")) +
                                       geom_bar(stat="identity") + xlab("Date") + ylab("Discounted Cash Flow")})
    #output$plot1 <- renderPlot({plot(as.Date(gettable(input)$"Date", tryFormats="%Y-%m-%d"), gettable(input)$"Cash Flow", 
    #                                 xlab = "Date", ylab="Cash Flow")})
    #output$plot2 <- renderPlot({plot(as.Date(gettable(input)$"Date", tryFormats="%Y-%m-%d"), gettable(input)$"Discounted Cash Flow", 
    #                                 xlab = "Date", ylab="Discounted Cash Flow")})
    
}
shinyApp(ui, server)
