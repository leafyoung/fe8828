library(shiny)
library(alphavantager)


ui <- fluidPage(
    selectInput("stockticker","US Stock Ticker:",choices = c("ABC","QWE")),
    h4("Stock Data"),
    tableOutput("stockData"),
)

server <- function(input, output, session) {
    #Generate random sample data
    ABCdata<-sample(90:120,20,replace = TRUE,prob = NULL)
    QWEdata<-sample(70:100,20,replace = TRUE,prob = NULL)

    output$stockData<-renderTable(
        if(input$stockticker =="ABC")
            ABCdata
        else
            QWEdata
        )
    resultData<-rbind(ABCdata,QWEdata)
    saveRDS(resultData,"stockData.rds")
    
}



shinyApp(ui = ui, server = server)
