require(shiny)

?numericInput

ui = fluidPage(
  dateInput("date", "Bond Start Date (yyyy-mm-dd)", value = Sys.Date()),
  br(),
  numericInput("FV", "Face value ($)", min=0, value=100),
  br(),
  numericInput("coupon_rate", "Coupon rate, per annum (%)", min=0, max=100, value=5),
  br(),
  numericInput("coupon_freq", "Coupon frequency (month) - For example, if annual coupon, input 12", min=0, max=100, value=12),
  br(),
  numericInput("YTM", "YTM (%)", min=-100, max=100, value=5),
  br(),
   numericInput("tenor", "Tenor (yr)", value=1, min=0),
  actionButton("run", "Calculate"),
  br(),
  textOutput("t2"),
  br(),
  tableOutput("t1")
  
)

?isolate
?power

server = function(input, output, session) {
  output$t2 <- renderText(as.character(input$date))
  values <- reactiveValues()
  observeEvent(input$run, 
   {
     isolate(values$date <- seq(input$date, by = "month", length.out = input$tenor*12+1))
     isolate(values$CF <- rep(0,input$tenor*12+1))
     isolate(values$CF[seq(1, by=(input$coupon_freq),to=input$tenor*12+1)] <- input$FV*((input$coupon_rate*0.01)/(12/input$coupon_freq)))
     isolate(values$CF[1] <- 0)
     isolate(values$CF[length(values$CF)] <- values$CF[length(values$CF)]+input$FV)
     isolate(values$d<-1:length(values$CF) -1)
     isolate(values$n<-input$tenor*12/input$coupon_freq)
     isolate(values$x<- 1/(1+input$YTM*.01*input$coupon_freq/12)^(values$n))
     isolate(values$NPV[1]<-input$coupon_rate*0.01*input$coupon_freq/12*input$FV*(1-values$x)/(input$YTM*.01*input$coupon_freq/12)+input$FV*values$x)
   }
  )
  output$t1 <- renderTable(cbind(as.character(values$date),values$CF))
  output$t2 <- renderText(paste("NPV : ", values$NPV[1]))
}


shinyApp(ui, server)
