library(conflicted)
library(shiny)
library(DT)
library(bizdays)
library(tidyverse)

library(shiny)
conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

ui <- fluidPage(

    textInput("Stock_ticker","US Stock Ticker","MSFT"),
    textInput("File_name","File Name","C:/Users/josh1/Desktop/data.Rds"),
    actionButton("go","Download"),
    plotOutput("p1"),
    dataTableOutput("df")
)


server <- function(input, output,session) {

    df_res <- eventReactive(input$go, {
        Stock_ticker<-isolate(input$Stock_ticker)
        
        df_res <- av_get(Stock_ticker,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
        
        df_res 
        
    })
    
    output$p1 <- renderPlot({
        saveRDS(df_res(),file=isolate(input$File_name))
        plot(df_res()$timestamp, df_res()$adjusted_close)
        lines(df_res()$timestamp, df_res()$adjusted_close)
    })
    
    output$df <- renderDataTable({
        # use the reactive event like a function.
        df_res()
    })

}
# Run the application 
shinyApp(ui = ui, server = server)
