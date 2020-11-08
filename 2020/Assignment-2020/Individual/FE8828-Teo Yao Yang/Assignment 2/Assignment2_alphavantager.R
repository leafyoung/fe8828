library(alphavantager)
library(tidyverse)
library(NLP)
av_api_key("A9MXXEHPH926F3N3")

ui <- fluidPage(
    textInput("ticker","ticker please", "MSFT"),
    actionButton("go", "Go"),
    plotOutput("mygraph"))


server <- function(input, output, session) {
    observeEvent(input$go, {
        df_res <- av_get(as.String(input$ticker),av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
        saveRDS(df_res, file = "resultData.rds")
        output$mygraph <- renderPlot(ggplot(df_res, aes(x = timestamp, y=adjusted_close)) + geom_line() + labs(title=input$ticker,x="date",y="price") )
    })

}

shinyApp(ui, server)

