library(shiny)
library(alphavantager)
av_api_key("L0AXDQ8QMWBVJ4L1")

ui <- fluidPage(

    # Application title
    titlePanel("Alpha Vantage Data Downloader"),
    
    hr(),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        
        sidebarPanel(
            
            textInput("ticker",
                      "Ticker Symbol"),
            
            actionButton("go", "Get Data"),
            
            width = 2
        ),

        mainPanel(
            
            textOutput("error"),
            
            plotOutput("graph"),
            
            width = 10
           
        )
        
    )
)

server <- function(input, output) {
    
    observeEvent(input$go,{
        
        ticker <- isolate(input$ticker)
    
        df_res <- tryCatch({
            df_res <- av_get(ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED", outputsize = "compact")
            df_res
        }, error = function(e) {
            NA
        })
        
        if(all(is.na(df_res))){
            
            output$error <- renderText("Ticker symbol is invalid")
            
            output$graph <- NULL
            
        } else {
            
            output$error <- NULL
            
            output$graph <- renderPlot({
                
                plot(df_res$timestamp, df_res$adjusted_close,
                     main = toupper(ticker),
                     xlab = "Time",
                     ylab = "Adjusted Close Price")
                
                lines(df_res$timestamp, df_res$adjusted_close)
                
            })
        }
        
    })
    
}


shinyApp(ui = ui, server = server)
