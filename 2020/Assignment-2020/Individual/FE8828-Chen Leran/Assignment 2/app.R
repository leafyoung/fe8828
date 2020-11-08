library(shiny)
library(lubridate)
library(dplyr)

ui <- fluidPage(
    dateInput("start_date", "Start Date",as.Date("2020-01-01")),
    numericInput("tenor", "Tenor (in years)", 10),
    numericInput("face_value", "Face Value", 1000),
    selectInput("coupon_frequency", "Coupon Frequency", c("Yearly","Semi-Yearly","Quarterly")),
    numericInput("coupon_rate", 'Coupon Rate',0.01),
    numericInput("ytm", 'Yield to Maturity (Yearly)',0.01),
    
    h2("NPV"),
    textOutput("NPV"),
    h2("Result"),
    dataTableOutput("table"),
    h2("Plot of cash flow against time"),
    plotOutput("plot")
)



server <- function(input, output, session) {
    df <- reactive({
        length <- ifelse(input$coupon_frequency == "Yearly",input$tenor,(ifelse(input$coupon_frequency == "Quarterly",input$tenor*4,input$tenor*2)))
        by <- ifelse(input$coupon_frequency == "Yearly",12,(ifelse(input$coupon_frequency == "Quarterly",3,6)))
        dates = rep(0,length)
        amount = rep(0,length)
        for (i in 1:length) {
            if(i==1){
                amount[i] = input$face_value * input$coupon_rate
                dates[i] = as.Date(input$start_date, origin = "1970-01-01") %m+% months(by)
            }else if(i == length){
                amount[i] = input$face_value * (1 + input$coupon_rate)
                dates[i] = as.Date(dates[i-1], origin = "1970-01-01") %m+% months(by)
            }else{
                amount[i] = input$face_value * input$coupon_rate
                dates[i] = as.Date(dates[i-1], origin = "1970-01-01") %m+% months(by)
            }
        }
        df <- tibble(date = as.Date(ifelse(as.POSIXlt(as.Date(dates, origin = "1970-01-01"))$wday == 0, as.Date(dates, origin = "1970-01-01") + days(1),
                                           ifelse(as.POSIXlt(as.Date(dates, origin = "1970-01-01"))$wday == 6, as.Date(dates, origin = "1970-01-01") + days(2), dates)),
                                    origin = "1970-01-01"),cash_flow = amount)
        freq <- ifelse(input$coupon_frequency == "Yearly",1,(ifelse(input$coupon_frequency == "Quarterly",4,2)))
        df$row_count = 1:length
        df$discount = (1+input$ytm/freq)^(-df$row_count)
        
        df
    })
    output$table <- renderDataTable(df()[,c(1,2)])
    
    NPV <- reactive({sum(df()$cash_flow * df()$discount)})
    
    output$NPV <- renderText({ 
        NPV()
    })
    
    output$plot <- renderPlot({ plot(df()$date, df()$cash_flow) })
}



shinyApp(ui, server)
