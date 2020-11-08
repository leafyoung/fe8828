library(shiny)
library(alphavantager)
av_api_key("41Z15ZWB1H07CPWA")

ui <- fluidPage(

    # Application title
    titlePanel("Download Data from AlphaVantage"),
    
    # Sidebar for users to enter ticker symbol
    sidebarLayout(
        sidebarPanel(
            textInput('tickerSym', 'Ticker Symbol', 'BABA'),
            actionButton('downloadData', 'Download')
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("stockPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    stock_data <- eventReactive(input$downloadData, {
        tryCatch({
            av_get(isolate(input$tickerSym), av_fun = "TIME_SERIES_DAILY_ADJUSTED", outputsize = "compact")
        }, error = function(e) {
            NA
        })
    })
        
    output$stockPlot <- renderPlot({
        data <- stock_data()
        if (is.na(data)) showNotification("The ticker symbol is invalid. Please try again.", type = "error")
        else {
            saveRDS(data, file = paste0(isolate(input$tickerSym),".rds"))
            plot(data$timestamp, data$adjusted_close, type = 'o',
                 main = paste("Ticker Symbol:",isolate(input$tickerSym)),
                 xlab = "Date", ylab = "Adjusted Close")
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
