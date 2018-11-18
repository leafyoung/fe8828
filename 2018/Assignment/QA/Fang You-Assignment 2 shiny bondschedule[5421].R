#assignment 2
#Fang You G1800202G
#bond schedule in shiny

library(shiny)
library(lubridate)
library(DT)

ui <- fluidPage(

  #UI for user inputs
  dateInput("startdate","Start date:",value = NULL, min = NULL, max = NULL, format = "yyyy-mm-dd",startview = "month",weekstart = 0,language = "en",width = NULL),
  numericInput("tenor","Tenor (years):",value = 10,min = 0,max = NA,step = 1,width = NULL),
  numericInput("couponrate","Coupon rate (%)",value = 1,min = 0, max = NA, step = NA, width = NULL),
  numericInput("freq","Coupon frequency (times per year)",value = 2,min = 0, max = NA, step = 1, width = NULL),
  numericInput("ytm","Yield to maturity (%)",value = 1,min = 0,max = NA,step = NA,width = NULL),
  
  #h3("Coupon Schedule"),
  fluidRow(
    column(10, h3("Coupon Schedule"),
           dataTableOutput("schedule")
           )
  ),
  
  hr(),
  
  h3("NPV"),
  plotOutput("npv")
  
)

#options(error = function() traceback(2))

server <- function(input, output, session) {
  
  # YY: 
  # use reactiveValues to create a list-like variable to store the reactive values.
  # npv$N
  # npv$payday
  # npv$npv
  npv <- reactiveValues()
  
  # YY:
  # 1. sche is a reactive value, to be called by () in later code to retrieve its value.
  # 2. eventReactive needs a input Control, not just only the input variable.
  #    Now I set input$ytm to be the "trigger" to start update the table and charts.
  #    You may add a buttonInput and use its id as "trigger".
  sche <- eventReactive(input$ytm,{
    
    #number of points of time during lifetime of bond + start date
    npv$N <- input$freq*input$tenor+1 
    
    #create vector of cashflows from coupon payments, with the cashflow at maturity = coupon + maturity value
    cashflow <- rep(input$couponrate,npv$N)
    cashflow[1] <- -1*(input$couponrate*(1-(1/(1+input$ytm)^input$tenor))/(input$ytm)+(100/(1+input$ytm/100)^input$tenor)) #cash outflow to buy bond at t = 0
    cashflow[npv$N] <- input$couponrate+100 #last coupon payment + maturity value
    
    #create dummy list for payday
    npv$payday <- seq(Sys.Date(), by = "day",length.out = npv$N)
    
    #create dummy vector for npv
    npv$npv <- vector(mode = "numeric",npv$N)

    #create vector of dates of cashflows
    enddate <- input$startdate + months(input$tenor*12)
    npv$payday[1] <- input$startdate
    for (i in 2:npv$N){
      npv$payday[i] <- npv$payday[i-1] + months(12/input$freq)
    }
    
    #create vector of NPVs of the bond
    npv$npv[npv$N] <- cashflow[npv$N]
    for (i in (npv$N-1):1){
      npv$npv[i] <- npv$npv[i+1]/(1+input$ytm/100) + cashflow[i]
    }

    sche <- data.frame("Date" = npv$payday, "Cashflow" = cashflow,"NPV" = npv$npv)
  })
  
  # YY: Call sche with sche()
  output$schedule <- renderDataTable(
    sche(), options = list(pagelength = 10)
  )
  
  # sample code
  # output$dt2 <- renderDataTable(iris,
  #                               options = list(pageLength = 5),
  #                               server = FALSE)
  
  # YY: retrieve each result from "the reactive variable list", npv.
  output$npv <- renderPlot({
    plot(npv$npv, pch = 19,type = "l", cex = 1, col = "red", lwd = 3,xlab = "Date", main = "NPV profile of Bond", xaxt = "n")
    axis(1,at = 1:npv$N, labels = npv$payday)
    # plot(npv$npv)
  })  
}

# Run the application 
shinyApp(ui = ui, server = server)