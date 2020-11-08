# WU Hongsheng
# G2000655A
# Q3

library(shiny)
library(bizdays)
library(alphavantager)

ui <- fluidPage(
    h3("--- Input API Key ---"),
    textInput("key", "YOUR KEY HERE", "1E8IOHPTPNIQE4IY"),
    h3("--- Input a US Stock Ticker ---"),
    textInput("ticker", "TICKER", "MSFT"),

    actionButton("go", "Search and Display"),
    downloadButton('dl', 'Download Data'),
    
    h4("The Data"),
    dataTableOutput("Table"),
    h4("Plot"),
    plotOutput("p1")
)

server <- function(input, output, session) {
    
    observeEvent(input$go, {
        av_api_key(isolate(input$key))
        df_res <- tryCatch({
            df_res <- av_get(isolate(input$ticker), av_fun = "TIME_SERIES_DAILY_ADJUSTED")
            df_res
        }, error = function(e) {
            df_res = tibble(NODATA = "No data!", WARNING = "Wrong Ticker!")
        })
        
        output$Table <- renderDataTable({
            df_res
        })
        
        output$p1 <- renderPlot({
            plot(df_res$timestamp, df_res$adjusted_close, xlab = "Date",
                 ylab = "Adjusted Close", col = "orange", lwd = 3)
            lines(df_res$timestamp, df_res$adjusted_close, col = "blue", lwd = 3)
            
        })
        
        output$dl <- downloadHandler(
            filename <- function(){
                paste("data.Rds")
            },
            content = function(file) {
                saveRDS(df_res, file = file)
            }
        )
    })
}

shinyApp(ui, server)