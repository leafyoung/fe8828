library(shiny)
library(alphavantager)
av_api_key("CVENNBDLYQO8U23Y")

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidRow(
        column(12,
               wellPanel(
                   titlePanel("US Stock Ticker"),
                   textInput("stockTicker", "US Stock Ticker"),
                   actionButton("go", "Go")
                   
               ))
    ),
    fluidRow(
        column(8, h4('US Stock'),
               plotOutput("Stock"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output){
    observeEvent(input$go,
                 {
            
                    ticker <- input$stockTicker
                     df_res<- tryCatch({
                         df_res <- av_get(ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
                         df_res
                     }, error = function(e) {
                         NA
                     })
                     
                     output$Stock <- renderPlot({
                         plot(df_res$timestamp, df_res$adjusted_close)
                         lines(df_res$timestamp, df_res$adjusted_close)
                     })
                 }
                 )
}

# Run the application 
shinyApp(ui = ui, server = server)

