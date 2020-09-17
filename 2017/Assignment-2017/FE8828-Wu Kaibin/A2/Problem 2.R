


library(bizdays)   #Problem 2, Submitted by Wu Kaibin, Matric. No. : G1700356B
library(shiny)
library(lubridate)


ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        dateInput(
          "Start", 
          "Start Date:",weekstart = 1),
        
        selectInput(
          "Frequency", 
          "Coupon Frequency",
          c("Annual", "Semiannual", "Quarterly")),
        
        numericInput("Coupon", "Coupon Rate", 4),
        
        numericInput("Tenor", "Life of Bond", 5),
        
        numericInput("YTM", "Yield to Maturity (%)", 1),
        
        actionButton("Continue", "Plot the X-Y Graph:")
        
      ),
      
      mainPanel(
        h4("NPV Value"),
        verbatimTextOutput("NPV"),
        
        hr(),
        dataTableOutput("df", width = "800px", height = "400px"),
        plotOutput("couponPlot", width = "800px", height = "400px")
      )
      
    )
)

server <- function(input, output, session) {
  
  bizdayGenerator <- function(StartDate, Tenor, CouponFrequency){
    EndDate <- StartDate
    year(EndDate) <- year(StartDate) + Tenor
    
    if (CouponFrequency=="Annual"){
      SeqDate <- seq(StartDate, EndDate, by = "year")
      bizSeqDate <- SeqDate
      for (i in 1:length(SeqDate)){
        bizSeqDate[i] <- adjust.next(SeqDate[i], "weekends")
      }
    }
    
    if (CouponFrequency=="Quarterly"){
      SeqDate <- seq(StartDate, EndDate, by = "quarter")
      bizSeqDate <- SeqDate
      for (i in 1:length(SeqDate)){
        bizSeqDate[i] <- adjust.next(SeqDate[i], "weekends")
      }
    }
    
    if (CouponFrequency=="Semiannual"){
      SeqDate <- seq(StartDate, EndDate, by = "quarter")
      payTime <- (length(SeqDate)+1)/2
      bizSeqDate <- seq(StartDate, EndDate, length.out = payTime)
      for (i in 1:payTime){
        bizSeqDate[i] <- adjust.next(SeqDate[i*2-1], "weekends")
      }
    }
    bizSeqDate
  }

  paymentGenerator <- function(Tenor, CouponFrequency, Coupon){
    
    if (CouponFrequency == "Annual"){n=1}
    if (CouponFrequency == "Semiannual"){n=2}
    if (CouponFrequency == "Quarterly"){n=4}
    
    SeqPay <- seq(0,Tenor*n,by = 1)
    payTime <- length(SeqPay)
    for (i in 1:payTime){
      SeqPay[i] = Coupon/n
    }
    SeqPay[1] <- 0
    SeqPay[payTime] <- Coupon/n + 100
    SeqPay
  }
  output$df <- renderDataTable(
    data.frame(date = bizdayGenerator(input$Start,input$Tenor,input$Freq),
               payment = paymentGenerator(input$Tenor, input$Freq, input$Coupon))
  )
  NPVGenerator <- function(C, Y, freq, N){
    if (freq == "Annual"){f=1}
    if (freq == "Semiannual"){f=2}
    if (freq == "Quarterly"){f=4}
    n <- f*N
    y <- (Y/f)/100
    C*(1-1/(1+y)^n)/y+(100/(1+y)^n)
    
  }
  output$NPV <- renderPrint(
    {NPVGenerator(input$Coupon, input$YTM, input$Freq, input$Tenor)}
  )
  observeEvent(input$go, {
    output$couponPlot <- renderPlot({
      plot({
        data.frame(date = bizdayGenerator(input$Start,input$Tenor,input$Freq),
                   payment = paymentGenerator(input$Tenor, input$Freq, input$Coupon))
      })
    })})
}

shinyApp(ui = ui, server = server)

