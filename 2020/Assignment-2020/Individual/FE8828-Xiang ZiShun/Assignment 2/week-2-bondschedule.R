library(shiny)
library(tidyverse)
library(lubridate)
library(bizdays)

ui <- fluidPage(

    # Application title
    titlePanel("Bond Schedule"),
    
    hr(),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            strong("Bond par value is $100"),
            
            hr(),
            
            dateInput("startDate",
                      "Start Date",
                      format = "yyyy-mm-dd"),
            
            numericInput("tenor",
                         "Tenor (in years)",
                         value = 1,
                         min = 1,
                         max = 100,
                         step = 1),
            
            numericInput("couponRate",
                         "Coupon Rate (%)",
                         value = 0,
                         min = 0,
                         max = 100,
                         step = 0.1),
            
            selectInput("couponFrequency",
                        "Coupon Frequency",
                        c("Quarter", "Half-Year", "Annual")),
            
            numericInput("yield",
                         "Yield to Maturity (%)",
                         value = 0,
                         min = 0,
                         max = 100,
                         step = 0.1),
            
            actionButton("go", "Calculate and Plot")
            
        ),
        
        
        mainPanel(
            
            textOutput("npv"),
            
            hr(),
            
            tableOutput("table"),
            
            plotOutput("chart1"),
            
            plotOutput("chart2")
            
        )
    )
)

server <- function(input, output) {
    
    observeEvent(input$go,{
        
        faceValue <- 100
        startDate <- isolate(input$startDate)
        tenor <- isolate(input$tenor)
        rate <- isolate(input$couponRate / 100)
        freq <- isolate(input$couponFrequency)
        yield <- isolate(input$yield / 100)
        
        if(freq == "Quarter"){
            addmonths <- 3
            div <- 4
            intervals <- div * tenor
        } else if(freq == "Half-Year"){
            addmonths <- 6
            div <- 2
            intervals <- div * tenor
        } else if(freq == "Annual"){
            addmonths <- 12
            div <- 1
            intervals <- div * tenor
        }
        
        bondTable <- tibble('Payout Date' = as.character(adjust.previous(startDate %m+% (addmonths * months(c(1:intervals))), "weekends")),
                            'Cashflow Amount' = rep((rate/div)*faceValue, intervals))
        
        bondTable$'Cashflow Amount'[intervals] <- bondTable$'Cashflow Amount'[intervals] + faceValue
        
        bondTable$'Cashflow Present Value' <- bondTable$'Cashflow Amount' / ((1+(yield/div))^c(1:intervals))
        
        output$npv <- renderText(paste0("The Net Present Value (NPV) of bond is $", round(sum(bondTable$'Cashflow Present Value'),2)))
        
        output$table <- renderTable(bondTable)
        
        output$chart1 <- renderPlot({
            
            par(mar=c(8,5,2,1))
            
            barplot(bondTable$'Cashflow Amount',
                    names.arg = bondTable$'Payout Date',
                    main = "Cash Plot",
                    ylab = "Cashflow Amount",
                    las = 2)
            
        })
        
        output$chart2 <- renderPlot({
            
            par(mar=c(8,5,2,1))
            
            barplot(bondTable$'Cashflow Present Value',
                    names.arg = bondTable$'Payout Date',
                    main = "Present Value Plot",
                    ylab = "Present Value",
                    las = 2)
            
        })
        
    })
    
}

shinyApp(ui = ui, server = server)