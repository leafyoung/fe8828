library(shiny)
library(DT)
library(conflicted)
library(tibble)
library(lubridate)
library(ggplot2)

conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

ui <- fluidPage(
    dateInput("date","Start Date",value = "2020-01-01"),
    numericInput("par", "Par Value", 100),
    numericInput("tenor", "Tenor", 10),
    numericInput("cr", "Coupon Rate", 0.05),
    selectInput("cfr", "Coupon Frequency", choices =c("Annually","Semiannually","Quarterly" )),
    numericInput("ytm", "Yield to Maturity", 0.025),
    hr(),
    fluidRow(
        column(4, h3("Coupon Schedule"),
               dataTableOutput("dt")),
        column(4, h3("Cashlow Plot 1"),
               plotOutput("p")),
        column(4, h3("Cashlow Plot 2"),
           plotOutput("p1")))
)

server <- function(input, output, session) {
    table <- function(){
       endDate <- input$date + years(input$tenor)
       dates <- seq.Date(as.Date(input$date), as.Date(endDate),
                         by = switch(input$cfr, "Annually" = "1 year", "Semiannually" = "6 months","Quarterly"= "3 months" ) )
       dates <- dates[-1]
       for(i in seq_along(dates)){
           if(weekdays(dates[i])=="Sunday")
               {dates[i] <- dates[i] + 1}
           if(weekdays(dates[i])=="Saturday")
               {dates[i] <- dates[i] + 2}
       }
       cfr <- switch(input$cfr, "Annually" = 1, "Semiannually" = 2,"Quarterly" = 4 )
       couponAmt <- input$par * input$cr / cfr
       tenor <- seq(1/cfr, input$tenor, by=1/cfr)
       cf <- rep(couponAmt, cfr*input$tenor)  
       cf[length(cf)]=cf[length(cf)]+input$par
       dcf <- cf*((1+input$ytm/cfr)^(-tenor*cfr))
       df <- tibble(dates, cf , dcf)
       }
       
    output$dt <- renderDataTable(table(),options = list(pageLength =12),server = FALSE)
    output$p<-renderPlot({plot(table()$dates,table()$cf)})
    output$p1<-renderPlot({ggplot(table(), aes(x=table()$dates,y=table()$cf)) +geom_bar(stat="identity")})
}  

shinyApp(ui = ui, server = server)
