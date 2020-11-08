#install.packages("jrvFinance")
library(shiny)
library("tidyverse")
library("jrvFinance")

settle_default <- as.Date("2020-01-01")
mature_default <- as.Date("2021-01-01")
# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidRow(column(4, 
                    dateInput("date", label = h3("Start Date"), value = settle_default),
            ),
             column(4,
                    dateInput("tenor",label = h3("Tenor"), value = mature_default),
            ),
             column(4,
                    numericInput("coupRate",label = h3("Coupon Rate"), value = "0.03" ),
             )),
    fluidRow(column(4,
                    selectInput("coupFreq", h3("Coupon Frequency"),
                                c("Quarterly" = "4",
                                  "Semi-annual" = "2",
                                  "Annual" = "1"),
                                selected = "4"),
                    ),
             column(4,
                    numericInput("yield",label = h3("Yield To Maturity"), value = "0.03" ),
                    ),
             ),

    actionButton("go", "Calculate Coupon Schedule & NPV"),
    
    h3("Coupon Schedule"),
    dataTableOutput("t1"),
    h3("Cash Flow Plot"),
    plotOutput("p2")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    # start <- reactiveVal()
    
    start <- eventReactive(input$go, {
        isolate(input$date)
    })
    
    end <- eventReactive(input$go, {
        isolate(input$tenor)
    })
    
    cRate <- eventReactive(input$go, {
        isolate(input$coupRate)
    })
    
    frequ <- eventReactive(input$go, {
        cFreq <- isolate(input$coupFreq)
    })
    ytm <- eventReactive(input$go, {
        isolate(input$yield)
    })

    output$t1 <- renderDataTable(
        tibble(
            'Date' = coupons.dates(start(), end(), freq = as.numeric(frequ())),
            'Coupon Payment' = replicate(length(Date),  100*cRate()),
        ),
    )
    
    output$p2 <- renderPlot(
        plot(coupons.dates(start(), end(), freq = as.numeric(frequ())),
             replicate(length(coupons.dates(start(), end(), freq = as.numeric(frequ()))),
                       100*cRate()))
        # bond.price(start(),end(), 100*cRate(), freq = as.numeric(frequ()), ytm()),
       
    )


}

# Run the application 
shinyApp(ui = ui, server = server)
