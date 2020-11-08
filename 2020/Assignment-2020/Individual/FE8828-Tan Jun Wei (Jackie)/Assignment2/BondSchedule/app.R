library(shiny)
library(tibble)
library(lubridate)

# Define table generator
genTable <- function(input) {
    endDate <- input$startDate + years(input$tenor)
    # We generate the payment dates column and ignore the first date, i.e., the start date. 
    paymentDates <- seq.Date(from = as.Date(input$startDate), to = as.Date(endDate), by = input$couponFreq)[-c(1)]
    # Change the dates to the nearest Monday if it's a Saturday or a Sunday
    for (i in seq_along(paymentDates)) {
        if (weekdays(paymentDates[i]) == "Saturday") paymentDates[i] <- paymentDates[i] + 2
        if (weekdays(paymentDates[i]) == "Sunday") paymentDates[i] <- paymentDates[i] + 1
    }
    # We find out the coupon amount per period as the frequency changes.
    couponRateFreq <- switch(input$couponFreq, "3 months" = 0.25, "6 months" = 0.5, "1 year" = 1.0)
    couponAmt <- 1000*input$couponRate*couponRateFreq/100
    # We generate the payment amount column with the same size as the paymentDates column.
    paymentAmt <- rep(couponAmt, length(paymentDates))
    # Note that the last payment includes the par value which is equal to 1000. 
    paymentAmt[length(paymentAmt)] <- paymentAmt[length(paymentAmt)] + 1000
    # Putting the data together to form the datatable. 
    df <- tibble(
        `Payment Date` = paymentDates,
        `Payment Amount` = paymentAmt
    )
    df
}

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Bond Schedule & Calculator"),

    fluidRow(
        column(4,
               # Start date input
               dateInput("startDate", "Start Date (yyyy-mm-dd): ", startview = "decade")
        ),
        column(8,
               #Tenor Slider
               sliderInput("tenor", "Tenor (years): ", 1, 20, 10, width="100%")
        )
    ),
    fluidRow(
        column(4,
               numericInput("couponRate", "Coupon Rate (% p.a.): ", 5.00, min = 0.00, step = 0.01)
        ),
        column(4,
               selectInput("couponFreq", "Coupon Frequency: ", c("Annually" = "1 year",
                                                                 "Half-Yearly" = "6 months",
                                                                 "Quarterly" = "3 months")),
        ),
        column(4,
               numericInput("yield", "Yield to Maturity (% p.a.): ", 3.00, min = 0.00, step = 0.01)
        )
    ),
    fluidRow(
        column(11,offset=1,
               h4(textOutput("NPV"))
        )
    ),
    fluidRow(
        plotOutput("plot"),
    ),
    fluidRow(
        dataTableOutput("bondSchedule")
    )
)

# Define server logic
server <- function(input, output, session) {
    data <- reactive({
        genTable(input)
    })
    parameters <- reactive({
        rateFreq = switch(input$couponFreq, "3 months" = 0.25, "6 months" = 0.5, "1 year" = 1.0)
        effYieldRate = input$yield * rateFreq / 100
        effCouponRate = input$couponRate * rateFreq / 100
        periods = input$tenor / rateFreq
        list(
            "rateFreq" = rateFreq,
            "effYieldRate" = effYieldRate,
            "effCouponRate" = effCouponRate,
            "periods" = periods
        )
    })
    output$NPV <- renderText({
        d <- data()
        p <- parameters()
        NPV <- sum(d[["Payment Amount"]]/((1+p$effYieldRate)** seq_along(d[["Payment Amount"]])))
        formula <- p$effCouponRate * 1000 / p$effYieldRate * (1-(1/(1+p$effYieldRate)**p$periods)) + 1000/(1+p$effYieldRate)**p$periods
        # print(NPV)
        # print(formula)
        # paste(, 
        #       input$tenor, 
        #       input$couponRate, 
        #       input$yield, 
        #       input$couponFreq)
        paste("The NPV of the bond on", input$startDate, "is:",format(NPV, nsmall = 2, digits = 2))
        })
    output$bondSchedule <- renderDataTable({
        d <- data()
        d[c('Payment Date', 'Payment Amount')]
    })
    output$plot <- renderPlot({
        d <- data()
        barplot(d[["Payment Amount"]], names.arg = d[["Payment Date"]])
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
