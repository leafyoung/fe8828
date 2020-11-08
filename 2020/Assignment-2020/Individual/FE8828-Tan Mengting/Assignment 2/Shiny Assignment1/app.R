library(shiny)
library(DT)
library(lubridate)
           
ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            tags$h3("Coupon Info Input"),
            
            dateInput("start_date","Start Date"),
            numericInput("tenor","Tenor(Days)",0),
            numericInput("coupon_rate","Coupon Rate(%)" ,0),
            selectInput("coupon_frequency", "Coupon Frequency",
                        c("Annual" = "annual",
                          "Semi-Annual" = "semi_annual",
                          "Quarterly" = "quarterly"
                        )
            ),
            numericInput("ytm","YTM(%)" ,0),
            actionButton("go", "Go")
        ),
        
        mainPanel(
            h3("Coupon Calendar"),
            dataTableOutput("coupon_calendar"),
            h3("Plot"),
            plotOutput("plot1"),
            plotOutput("plot2")
        )

    )   
)


server <- function(input, output) {
    table_reactive <- eventReactive(input$go, {
        frequency <- switch(input$coupon_frequency,annual=12,semi_annual=6,quarterly=3)
        start <- input$start_date
        end <- Sys.Date() %m+% days(input$tenor)
        interval <- paste(frequency,"months")
        dates <- seq.Date(as.Date(start), as.Date(end), by=interval)
        
        # Weekends ignored
        n <- length(dates)
        for (i in n){
            if (weekdays(as.Date(dates[i])) == "Sunday"){
                dates[i] <- dates[i]+1 }
            else if (weekdays(as.Date(dates[i])) =="Saturday"){
                dates[i] <- dates[i]+2 } 
        }
        
        rate <- input$coupon_rate
        ytm <- (input$ytm) / 100
        interest <- 1000*(rate)*frequency / (12*100)
        
        cash_flow <- rep(interest,n)
        as.vector(cash_flow)
        cash_flow[n] <- cash_flow[n]+1000
        price <- -( rate * (  1 - 1/((1+ytm)^(n)) ) / ytm + cash_flow[n]/((1+ytm)^n) )
        cash_flow[1] <- price
        
        discounted_cash_flow <- c()
        for (i in 1:n){
            discounted_cash_flow <- c(discounted_cash_flow, cash_flow[i]/((1+ytm)^i) )
        }
        discounted_cash_flow[1] <- cash_flow[1]
            
        df <- data.frame ( "Date" = dates,
                           "Cash Flow" = cash_flow,
                           "Discounted Cash Flow" = discounted_cash_flow)
        return (df)
    })
    
    output$coupon_calendar <- renderDataTable({
        table_reactive()
    })
    
    output$plot1 <-renderPlot({
        df <- table_reactive()
        dates <- df[,1]
        cash_flow <- df[,2]
        barplot(cash_flow,names.arg=dates,xlab="Date",ylab="Cash Flow",col="blue")
    })
    
    output$plot2 <-renderPlot({
        df <- table_reactive()
        dates <- df[,1]
        discounted_cash_flow <- df[,3]
        barplot(discounted_cash_flow,names.arg=dates,xlab="Date",ylab="Discounted Cash Flow",col="blue")
    })
    
}

shinyApp(ui = ui, server = server)
