#shiny assignmen-1:coupon schedule
Sys.setlocale("LC_ALL","English")
library(lubridate)
library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Bond Schedule"),
    dateInput("startdate","Start Date","2009-02-18"),
    numericInput("tenor","Tenor",10),
    numericInput("facevalue","Face Value",100),
    numericInput("couponrate","Coupon Rate",0.1),
    textInput("frequency","Conpon Frequency","Q"),
    numericInput("ytm","Yield to Maturity",0.05),
    actionButton("go", "Go"),
    tableOutput("t1"),
    plotOutput("p1")
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    observeEvent(input$go,{
        startdate<-isolate(input$startdate)
        tenor<-isolate(input$tenor)
        facevalue<-isolate(input$facevalue)
        couponrate<-isolate(input$couponrate)
        frequency<-isolate(input$frequency)
        ytm<-isolate(input$ytm)
        
        if(frequency=="Q"){
            freq=4
        }
        if(frequency=="H"){
            freq=2
        }
        if(frequency=="A"){
            freq=1
        }
    
        date<-as.Date(numeric(length = tenor*freq),origin=startdate)
        date2<-startdate
        date3<-date[1]
        year(date3)<-year(date3)+tenor
        date_sequence <- seq.Date(date[1],date3, "day")
        date_s_workday<-date_sequence[!(wday(date_sequence) %in% c(1, 7))]
    
    if(freq==4){
        for(i in 2:(tenor*4)){
            month(date2)<-month(date2)+3
            date[i]<-date2
            if(weekdays(date[i])=="Saturday"){
                day(date[i])<-day(date[i])+2
            }
            if(weekdays(date[i])=="Sunday"){
                day(date[i])<-day(date[i])+1
            }
        }
    }
    if(freq==2){
        for(i in 2:(tenor*2)){
            month(date2)<-month(date2)+6
            date[i]<-date2
            if(weekdays(date[i])=="Saturday"){
                day(date[i])<-day(date[i])+2
            }
            if(weekdays(date[i])=="Sunday"){
                day(date[i])<-day(date[i])+1
            }
        }
    }
    if(freq==1){
        for(i in 2:tenor){
            year(date2)<-year(date2)+1
            date[i]<-date2
            if(weekdays(date[i])=="Saturday"){
                day(date[i])<-day(date[i])+2
            }
            if(weekdays(date[i])=="Sunday"){
                day(date[i])<-day(date[i])+1
            }
        }
    }
    
    x<-(couponrate/freq)*facevalue
    cf_av<-c()
    for(i in 1:((tenor*freq)-1)){
        cf_av[i]<-x
    }
    y<-facevalue+x
    cf_av[tenor*freq]<-y
    
    no<-c(1:(tenor*freq))
    table<-data.frame(Number=no,Date=date,Cashflow=cf_av)
    output$t1 <- renderTable({
        mutate(table, Date = as.character(Date, format = "%Y-%m-%d"))
    },striped=TRUE,hover = TRUE)
    output$p1 <- renderPlot({plot(table$Date,table$Cashflow)})
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
