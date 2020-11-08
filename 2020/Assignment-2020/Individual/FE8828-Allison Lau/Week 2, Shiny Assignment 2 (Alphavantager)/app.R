library(shiny)
library(alphavantager)

source("stocks.R", local = TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(
    textInput(inputId = "ticker", "Enter ticker symbol:", placeholder = "e.g. MSFT"),
    actionButton(inputId = "go", "Go"),
    plotOutput("p1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$go, {

    output$p1 <- renderPlot({
        graph(isolate(input$ticker))
    })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
