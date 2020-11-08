library(bizdays)
library(lubridate)
library(shiny)

ui <- fluidPage(
  titlePanel("Bond Schedule"),
  
  sidebarPanel(
    h4("Bond Inputs"),
    dateInput("start_date", "Start Date"),
    numericInput("tenor", "Tenor(years)", 5),
    numericInput("coupon", "Coupon($, Face Value $100)", 4),
    selectInput("frequency", "Coupon Frequency", c("Annual", "Semiannual")),
    numericInput("ytm", "Yield to Maturity(%)", 1),
  ),
  
  mainPanel(
    h4("NPV Value"),
    verbatimTextOutput("NPV"),    
    h4("Table Output"),
    dataTableOutput("df"),
    h4("Graph Output"),
    plotOutput("plot", width="600px", height="400px"),
  )

)

server <- function(input, output, session) {
  bizdayGenerator <- function(start_date, tenor, frequency){
    end_date <- start_date
    year(end_date) <- year(start_date) + tenor
    
    if (frequency=="Annual") {
      dates <- seq(start_date, end_date, by = "year")
      dates <- dates[-1]
      
      bizdates <- dates
      for (i in 1:length(dates)) {
        bizdates[i] <- adjust.previous(dates[i], "weekends")
      }
    }
    
    if (frequency=="Semiannual") {
      dates <- seq(start_date, end_date, by = "quarter")
      dates <- dates[-(1:2)]
      
      semiannuals <- (length(dates)+1)/2
      bizdates <- seq(start_date, end_date, length.out = semiannuals)
      for (i in 1:semiannuals) {
        bizdates[i] <- adjust.previous(dates[i*2-1], "weekends")
      }
    }
    
    return(bizdates)
  }
  
  paymentGenerator <- function(tenor, frequency, coupon){
    if (frequency == "Annual") {
      n=1
    }
    if (frequency == "Semiannual") {
      n=2
    }
    
    payments <- rep(coupon/n, tenor*n)
    payments[tenor*n] <- coupon/n + 100
    
    return(payments)
  }
  
  NPVGenerator <- function(coupon, ytm, frequency, tenor){
    if (frequency == "Annual") {
      f=1
    }
    if (frequency == "Semiannual") {
      f=2
    }
    
    n <- f*tenor
    y <- (ytm/f)/100
    
    return(coupon/f*(1-1/(1+y)^n)/y + 100/(1+y)^n)
    
  }  

  output$NPV <- renderText(
    NPVGenerator(input$coupon, input$ytm, input$frequency, input$tenor)
  )
  
  output$df <- renderDataTable(
    data.frame(
      date = bizdayGenerator(input$start_date,input$tenor,input$frequency),
      payment = paymentGenerator(input$tenor,input$frequency,input$coupon))
  )

  output$plot <- renderPlot({
    plot({
      data.frame(
        date = bizdayGenerator(input$start_date,input$tenor,input$frequency),
        payment = paymentGenerator(input$tenor, input$frequency, input$coupon))
    })
  })
  
}

shinyApp(ui = ui, server = server)