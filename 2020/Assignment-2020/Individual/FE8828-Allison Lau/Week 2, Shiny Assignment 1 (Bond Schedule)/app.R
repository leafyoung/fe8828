library(shiny)
library(tidyverse)
library(lubridate)

source("bond schedule.R", local = TRUE)

ui <- fluidPage(
    dateInput(inputId = "date", "Date in YYYYMMDD", format = "yyyymmdd", value = NULL),
    numericInput(inputId ="years", "Years", 10),
    numericInput(inputId ="bond_par", "Bond Par", 100),
    numericInput(inputId ="coupon_rate", "Coupon Rate", 0.037, step = 0.001),
    numericInput(inputId ="frequency", "Coupon Frequency (1 for yearly, 2 for half-yearly, 4 for quarterly)", 1),
    numericInput(inputId ="ytm", "Yield To Maturity", 0.037, step = 0.001),
    actionButton(inputId = "go", "Go"),
    dataTableOutput("table"),
    plotOutput("p1")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$go, {
        output$table <- renderDataTable({
            table(isolate(as.numeric(input$bond_par)),isolate(input$date),isolate(as.numeric(input$coupon_rate)),isolate(as.numeric(input$ytm)),isolate(as.numeric(input$years)),isolate(as.numeric(input$frequency))
                  )})
        output$p1 <- renderPlot({
            graph(isolate(as.numeric(input$bond_par)),isolate(input$date),isolate(as.numeric(input$coupon_rate)),isolate(as.numeric(input$ytm)),isolate(as.numeric(input$years)),isolate(as.numeric(input$frequency))
            )
        })
    }
    )
   
       
        }
    
# Run the application 
shinyApp(ui = ui, server = server)
