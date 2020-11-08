library(shiny)
library(alphavantager)
library(haven)

ui <- fluidPage(
    textInput("tkt","Stock Ticker","AAPL"),
    actionButton("go", "Go"),
    plotOutput("p1")
)

server <- function(input, output) {
    observeEvent(input$go, {
    av_api_key("KJ8R86OYK4WZGWYC")
    
    df_res <- reactiveVal(0)
    get_dfres <- function(){
        res <- tryCatch({ 
            res <- av_get("SomeBADCODE", av_fun = "TIME_SERIES_DAILY_ADJUSTED") 
            res }, error = function(e) { 
                NA 
            }) 
        is.na(res) # TRUE
        
        res <- av_get(isolate(input$tkt),av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
        df_res(res)
        saveRDS(df_res, "Stock_Price.rds") #save as RDS Format
    }
    observeEvent(isolate(input$tkt),get_dfres())
    
    output$p1 <- renderPlot({
        plot(x=df_res()$timestamp, y=df_res()$adjusted_close,type="l",
             xlab="date", ylab="stock price") 
    })
    })
}

shinyApp(ui = ui, server = server)
