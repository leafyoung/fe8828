library(shiny)
library(alphavantager)
library(stats)

av_api_key("AY2V3XHP9IUGCKSL")

ui <- fluidPage(
    h1("Data Downloader"),
    h2("The stock you need"),
    textInput("ticker", "stock ticker", "MSFT"),
    hr(),
    h2("Visualize the data"),
    actionButton("show", "show"),
    textOutput("error"),
    plotOutput("plot"),
    h2("Download as RDS"),
    actionButton("save", "Download as .rds")
)

server <- function(input, output, session) {
    
    observeEvent(input$show,{
        df_res <- tryCatch({
            df_res <- av_get(symbol = input$ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED", outputsize="compact")
            df_res
        }, error = function(e) {NA})
        if(is.na(df_res)) {
            output$error <- renderPrint({cat("The stock ticker is wrong. Please try again!")})
            output$plot <- renderPlot(NULL)
        }
        else {
        output$plot <- renderPlot(plot(df_res$timestamp,df_res$close, type = "l", xlab = "time",ylab = "close"))
        observeEvent(input$save, {
            saveRDS(df_res, file="stock_data.rds")})
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
