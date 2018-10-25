library(tidyverse)

ui <- fluidPage(
  selectInput("color", "Color", colors(distinct=FALSE), selected="black"),
  
  #plotting scatterplot
  plotOutput("p1"),
  
  #creating a bond schedule & Calculating NPV
  dateInput("start_date", "Start Date", value="2000-01-01",startview = "2017-01-01"),
  numericInput("no_of_calendar_days", "No of Calendar Days", value= 365, min=0),
  numericInput("coupon_rate", "Coupon Rate", value= 0.05),
  numericInput("yield_to_maturity", "Yield To Maturity", value = 0.05),
  
  actionButton("go", "Calculate"),
  br(),  
  
  textOutput("t1"),
  tableOutput("tbl1")
)

server <- function(input, output, session) {
  #plotting scatterplot
  output$p1 <- renderPlot({ 
    plot(c(1:10), c(1:10), pch=19, cex=3, col=input$color)
  })
  
  values <- reactiveValues() # creates an object to store reactive values
  observeEvent(input$go, 
               {
                 no_of_calendar_days <- input$no_of_calendar_days
                 start_date <- input$start_date
                 
                 print(start_date)
                 cat(str(no_of_calendar_days))
                 
                 if (!is.null(no_of_calendar_days)) {
                   if (no_of_calendar_days > 0) {
                     #creating bond schedule & calculting NPV
                     df<-data.frame(date = as.Date(seq(from = as.Date(start_date), by = "day", length.out = no_of_calendar_days)),
                                    payment=0, discount_factor=0)
                     
                     for (i in 1:input$no_of_calendar_days){
                       df[(input$no_of_calendar_days-(i*365)),2] <-input$coupon_rate/2*100
                       df[(input$no_of_calendar_days-(i*365)),3] <- (1+(input$yield_to_maturity/2))^-as.numeric(difftime(df[(input$no_of_calendar_days-(i*365)),1],df[1,1], units="days")/(365/2))  
                       df[(input$no_of_calendar_days-(i*365-183)),2] <-input$coupon_rate/2*100
                       df[(input$no_of_calendar_days-(i*365-183)),3] <- (1+(input$yield_to_maturity/2))^-as.numeric(difftime(df[(input$no_of_calendar_days-(i*365-183)),1],df[1,1], units="days")/(365/2))
                     }
                     
                     df[input$no_of_calendar_days,2] <-(input$coupon_rate/2*100)+100
                     df[input$no_of_calendar_days,3] <- (1+(input$yield_to_maturity/2))^-(input$no_of_calendar_days/(365/2))

                     df<-mutate(df, PV_of_payments= payment*discount_factor)
                     
                     values$df <- df
                     values$npv<-sum(df[,4])
                   }
                 }})
                 
  output$t1 <- renderPrint({
    cat("The NPV of the bond is ", values$npv, ".\n")
    })

  output$tbl1<-renderTable({
    repayment_schedule <- filter(values$df, payment>0)
    repayment_schedule
  })
  
  
}

shinyApp(ui, server)