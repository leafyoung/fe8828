library(alphavantager)
library(shiny)

av_api_key("V3XLEMS8AXD32CYN")

ui <- fluidPage(
  titlePanel("Data Downloader"),
  
  sidebarPanel(
    h4("Please enter a valid stock ticker"),
    textInput("ticker", "Ticker"),
    actionButton("go", "Get the data and plot it"),
  ),
  
  mainPanel(
    textOutput("message"),
    h4("Graph Output"),
    plotOutput("plot", width="600px", height="400px"),
  )
  
)


server <- function(input, output, session) {

  observeEvent(input$go, {
    df_res <- tryCatch({
      df_res <- av_get(input$ticker, 
                       av_fun = "TIME_SERIES_DAILY_ADJUSTED",
                       outputsize = "compact")
      df_res
    }, error = function(e) {
      NA
    })

    if (is.na(df_res)==TRUE) {
      output$message <- renderText( paste0( "Bad ticker ", 
                                             input$ticker, 
                                             "! Please enter a correct ticker!" ))
      output$plot <- renderPlot({})
    } else {
      output$message <- renderText( paste0( "Success! Plotting graph for ", 
                                            input$ticker) )
      output$plot <- renderPlot({
        plot(df_res$timestamp, df_res$adjusted_close)
      })
    }
  })
  
}


shinyApp(ui = ui, server = server)