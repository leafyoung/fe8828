library(lubridate)
library(bizdays)
library(shiny)
ui <- fluidPage(
  titlePanel("Bond Schedule"),
  sidebarLayout(
        sidebarPanel(
      selectInput("Frequency", "Payment Frequency",
                  c("Annually", "Semiannually", "Quarterly","Monthly")),
      numericInput("Coupon", "Coupon Rate", 1),
      numericInput("YTM", "YTM(In Percentage)", 1),
      dateInput("Start", "Begining Date",weekstart = 1),
      numericInput("Tenor", "Bond Maturity (# of Years)", 1),
      actionButton("Go", "Calculate")),
      position = "right",
    mainPanel(
      h2("NPV of The Bond"),
      verbatimTextOutput("NPV"),
      plotOutput("couponPlot",width="95%",height="300px"),
      dataTableOutput("df") 
    )
  )
)
server <- function(input, output, session) {
  BizDay_Cal <- function(StartDate, Tenor, CouponFrequency){
    EndDate <- StartDate
    year(EndDate) <- year(StartDate) + Tenor
    
    if (CouponFrequency=="Annually"){
      seqDate <- seq(StartDate, EndDate, by = "year")
      bizadjusted <- seqDate
      for (i in 1:length(seqDate)){
        bizadjusted[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    if (CouponFrequency=="Semiannually"){
      seqDate <- seq(StartDate, EndDate, by = "quarter")
      payTime <- (length(seqDate)+1)/2
      bizadjusted <- seq(StartDate, EndDate, length.out = payTime)
      for (i in 1:payTime){
        bizadjusted[i] <- adjust.next(seqDate[i*2-1], "weekends")
      }
    }
    
    if (CouponFrequency=="Quarterly"){
      seqDate <- seq(StartDate, EndDate, by = "quarter")
      bizadjusted <- seqDate
      for (i in 1:length(seqDate)){
        bizadjusted[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    if (CouponFrequency=="Monthly"){
      seqDate <- seq(StartDate, EndDate, by = "month")
      bizadjusted <- seqDate
      for (i in 1:length(seqDate)){
        bizadjusted[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    bizadjusted
  }
  
  payment_Cal <- function(Tenor, CouponFrequency, Coupon){
    
    if (CouponFrequency == "Annually")
    {
      n=1
      }
    if (CouponFrequency == "Semiannually")
    {
      n=2
      }
    if (CouponFrequency == "Quarterly")
    {
      n=4
      }
    if (CouponFrequency == "Monthly")
    {
      n=12
      }
    Sequence <- seq(0,Tenor*n)
    payTime <- length(Sequence)
    for (i in 1:payTime){
      Sequence[i] = Coupon/n
    }
    Sequence[1] <- 0
    Sequence[payTime] <- Coupon/n + 100
    Sequence
  }
  output$df <- renderDataTable(
    data.frame(date = BizDay_Cal(input$Start,input$Tenor,input$Frequency),
               payment = payment_Cal(input$Tenor, input$Frequency, input$Coupon))
  )
  NPV_Cal <- function(C, Y, frequency, N){
    if (frequency == "Annually")
    {
      f=1
      }
    if (frequency == "Semiannually")
    {
      f=2
      }
    if (frequency == "Quarterly")
    {
      f=4
      }
    if (frequency == "Monthly")
   {
      f=12
      }
    # C*(1-1/(1+(Y/f)/100)^f*N)/(Y/f)/100+(100/(1+(Y/f)/100)^f*N)
    C / f *(1-1/(1+(Y/f)/100)^(f*N))/((Y/f)/100)+(100/(1+(Y/f)/100)^(f*N))
  }
  output$NPV <- renderPrint(
    {NPV_Cal(input$Coupon, input$YTM, input$Frequency, input$Tenor)}
  )
  output$couponPlot <- renderPlot({
    plot({
      data.frame(DATA = BizDay_Cal(input$Start,input$Tenor,input$Frequency),
                 CASHFLOW = payment_Cal(input$Tenor, input$Frequency, input$Coupon))
    })
    
  })
}
shinyApp(ui = ui, server = server)

