library(shiny)
library(DT)
library(bizdays)
library(lubridate)
library(ggplot2)


ui <- fluidPage(
  h3("Bond Schedule Calculator"), #title
  p("Enter the Bond parameters below"), #instructions 
  numericInput("par", "Par Value ($)", min=0, max = 1000, value=100, step = 10), #input for bond par value
  dateInput("startdate", "Bond Start Date", value = Sys.Date()), # input for bond start date
  sliderInput("tenor", "Tenor in Years", value = 1, min = 0, max = 30, step = 1), # input for bond tenor
  numericInput("coupon", "Coupon Rate (%)", value = 3.5, min = 0, max = 100, step = 0.01), # input for bond coupon rate
  selectInput("freq", "Coupon Frequency", choices = c("Annual", "Semi-annual", "Quarterly", "Monthly")), # input for bond coupon frequency
  numericInput("ytm", "Yield-to-maturity (%)", value = 3.5, min = 0, max = 100, step = 0.01), # input for yield-to-maturity
  
  actionButton("go", "Calculate"),
  br(),
  br(),
  textOutput("npv"),
  br(),
  tableOutput("bs"),
 br(),
 plotOutput("plot")
  
)

coupfreq <- function(user.Input){ # function to determine number of months per period
  if(user.Input == "Annual")
    f = 1
  if(user.Input == "Semi-Annual")
    f = 2
  if(user.Input == "Quarterly")
    f = 4
  if(user.Input == "Monthly")
    f = 12
  return(f)
}

period <- function(user.Input){
  if(user.Input == "Annual")
    p = "year"
  if(user.Input == "Semi-Annual")
    p = "6 months"
  if(user.Input == "Quarterly")
    p = "quarter"
  if(user.Input == "Monthly")
    p = "month"
  return(p)
}


server <- function(input, output, session) {
  
  values <- reactiveValues() # creates an object to store reactive values
  observeEvent(input$go, 
               {
                 values$date <- seq(input$startdate, by = period(input$freq), length.out = input$tenor +1) # create a date sequence of cashflow periods
                 values$cf <- rep(0,input$tenor*coupfreq(input$freq) +1) # create a cash flow sequence initialized with 0 
                 values$cf[1:length(values$cf)] <- ((input$coupon/100)/coupfreq(input$freq))*input$par # populate the cash flow sequence with the coupon cash flows
                 values$cf[1] <- 0 # initialize period 0 with cash flow of 0
                 values$cf[length(values$cf)] <- values$cf[length(values$cf)]+input$par # add the bond par value to the final cash flow
                 values$df <- (1/(1+(input$ytm/coupfreq(input$freq))/100))^seq(0, input$tenor*coupfreq(input$freq), by =1) # create a sequence of discount factors for each period
                 values$dcf <- values$df * values$cf # create a sequence of discounted cash flows
                 values$NPV <- sum(values$dcf) # sum the discounted cash flows to obtain NPV
                 
               
               }
  )
  output$bs <- renderTable(cbind(Date=as.character(values$date),Cash_Flows = values$cf, Cash_Flows_discounted = values$dcf))
  output$npv <- renderText(paste("NPV : ", values$NPV))
  
}


shinyApp(ui, server)

