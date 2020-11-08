library(alphavantager)
library(shiny)



av_api_key("WZST1Q60LI2GUIVW")
#test <- av_get(symbol = "MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "15min", outputsize = "full")

ui <- fluidPage(
    fluidRow(
        textInput("StockID","Stock Symbol","MSFT"),
        selectInput("Fun","Data kind",c("TIME_SERIES_DAILY_ADJUSTED","TIME_SERIES_INTRADAY")),
        selectInput("Interval","Time interval (applicable for INTRADAY data)",
                    c("1min","5min","15min","30min","60min")),
        actionButton("Extract","Extract")
        )
    , hr(),
    textOutput("check"),
    h3("Stock Price"), 
    dataTableOutput("SP"), actionButton("Save","Save"),
    h3("plot"),
    plotOutput("p1")

)



server <- function(input, output, session) {
    
    ExtractData <- function(){
        stock <- input$StockID
        kind <- input$Fun
        interval <- input$Interval
        t <- av_get(symbol = stock, av_fun = kind, interval = interval, outputsize = "compact")
    }
    
    observeEvent(input$Extract,{
        stock <- input$StockID
        
        df_res <- tryCatch({
            df_res <- av_get(stock, av_fun = "TIME_SERIES_DAILY_ADJUSTED")
            df_res
        }, error = function(e) {
            NA
        })
        
        if(is.na(df_res)){
            output$check <- renderPrint({cat("Please input right stock ticker")})  
            output$SP <- renderDataTable({NULL})
            output$p1 <- renderPlot({NULL})
        }
        else{
            t <- ExtractData()
            output$SP <- renderDataTable(t,options = list(pageLength = 12))
            output$p1 <- renderPlot({plot(t$timestamp,t$close,type="l")})
            observeEvent(input$Save, saveRDS(t, file="stock.rds"))
        }
    })
    
}

shinyApp(ui, server)