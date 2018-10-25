library(lubridate)
library(bizdays)
library(shiny)


ui <- fluidPage(
  titlePanel("Bond Schedule"),
  sidebarLayout(
    sidebarPanel(
      dateInput("startdate","Start Date", value = NULL, min = NULL, max = NULL,
                   format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                   language = "en", width = NULL),
      sliderInput("tenor", "Tenor", 1, 20, 2, 1 ),
      numericInput("couponrate", "Coupon Rate", 5,  min = 0, max = 100, step = .5),
      selectInput("couponfreq", "Coupon Frequency", c("Annual" = 1, "Semi-Annual" = 2, "Quarterly" = 4), 
                  selected = NULL, multiple = FALSE, selectize = TRUE),
      numericInput("ytm","Yield To Maturity", 5, min = 0, max = 100, step = .5)
      ),
    mainPanel(
      fluidRow(
        column(6, h3(textOutput("NPV"))),
        column(6, h3(textOutput("BP")))
      ),
      br(), hr(), br(),
      h3("Coupon Schedule"),
      dataTableOutput("table"),
      br(), hr(), br(),
      h3("Coupon Plot"),
      plotOutput("plot")
      )
   )
)

cashflow <- function(input){
  if(as.numeric(input$couponfreq) * (input$tenor) == 1) {
    cf <- c(100 + input$couponrate)
  }
  else{
    cf <- c(replicate(as.numeric(input$couponfreq) * (input$tenor) - 1, input$couponrate), 100 + input$couponrate)
  }
  cf
  }

calendar <- function(input){
  cal <- create.calendar(name = "MyCalendar",weekdays=c('Sunday', 'Saturday'),
                         start.date = input$startdate, adjust.from = adjust.next, adjust.to = adjust.previous)
  n <- as.numeric(input$couponfreq) 
  t <- as.numeric(input$tenor)
  cfdate <- vector()
  class(cfdate)="Date"
  for(i in 1: (n*t)){
    date1 <- as.Date((input$startdate) %m+% months(12*i/n))
    if(weekdays(date1) == "Saturday"){ date1 <- date1 + 2}
    if(weekdays(date1) == "Sunday"){ date1 <- date1 + 1}
    cfdate[i] <- date1
    }
  cfdate
}

NPV <-function(input, cashflow){
  NPV <- 0
  f <- as.numeric(input$couponfreq) 
  t <- as.numeric(input$tenor)
  y <- as.numeric(input$ytm)
  y <- y/(f*100)
  for(i in 1: (f*t)){
    NPV <- NPV + cashflow[i]/((1+y)^i)
  }
  NPV
}

BondPrice <-function(input){
  c <- as.numeric(input$couponrate)
  y <- as.numeric(input$ytm)
  f <- as.numeric(input$couponfreq)
  y <- y/(f*100)
  n <- (f * as.numeric(input$tenor))
  BP <- c*(1-(1/(1+y)^n))/y+(100/(1+y)^n)
}


server <- function(input, output) { 
  output$NPV <- renderText(paste ("NPV = ", format(NPV(input,cashflow(input)), digits = 5)))
  output$BP <- renderText(paste ("Bond Price = ", format(BondPrice(input), digits = 5)))
  output$table <- renderDataTable(data.frame("Date" = calendar(input), "Cashflow" = cashflow(input)),options = list(dom='t',ordering=F))
  output$plot <- renderPlot(barplot(cashflow(input), names.arg = calendar(input)))
}   


shinyApp(ui = ui, server = server)

