

library(shiny)
library(alphavantager)
av_api_key("GK5FZWUJFHRV0RS0")

ui <- fluidPage(

    titlePanel("Data Downloader"),
    textInput("ticker","Ticker name","AAPL"),
    selectInput("avfun","av_fun",choices=c("TIME_SERIES_DAILY_ADJUSTED","TIME_SERIES_INTRADAY","TIME_SERIES_DAILY","TIME_SERIES_WEEKLY","TIME_SERIES_WEEKLY_ADJUSTED","TIME_SERIES_MONTHLY","TIME_SERIES_MONTHLY_ADJUSTED")),
    selectInput("interval","interval(if you want intraday data)",choices=c("1min","5min","15min","30min","60min")),
    selectInput("size","outputsize",c("compact","full")),
    textInput("slice","slice(format:year(x)month(y) where x is 1 or 2 y is from 1 to 12)","year1month1"),
    textInput("location","save location","D:/"),
    actionButton("go","Go!"),
    div(textOutput("feasible"),style = "font-size:30px;",align="center"),
    div(textOutput("download"),style='font-size:30px;',align="center"),
    h1("Plot"),
    plotOutput("ticker")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    data<-eventReactive(input$go,{
        df=tryCatch({
        if (input$avfun=="TIME_SERIES_INTRADAY"){
            av_get(input$ticker,av_fun=input$avfun,interval=input$interval,slice=input$slice)
        } else {
            av_get(input$ticker,av_fun=input$avfun,outputsize=input$size)
        }},error=function(e){NA}
        )
        df
        })
    observeEvent(input$go,{
        if(is.na(data())){
            output$feasible<-renderText("This ticker doesn't exist.")
        }else {output$feasible<-renderText("") }
    })
    observeEvent(input$go,{
        location<-paste0(input$location,input$ticker,".Rds")
        saveRDS(data(),file=location)
        output$download<-renderText(paste0("The file is saved at ",location,"."))
        output$ticker<-renderPlot({
            plot(data()$timestamp, data()$close,xlab="timestamp",ylab="close price")
            lines(data()$timestamp, data()$close)
        })})


}

# Run the application 
shinyApp(ui = ui, server = server)
