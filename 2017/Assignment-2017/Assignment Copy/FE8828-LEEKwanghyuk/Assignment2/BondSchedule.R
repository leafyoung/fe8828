require(shiny)

ui = fluidPage(
    dateInput("date", "Bond Start Date (yyyy-mm-dd)", value = Sys.Date()),
    numericInput("tenor", "Tenor (yr)", value=0, step=1),
    numericInput("coupon_rate", "Coupon rate, per annum (%)", min=0, max=100, value=0),
    numericInput("coupon_freq", "Coupon frequency (month) - For instance, if semiannual coupon, put 6", min=0, max=100, value=12),
    numericInput("YTM", "YTM (%)", min=-100, max=100, value=0),
    numericInput("FV", "Face value ($)", min=0, value=0),
    actionButton("go", "Calculate"),
    br(),
    textOutput("t2"),
    br(),
    tableOutput("t1")
    
  )


server = function(input, output, session) {
    output$t2 <- renderText(as.character(input$date))
    values <- reactiveValues()
    observeEvent(input$go, 
                 {
                 isolate(values$date <- seq(input$date, by = "month", length.out = input$tenor*12+1))
                 isolate(values$CF <- rep(0,input$tenor*12+1))
                 isolate(values$CF[seq(1, by=(input$coupon_freq),to=input$tenor*12+1)] <- input$FV*((input$coupon_rate*0.01)/(12/input$coupon_freq)))
                 isolate(values$CF[1] <- 0)
                 isolate(values$CF[length(values$CF)] <- values$CF[length(values$CF)]+input$FV)
                 isolate(values$d <- 1:length(values$CF) -1)
                 isolate(values$r <- exp(input$YTM*0.01*values$d/12))
                 isolate(values$NPV[1] <- sum(values$CF/values$r))
                 }
                 )
    output$t1 <- renderTable(cbind(as.character(values$date),values$CF))
    output$t2 <- renderText(paste("NPV : ", values$NPV[1]))
}


shinyApp(ui, server)
