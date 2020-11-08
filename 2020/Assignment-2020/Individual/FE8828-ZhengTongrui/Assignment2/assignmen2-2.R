library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)

ui <- fluidPage(
    h3("BOND CALCULATION"),
    dateInput("start_date", "start date"),
    numericInput("tenor", "tenor", 10),
    numericInput("par", "par value", 1000),
    numericInput("coupon_rate", "coupon rate", 0.6),
    selectInput("frequency", "coupon frequency", c("A","H","Q","M")),
    numericInput("ytm", "yield to maturity", 0.05),
    actionButton("Cal","Bond Calculation"),
    
    h3("Cash Flow Schedule"),
    dataTableOutput("t1"),
    h3("Cash Flow plot"),
    plotOutput("p1"),
    h3("NPV Value"),
    textOutput("NPV")
)




server <- function(input, output, session) {
    
    cal<-function(){
        end_date<-as.Date(input$start_date+years(input$tenor))
        if(input$frequency=="A") {dates<-seq.Date(input$start_date,end_date,by="year")}
        if(input$frequency=="H") {dates<-seq.Date(input$start_date,end_date,by="6 months")}
        if(input$frequency=="Q") {dates<-seq.Date(input$start_date,end_date,by="3 months")}
        if(input$frequency=="M") {dates<-seq.Date(input$start_date,end_date,by="month")}
        dates<-dates[-1]

        if (input$frequency=="A") {freq<-1}
        if (input$frequency=="H") {freq<-2}
        if (input$frequency=="Q") {freq<-4}
        if (input$frequency=="M") {freq<-12}
        No<-seq_along(dates)
        cf<-rep(input$par*input$coupon_rate/freq,length(No))
        cf[length(No)]<-input$par*input$coupon_rate+input$par
        dcf<-cf/(1+input$ytm)^No
        
        bond<-tibble(No=No,dates=dates,cf=cf,dcf=dcf)
        return (bond)
    }
    observeEvent(input$Cal,{
        result<-cal()
        plotmat<-tibble(result$dates,result$cf)
        output$t1 <- renderDataTable(result)
        output$p1<-renderPlot(barplot(plotmat))
        output$NPV <- renderText({sum(result$dcf)})
        output$p1<-renderPlot({ggplot(result, aes(x=result$dates,y=result$cf)) +geom_bar(stat="identity")}) 
    })
}

shinyApp(ui, server)