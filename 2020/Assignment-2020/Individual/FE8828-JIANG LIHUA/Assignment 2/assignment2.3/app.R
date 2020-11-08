#shiny assignment2-data downloader
library(shiny)
library(alphavantager)
av_api_key("J317PY07GDGI6M0K")

ui <- fluidPage(
    titlePanel("Stock Price"),
    textInput("ticker", "Name of US Stock Ticker",  "BABA"),
    actionButton("go","Go"),
    plotOutput("p1")
)

server <- function(input, output) {
    observeEvent(input$go,{
    ticker<-isolate(input$ticker)
    df_res<-av_get(ticker,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
    de_res<-tryCatch({
        df_res<-av_get("SomeBADCODE",av_fun = "TIME_SERIES_DAILY_ADJUSTED")
        df_res
    },error=function(e){
        NA
    })
    is.na(df_res)
    
    save(df_res,file="stockprice1.Rdata") 
    
    output$p1 <- renderPlot({
        plot(df_res$timestamp,df_res$adjusted_close)
    })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
