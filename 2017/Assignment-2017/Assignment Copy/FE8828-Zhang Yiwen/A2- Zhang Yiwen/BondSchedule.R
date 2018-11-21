#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(DT)
library(bizdays)
library(lubridate)

ui <- fluidPage(
  
  # Sidebar with inputs
  sidebarLayout(
    sidebarPanel(
      h4("Develop by Zeven"),
      h6("2017/11/19"),
      hr(),
      dateInput(
        "std", 
        h5("Start Date:"),weekstart = 1),
      
      selectInput(
        "frequency", 
        h5("Frequency of payment:"),
        c("Annual", "Semiannual", "Quarter")),
      
      numericInput("rate", h5("Coupon Rate(with face value $100):"), 1),
      
      numericInput("tenor", h5("Years till Maturity(intergy): "), 1),
      
      numericInput("yield", h5("Yield to Maturity(%):"), 1)
    ),
    
    
    mainPanel(
      h2("NPV of Bond"),
      hr(),
      dataTableOutput("dt1"),      
      plotOutput("couponPlot")
    )
  )
)

#define server
server <- function(input, output, session) {
  
  bizdayGenerator <- function(std, tenor, frequency){
    endD <- std
    year(endD) <- year(std) + tenor
    
    if (frequency=="Annual"){
      seqDate <- seq(std, endD, by = "year")
      bizSeqDate <- seqDate
      for (i in 1:length(seqDate)){
        bizSeqDate[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    
    if (frequency=="Quarter"){
      seqDate <- seq(std, endD, by = "quarter")
      bizSeqDate <- seqDate
      for (i in 1:length(seqDate)){
        bizSeqDate[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    
    if (frequency=="Semiannual"){
      seqDate <- seq(std, endD, by = "quarter")
      payTime <- (length(seqDate)+1)/2
      bizSeqDate <- seq(std, endD, length.out = payTime)
      for (i in 1:payTime){
        bizSeqDate[i] <- adjust.next(seqDate[i*2-1], "weekends")
      }
    }
    
    bizSeqDate
  }
  
  #generate npv value with rest number of payments
  npvGenerator <- function(tenor, frequency, rate,yield){
    
    if (frequency == "Annual"){n=1}
    if (frequency == "Semiannual"){n=2}
    if (frequency == "Quarter"){n=4}
    
    seqPay <- seq(0,tenor*n,by = 1)
    seqnpv <- seq(0,tenor*n,by = 1)
    payTime <- length(seqPay)
  
    for (i in 1:payTime){
      num <- (length(seqPay)-i) #rest payment times
      y <- yield/n/100
      seqnpv[i] <- rate / n * (1-1/(1+y)^num)/y+(100/(1+y)^num)
    }
    
    seqnpv
  }
  
  #bond schedule table
  output$dt1 <- renderDataTable(
    data.frame(date = bizdayGenerator(input$std,input$tenor,input$frequency),
               NPV = npvGenerator(input$tenor, input$frequency, input$rate,input$yield))
  )

  
  #ond schedule plot
  output$couponPlot <- renderPlot({
    plot({
      data.frame(date = bizdayGenerator(input$std,input$tenor,input$frequency),
                 NPV = npvGenerator(input$tenor, input$frequency, input$rate,input$yield))
    })
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)