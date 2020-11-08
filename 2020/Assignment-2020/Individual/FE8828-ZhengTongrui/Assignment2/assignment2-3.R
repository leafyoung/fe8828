library(alphavantager)
av_api_key("5F5Y5417MP2U0NH0")


library(shiny)

ui <- fluidPage(
  textInput("ticker", "US stock ticker", "MSFT"),
  plotOutput("p1")
)

server <- function(input, output, session) {
  result<-reactiveVal(0)
  cal<-function(){
    df_res<-av_get(isolate(input$ticker),av_fun="TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
    saveRDS(df_res,file="data.Rds")
    df_res1<-readRDS(file="data.Rds")
    cls<-df_res1$adjusted_close
    result(cls)
  }
  
  observeEvent(input$ticker,cal())
  
  dates<-reactiveVal(0)
  cal_dates<-function(){
    df_res<-av_get(isolate(input$ticker),av_fun="TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
    date<-df_res$timestamp
    dates(date)
  }

  observeEvent(input$ticker,cal_dates())
  
  output$p1<-renderPlot({plot(dates(),result())})

}

shinyApp(ui, server)
