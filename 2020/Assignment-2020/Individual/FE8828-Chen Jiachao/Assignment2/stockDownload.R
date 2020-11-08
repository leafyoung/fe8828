library(shiny)
library(alphavantager)

ui <- fluidPage(
  textInput("ticker", "ticker",value = "TSLA"),
  plotOutput("price")
)

server <- function(input, output, session) {
  df_res <- reactive({
    av_get(input$ticker,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
  })
  
  output$price <- renderPlot({
    plot(df_res()$timestamp, df_res()$adjusted_close) 
    lines(df_res()$timestamp, df_res()$adjusted_close)
  })
}

shinyApp(ui = ui, server = server)