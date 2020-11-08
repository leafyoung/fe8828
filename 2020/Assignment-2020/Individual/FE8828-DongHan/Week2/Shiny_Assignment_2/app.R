# API key: WTFDPPSNCVUSLNHP
# install.packages("alphavantager")
API_KEY <- "WTFDPPSNCVUSLNHP"
library(shiny)
library(alphavantager) 
av_api_key(API_KEY)

# Define UI for application that draws a histogram
ui <- fluidPage(
    textInput("text", label = h3("Input a US stock ticker"), value = ""),
    actionButton("go", "Plot & Save"),
    plotOutput("p1"),
    dataTableOutput("dt1"),
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    df_res <- eventReactive(input$go,{
        av_get(input$text,
               av_fun = "TIME_SERIES_DAILY_ADJUSTED",
               outputsize="compact")
        # tryCatch({
        #     df_res <- av_get("SomeBADCODE",
        #                      av_fun = "TIME_SERIES_DAILY_ADJUSTED")
        #     df_res
        # }, error = function(e) {
        #     NA })
        # is.na(df_res) # TRUE
        
    })
    
    #Plot
    output$p1 <- renderPlot({
        plot(df_res()$timestamp, df_res()$adjusted_close)
        lines(df_res()$timestamp, df_res()$adjusted_close) 
        
       # saveRDS(df_res(), file = paste("data/", input$text, ".rds", sep=""))
        # saveRDS(df_res(), file = paste(input$text, ".RDS", sep=""))
        # readRDS(paste(input$text, ".RDS", sep=""))
        })
    
    output$dt1 <- renderDataTable(df_res(),
                                  options = list(pageLength = 5),
                                 
                                  saveRDS(df_res(), file = paste(input$text, ".RDS", sep="")),
                                  readRDS(paste(input$text, ".RDS", sep=""))
                                  )
 
}

# Run the application 
shinyApp(ui = ui, server = server)
