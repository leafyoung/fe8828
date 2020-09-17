
library(shiny)
library(DT)
library(bizdays)
library(lubridate)

ui <- fluidPage(

  sidebarLayout(
    sidebarPanel( 
      h3("INPUTS"),
      # data input
      dateInput( "StartDate",  "Start Date:",weekstart = 1),
      numericInput("CouponRate", "Coupon Rate(%):", 1),
      selectInput("Frequency", "PMT Frequency",c("Annual", "Semiannual", "Quarterly")),
      numericInput("Tenor", "Tenor : ", 1),
      numericInput("YTM", "Yield to Maturity(%):", 1),
      actionButton("Go", "Coupon Plot")
    ),
    
    mainPanel(
      h3("NPV Value"),
      verbatimTextOutput("NPV"),
      br(),
      hr(),
      dataTableOutput("dt"),      
      plotOutput("couponPlot")

    )
  )
)

server <- function(input, output, session) {
  # get bizday seq
  bizday <- function(StartDate, Tenor,Frequency){
    EndDay <- StartDate
    year(EndDay) <- year(StartDate) + Tenor
    
    if (Frequency=="Annual"){
      seqDate <- seq(StartDate, EndDay, by = "year")
      bizSeqDate <- seqDate
      for (i in 1:length(seqDate)){
        bizSeqDate[i] <- adjust.next(seqDate[i], "weekends")
      }}
    if (Frequency=="Quarterly"){
      seqDate <- seq(StartDate, EndDay, by = "quarter")
      bizSeqDate <- seqDate
      for (i in 1:length(seqDate)){
        bizSeqDate[i] <- adjust.next(seqDate[i], "weekends")
      }}
    if (Frequency=="Semiannual"){
      seqDate <- seq(StartDate, EndDay, by = "quarter")
      payTime <- (length(seqDate)+1)/2
      bizSeqDate <- seq(StartDate, EndDay, length.out = payTime)
      for (i in 1:payTime){
        bizSeqDate[i] <- adjust.next(seqDate[i*2-1], "weekends")
      }}
    bizSeqDate
  }
  
  # get coupon payment
  PMT <- function(Tenor,Frequency, Coupon){ 
    if (Frequency == "Annual"){n=1}
    if (Frequency == "Semiannual"){n=2}
    if (Frequency == "Quarterly"){n=4}
    seqPay <- seq(0,Tenor*n,by = 1)
    payTime <- length(seqPay)
    for (i in 1:payTime){
      seqPay[i] = Coupon/n
    }
    seqPay[1] <- 0
    seqPay[payTime] <- Coupon/n + 100
    seqPay
  }
  
  # coupon payment schedule
  output$dt <- renderDataTable(
    data.frame(date = bizday(input$StartDate,input$Tenor,input$Frequency),
               payment = PMT(input$Tenor,input$Frequency, input$CouponRate))
  )
  
  # compute NPV
  NPV <- function(CouponRate, YTM, Frequency,Tenor){
    if (Frequency == "Annual"){f=1}
    if (Frequency == "Semiannual"){f=2}
    if (Frequency == "Quarterly"){f=4}
    
    # CouponRate*(1-1/(1+((YTM/f)/100))^(f*Tenor))/((YTM/f)/100)+(100/(1+((YTM/f)/100))^(f*Tenor))
    CouponRate / f *(1-1/(1+((YTM/f)/100))^(f*Tenor))/((YTM/f)/100)+(100/(1+((YTM/f)/100))^(f*Tenor))
  }
  
  # output NPV value 
  output$NPV <- renderPrint(
    {NPV(input$CouponRate, input$YTM,input$Frequency, input$Tenor)}
  )
  
  # output coupon payment plot
  observeEvent(input$Go,{output$couponPlot <- renderPlot({
    plot({ data.frame(date = bizday(input$StartDate,input$Tenor,input$Frequency),
                 payment = PMT(input$Tenor,input$Frequency,  input$CouponRate))
    })
    
  })})
}

shinyApp(ui = ui, server = server)