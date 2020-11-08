library(shiny)
library(alphavantager)
av_api_key("SJH9ANX0KBKUZJKA")

ui <- fluidPage(
    textInput("ticker", "Stock Ticker", "MSFT"),
    plotOutput("p1", click = "plot_click")
)

server <- function(input, output, session) {
    
      
    df_res <-  reactive({as.data.frame(av_get(input$ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED"))})
    output$p1 <- renderPlot({plot(df_res()$timestamp, df_res()$adjusted_close)})
}

shinyApp(ui, server)



