library(shiny)
library(lubridate)
library(bizdays)
library(ggplot2)

Sys.setlocale("LC_TIME", "English")

ui <- fluidPage(
    h1("Bond Schedule"),
    hr(),
    h2("Bond Informaton"),
    dateInput("start", "start date", "2020-10-01"),
    numericInput("tenor", "tenor(Y)", 10),
    numericInput("courate", "coupon rate", 0.05),
    selectInput("coufreq", "coupon frequency", c("A","H","Q")),
    numericInput("ytm", "yield to maturity", 0.03),
    actionButton("run", "Run"),
    hr(),
    h2("The npv of this bond at beginning "),
    textOutput("text"),
    h2("Bond cashflow"),
    tableOutput("t1"),
    plotOutput("graph")
)

server <- function(input, output, session) {
    
    calnpv <- function(){
        # The first column in table: coupondate
        enddate <- input$start+years(input$tenor)
        coupondate <- seq(as.Date(input$start), as.Date(enddate), 
                      by = switch(input$coufreq, "A"= "1 year", "H"= "6 months","Q"= "3 months"))
        coupondate <- coupondate[-1]
        for(i in seq_along(coupondate)){
            if(weekdays(coupondate[i])=="Saturday") coupondate[i] <- coupondate[i]+2
            if(weekdays(coupondate[i])=="Sunday") coupondate[i] <- coupondate[i]+1
        }
    
        # The second column in table: cashflow   
        freq <- switch(input$coufreq, "A"= 1, "H"= 2, "Q"= 4)
        coupon <- 100*input$courate/freq
        cf <- rep(coupon, input$tenor*freq)
        cf[length(cf)] <- 100+coupon
        
        # The third column in table: discounted cashflow
        n <- seq(1, input$tenor*freq, by=1)
        dcf <- cf/((1+input$ytm/freq)^(n))
        
        # Combine all in a dataframe
        df <- data.frame(coupondate = as.character(coupondate), cashflow = cf, discountedcf = dcf)
    }
    
    observeEvent(input$run, {
        df <- calnpv()
        output$text <- renderText(sum(isolate(df$discountedcf)))
        output$t1 <- renderTable(isolate(df))
        output$graph <- renderPlot(ggplot(df, aes(x=df$coupondate,y=df$cashflow)) +geom_bar(stat="identity")+xlab("Date")+ylab("Cashflow"))  
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
