library(shiny)
library(alphavantager)
av_api_key("83PICHC4CJJUCF0Y")

ui <- fluidPage(

    titlePanel("US Stock Downloader"),

    sidebarLayout(
        sidebarPanel(
            textInput("sticker", "US Stock Sticker"),
            textInput("func", "Function"),
            actionButton("go", "Go"),
            actionButton("download", "Download")
        ),

        mainPanel(
           plotOutput("p1"),
           plotOutput("p2"),
           plotOutput("p3"),
           plotOutput("p4"),
           plotOutput("p5")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    data_reactive <- eventReactive(input$go, {
        df_res <- tryCatch({
            df_res <- av_get(input$sticker, av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
            as.data.frame(df_res)
        }, error = function(e) {
            NA
        })
    })
    
    output$p1 <- renderPlot({
        df <- data_reactive()
        if (is.na(df)!=TRUE){
            timestamp <- df[,1]
            open <- df[,2]
            plot(timestamp,open,xlab="open price",ylab="timestamp",type="l")
        }
    })
    
    output$p2 <- renderPlot({
        df <- data_reactive()
        if (is.na(df)!=TRUE){
            timestamp <- df[,1]
            high  <- df[,3]
            plot(timestamp,high,xlab="high price",ylab="timestamp",type="l")
        }
    })
    
    output$p3 <- renderPlot({
        df <- data_reactive()
        if (is.na(df)!=TRUE){
            h3("Query succeed, you can download date now.")
            timestamp <- df[,1]
            low <- df[, 4]
            plot(timestamp,low,xlab="low price",ylab="timestamp",type="l")
        }
    })
    
    output$p4 <- renderPlot({
        df <- data_reactive()
        if (is.na(df)!=TRUE){
            timestamp <- df[,1]
            close <- df[,5]
            plot(timestamp,close,xlab="close price",ylab="timestamp",type="l")
        }
    })
    
    output$p5 <- renderPlot({
        df <- data_reactive()
        if (is.na(df)!=TRUE){
            timestamp <- df[,1]
            volume <- df[,6]
            plot(timestamp,volume,xlab="volume",ylab="timestamp",type="l")
        }
    })
    
    # save as rds file
    observeEvent(input$download, {
        df <- data_reactive()
        if (is.na(df)!=TRUE){
            saveRDS(df, file = "stock.rds")
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
