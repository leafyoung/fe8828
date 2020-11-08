#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(alphavantager)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),
    textInput("key", "Your Api Key"),
    textInput("ticker", "Ticker of US stock"),
    actionButton("draw", "Draw the Plot"),
    actionButton("save", "Save the Data"),
    plotOutput("plot1")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    sum_v <- reactiveVal(0)
    getdata <- function(input){
        # MR0S87HBTFPPJAG7
        av_api_key(input$key)
        # To speed up download, we use compact to download recent 100 days.
        # outputsize is default to "compact"
        df_res <- tryCatch({
            df_res <- av_get(input$ticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED")
            df_res
        }, error = function(e) {
            NA
        })
        df_res
    }
    observeEvent(input$draw, {
        output$plot1<- renderPlot({plot(getdata(input)$timestamp, getdata(input)$adjusted_close, 
                                        xlab = "Date", ylab = "Time Stamp")})
    })
    observeEvent(input$save, {
        filename = paste(input$ticker, ".rds",collapse="")
        saveRDS(getdata(input), file = filename)})
}

# Run the application 
shinyApp(ui = ui, server = server)
