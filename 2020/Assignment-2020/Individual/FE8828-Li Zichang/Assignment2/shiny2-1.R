library(tidyverse)
library(shiny)
library(bizdays)

# Define UI for application that draws a histogram
ui <- fluidPage(

        titlePanel("Bond Schedule"),
    
        dateInput("start date", "start date", "2020-10-03"),
        numericInput("tenor","tenor",3),
        numericInput("P_v", "Par_value", 100),
        numericInput("c_r", "coupon_rate(annual)", 0.05),
        numericInput("fq","frequency(in month unit)", 6, min = 3, 
                     max = 12, step = 3),
        numericInput("YTM", "Yield_to_Maturity", 0.03),
        
        plotOutput("p1")
        )

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    #cf <- reactiveValues()
    

    rcf <- function(){
        specific_coupon <- input$c_r * (input$fq / 12)
        cpay_times <- input$tenor * (12 / input$fq) - 1
        cf <- c(rep(input$P_v * specific_coupon, cpay_times), 
                input$P_v * (1 + specific_coupon))
        barplot(cf)
    }
#how to put the date tag on the x-axis?...
    
    observeEvent(input$P_v, rcf())
    observeEvent(input$c_r, rcf())
    
    output$p1 <- renderPlot({
        rcf()
    })
}


# Run the application 
shinyApp(ui = ui, server = server)

