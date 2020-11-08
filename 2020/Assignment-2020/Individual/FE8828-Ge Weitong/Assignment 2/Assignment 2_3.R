#install.packages("alphavantager")

library(alphavantager)
library(shiny)
library(readr)
ui <- fluidPage(
  textInput("Stock","US Stock Ticker ","MSFT"),
  actionButton("go","Go"),
  
  dataTableOutput("df"),

  h3("Stock"),
#  textOutput("text")
  plotOutput("p1")
)

server <- function(input, output, session) {
  
  
  av_api_key("JF0AY4TAAGLRAH6B")
  # To speed up download, we use compact to download recent 100 days.
  # outputsize is default to "compact"
  
  df_res <- eventReactive(input$go, {
    Stock<-isolate(input$Stock)
    df_res <- av_get(Stock,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
    df_res 

    #is.na(df_res) # TRUE
    
    saveRDS(df_res(),file= "data.Rds")
  })
  
 # 
  # Load data from a file into a new variable `new_var`
  
  # plot
  output$p1 <- renderPlot({
    
    plot(df_res()$timestamp, df_res()$adjusted_close)
    lines(df_res()$timestamp, df_res()$adjusted_close)
  

  })

}

shinyApp(ui, server)