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
  
  sche <- eventReactive((input),{
    
    #number of points of time during lifetime of bond + start date
    N <- input$freq*input$tenor+1 
    
    #create vector of cashflows from coupon payments, with the cashflow at maturity = coupon + maturity value
    cashflow <- rep(input$couponrate,N)
    cashflow[1] <- -1*(input$couponrate*(1-(1/(1+input$ytm)^input$tenor))/(input$ytm)+(100/(1+input$ytm/100)^input$tenor)) #cash outflow to buy bond at t = 0
    cashflow[N] <- input$couponrate+100 #last coupon payment + maturity value
    
    #create dummy list for payday
    payday <- seq(Sys.Date(), by = "day",length.out = N)
    
    #create dummy vector for npv
    npv <- vector(mode = "numeric",N)
    
    #create vector of dates of cashflows
    enddate <- input$startdate + months(input$tenor*12)
    payday[1] <- input$startdate
    for (i in 2:N){
      payday[i] <- payday[i-1] + months(12/input$freq)
    }
    
    #create vector of NPVs of the bond
    npv[N] <- cashflow[N]
    for (i in (N-1):1){
      npv[i] <- npv[i+1]/(1+input$ytm/100) + cashflow[i]
    }

    
    sche <- data.frame("Date" = payday, "Cashflow" = cashflow,"NPV" = npv)
    
  })
  
  output$schedule <- renderDataTable(
    sche, options = list(pagelength = 10)
  )
  
  # sample code
  # output$dt2 <- renderDataTable(iris,
  #                               options = list(pageLength = 5),
  #                               server = FALSE)
  
  output$npv <- renderPlot({
    plot(npv, pch = 19,type = "l", cex = 1, col = "red", lwd = 3,xlab = "Date", main = "NPV profile of Bond", xaxt = "n")
    axis(1,at = 1:N, labels = payday)
  })  
}

# Run the application 
shinyApp(ui = ui, server = server)