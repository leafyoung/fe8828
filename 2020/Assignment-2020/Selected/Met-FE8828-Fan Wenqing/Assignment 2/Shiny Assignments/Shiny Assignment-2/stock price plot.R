library(shiny)
library(alphavantager)
av_api_key("GUZ0KX41KZZDCDOX")

ui <- fluidPage(
    textInput("stock", "US Stock", "MSFT"),
    actionButton("go", "Go"),
    plotOutput("p1")
)


server <- function(input, output) {
    observeEvent(input$go, {
      output$p1 <- renderPlot({
        df_res <- isolate(av_get(input$stock,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact"))
        saveRDS(df_res, file = "/Users/fanwenqing/Desktop/R/week1_and_2_demo/stock price.Rds")
        
        plot(df_res$timestamp, df_res$adjusted_close) 
        lines(df_res$timestamp, df_res$adjusted_close)
})
})
}


shinyApp(ui = ui, server = server)
