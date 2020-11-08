library(shiny)

ui <- fluidPage(
    titlePanel("Data Downloader"),
    sidebarLayout(
        sidebarPanel(
            textInput("ticker","Stock ticker"),
            dateInput("start","Start Date"),
            dateInput("end","End Date"),
            actionButton("plot","Plot")
        ),
        mainPanel(
            verbatimTextOutput("Message"),
            plotOutput("Price")
        )
    )
)

server <- function(input,output,session){
    observeEvent(input$plot, {
        library(alphavantager)
        av_api_key("5WZYQ22PJ7YB73U2")
        df_res <- tryCatch({
            df_res <- av_get(isolate(input$ticker),av_fun = "TIME_SERIES_DAILY_ADJUSTED",interval="daily",outputsize="full")
            dv <- as.data.frame(df_res)        
            st <- as.character(isolate(input$start))
            en <- as.character(isolate(input$end))
            df_res <- dv[dv[[1]]>=st & dv[[1]]<=en, ]
            },error = function(e){
                NA
            })
        
        print(df_res)
        
        saveRDS(df_res,file="data.RDS")
        stockdata <- readRDS(file="data.RDS")
        
        output$Message <- renderPrint({
            if(is.na(stockdata)) {
                "Invalid ticker, try again"
            } else {
                "Here are your results"
            }
        })
        
        output$Price <- renderPlot({plot(stockdata[['timestamp']],stockdata[['adjusted_close']],
                                         main = paste(toupper(isolate(input$ticker)),"Historical price"),
                                         sub = paste("From",st,"to",en),
                                         xlab = "Date",
                                         ylab="Adjusted close price")},
                                   width=600)
    })
    
}

shinyApp(ui,server)
