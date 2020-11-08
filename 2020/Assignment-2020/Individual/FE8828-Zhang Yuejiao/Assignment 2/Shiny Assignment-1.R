library(shiny)
library(lubridate)
library(bizdays)
library(tibble)

ui <- fluidPage(
    titlePanel("Bond Schedule"),
    
    wellPanel(
        fluidRow(
            column(4, dateInput("start", "Start Date")),
            column(4, numericInput("tenor", "Tenor(in years)",1, min = 0, step = 1)),
            column(4, numericInput("cpnrate", "Coupon rate",0, min=0, step=0.01))
        ),
        fluidRow(
            column(4, selectInput("frequency", "Coupon Frequency", choices = c("Semi-annual", "Annual","Monthly","Quarterly"))),
            column(4, numericInput("ytm", "Yield to maturity",0, step = 0.01)),
            column(4, numericInput("par", "Par Value",100, min = 0, step = 1))
        ),
        actionButton("go", "Bond Schedule"),
    ),

    textOutput("npv"),
    tags$head(tags$style("#npv{color: black;
                                 font-size: 20px;
                                 font-style: bold;
                                 }"
        )
    ),
    br(),
    
    fluidRow(
        column(4, dataTableOutput("dt1")),
        column(8, plotOutput("p1")),
    ),
    
    
    
)

server <- function(input, output, session) {
    
    df_bd <- eventReactive(input$go, {
        
        # Based on start date and tenor, find end date
        endDate <- input$start
        if(input$tenor < 1){
            month(endDate) <- month(endDate) + input$tenor*12
        }else{
            year(endDate) <- year(endDate) + input$tenor
        }
        
        # Based on start, end date and frequency, find all dates of coupon payment
        date <- switch(input$frequency, 
                       "Semi-annual" = seq(as.Date(input$start), as.Date(endDate), by = "6 month"),
                       "Annual" = seq(as.Date(input$start), as.Date(endDate), by = "year" ),
                       "Monthly" = seq(as.Date(input$start), as.Date(endDate), by = "month" ),
                       "Quarterly" = seq(as.Date(input$start), as.Date(endDate), by = "3 month")
                       )
        
        # Check if any date is weekend; if so, move it one day forward
        weekend <- which(FALSE == is.bizday(date,cal = "weekends"))
        date[weekend] = date[weekend] + 1
        # Check again if after moving one day it's still weekend
        weekend <- which(FALSE == is.bizday(date,cal = "weekends"))
        date[weekend] = date[weekend] + 1      
        
        
        times <- length(date) - 1 # number of payments. minus 1 since no coupon on start day itself
        # construct a list of cashflow on each payment day
        f <- switch(input$frequency, "Semi-annual" = 2, "Annual" = 1, "Monthly" = 12, "Quarterly" = 4
            )
        cf <- rep(input$par * input$cpnrate / f, times)
        cf[times] <- cf[times] + input$par # last payment includes par value
        
        # combine date and cashflow to get data frame
        df <- tibble(Date = as.Date(date[2:length(date)]), Cashflow = cf)
        df
    })

    
    # calculate NPV
    output$npv <- renderText({
        n <- 1:length(df_bd()$Cashflow)
        NPV <- sum(df_bd()$Cashflow/((1 + isolate(input$ytm))^n))
        s <- paste0("NPV is: ", round(NPV,2))
        s
    })
    
    # datatable
    output$dt1 <- renderDataTable(df_bd())
    
    # plot
    output$p1 <- renderPlot({ barplot(df_bd()$Cashflow, names.arg=df_bd()$Date,xlab="Date",ylab="Cashflow",
                                      main="Bond Schedule") })

}

shinyApp(ui, server)