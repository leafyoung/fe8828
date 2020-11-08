library(alphavantager)
library(shiny)

av_api_key("LA5ZRKL6QJIB56JO")

ui <- fluidPage(
    fluidRow(
        textInput("ID","Stock","FB"),
        selectInput("type","Data Type", c("TIME_SERIES_DAILY","TIME_SERIES_INTRADAY")),
        selectInput("interval","Time Interval(for INTRADAY data only)",
                    c("1min","5min","15min","30min","60min")),
        actionButton("extract","Extract")),
        hr(),
        h3("Stock Price"), 
        dataTableOutput("sp"), 
        actionButton("save","Save"),
        h3("Plot"),
        plotOutput("p")
)

server <- function(input, output, session) {
    getData <- function(){
        df_res <- av_get(input$ID, input$type , input$interval, outputsize = "compact")
    }
    observeEvent(input$extract,{
        observeEvent(input$save, saveRDS(getData(), file="stock.rds"))
        output$sp <- renderDataTable(getData(),options = list(pageLength = 12))
        output$p <- renderPlot({plot(getData()$timestamp,getData()$close)})
        })
}

shinyApp(ui, server)