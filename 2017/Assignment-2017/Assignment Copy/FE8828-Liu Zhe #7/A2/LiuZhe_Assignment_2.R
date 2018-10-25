library(lubridate)
library(bizdays)
library(shiny)

ui <- fluidPage(
  navbarPage(
    title = "Liu Zhe Assignment 2",
    
# UI tab for Q1
    tabPanel(
      "Q1. Color Choice",
      h4("Author: Liu Zhe"),
      selectInput("colorChoice","Please choose a color:", 
                  c("Skyblue" ="skyblue1",
                    "Orange" = "orange",
                    "Red"="red",
                    "Black"="black")),
      
      textOutput("colorText"),
      plotOutput("colorPlot", width = "800px", height = "400px")
    ),

# UI tab for Q2
    tabPanel( 
    
    # Title & Author
    "Q2. Bond Calculator",
    h4("Author: Liu Zhe"),
    
    # Sidebar for user input 
    sidebarLayout(
      sidebarPanel(
        dateInput(
          "Start", 
          "Start Date?",weekstart = 1),
        
        selectInput(
          "Freq", 
          "Coupon Frequency",
          c("Annual", "Semiannual", "Quarterly")),
        
        numericInput("Coupon", "Coupon Rate (assume Face Value = $100)", 4),
        
        numericInput("Tenor", "How many years till Maturity? (integer inputs only)", 5),
        
        numericInput("YTM", "Yield to Maturity? (%)", 1),
        
        actionButton("go", "Plot the X-Y Graph!")
        
      ),
      
      # Main Panel to display Table & Plot
      mainPanel(
        h4("NPV Value"),
        verbatimTextOutput("NPV"),
        
        hr(),
        # dataTableOutput("df", width = "800px", height = "400px"),
        dataTableOutput("df"),
        plotOutput("couponPlot", width = "800px", height = "400px")
      )
      
    )
  )
))

# Define server logic
server <- function(input, output, session) {
  # Interactive output for color choice
  output$colorText <-  renderText({
    paste("The chosen color: ", input$colorChoice)
  })
  output$colorPlot<- renderPlot({
    plot(1:10, pch = 19, cex = 1, col = input$colorChoice)
  })
  ###############################
  # function to generate biz date sequence
  # 3 possible frequencies: Annual, Semiannual and Quarterly
  bizdayGenerator <- function(StartD, Tenor, CouponFreq){
    EndD <- StartD
    year(EndD) <- year(StartD) + Tenor
    
    if (CouponFreq=="Annual"){
      seqDate <- seq(StartD, EndD, by = "year")
      bizSeqDate <- seqDate
      for (i in 1:length(seqDate)){
        bizSeqDate[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    
    if (CouponFreq=="Quarterly"){
      seqDate <- seq(StartD, EndD, by = "quarter")
      bizSeqDate <- seqDate
      for (i in 1:length(seqDate)){
        bizSeqDate[i] <- adjust.next(seqDate[i], "weekends")
      }
    }
    
    if (CouponFreq=="Semiannual"){
      seqDate <- seq(StartD, EndD, by = "quarter")
      payTime <- (length(seqDate)+1)/2
      bizSeqDate <- seq(StartD, EndD, length.out = payTime)
      for (i in 1:payTime){
        bizSeqDate[i] <- adjust.next(seqDate[i*2-1], "weekends")
      }
    }
    bizSeqDate
  }
  
  #function to generate coupon payment on each paying day
  # 3 possible frequencies: Annual, Semiannual and Quarterly
  paymentGenerator <- function(Tenor, CouponFreq, Coupon){
    
    if (CouponFreq == "Annual"){n=1}
    if (CouponFreq == "Semiannual"){n=2}
    if (CouponFreq == "Quarterly"){n=4}
    
    seqPay <- seq(0,Tenor*n,by = 1)
    payTime <- length(seqPay)
    for (i in 1:payTime){
      seqPay[i] = Coupon/n
    }
    seqPay[1] <- 0
    seqPay[payTime] <- Coupon/n + 100
    seqPay
  }
  
  
  #Interactive output for payment schedule table
  output$df <- renderDataTable(
    data.frame(date = bizdayGenerator(input$Start,input$Tenor,input$Freq),
               payment = paymentGenerator(input$Tenor, input$Freq, input$Coupon))
  )
  ###############################
  
  #function to calculate NPV value
  NPVGenerator <- function(C, Y, freq, N){
    if (freq == "Annual"){f=1}
    if (freq == "Semiannual"){f=2}
    if (freq == "Quarterly"){f=4}
    n <- f*N
    y <- (Y/f)/100
    C*(1-1/(1+y)^n)/y+(100/(1+y)^n)
    (C/f)*(1-1/(1+y)^n)/y+(100/(1+y)^n)
  }
  
  #Interactive output for NPV  
  output$NPV <- renderPrint(
    {NPVGenerator(input$Coupon, input$YTM, input$Freq, input$Tenor)}
  )
  ###############################  
  
  
  #Interactive output for payment schedule plot
  observeEvent(input$go, {
    output$couponPlot <- renderPlot({
      plot({
        
        data.frame(date = bizdayGenerator(input$Start,input$Tenor,input$Freq),
                   payment = paymentGenerator(input$Tenor, input$Freq, input$Coupon))
      })
    })})
}

# Run the application 
shinyApp(ui = ui, server = server)

