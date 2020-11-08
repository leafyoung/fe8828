library(conflicted)
library(shiny)
library(DT)
library(tibble)
library(lubridate)
library(ggplot2)

Sys.setlocale("LC_TIME", "English")

conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

ui <- fluidPage(
  fluidRow(
    h4("Bond information"),br(),
    column(4, 
           selectInput('CouponFreq', 'Coupon Frequency', c("A","H","Q","M")),
           dateInput('Startdate', 'start date', value = "2020-01-01"),
           numericInput('Par', 'Par Value',  100 ), 
    ),
    column(4,
           numericInput('YTM', 'YTM', 0.03),
           numericInput('CouponRate','Coupon rate',0.04),
           numericInput('Tenor', 'Tenor',10)
    )
  ), 
    actionButton("Cal","Cal"),hr(),
    h4('NPV of this bond'),
    textOutput("NPV"),
  fluidRow(
    column(6, h3("Cash flow"), dataTableOutput("cf")),
    column(6, h3("plot"),plotOutput("p1")))
)


server <- function(input, output, session) {
  
  cftable <- function(){
      Enddate <- input$Startdate+years(input$Tenor)
      a <- seq.Date(as.Date(input$Startdate), as.Date(Enddate), 
                    by = switch(input$CouponFreq, "A"= "1 year", "H"= "6 months","Q"= "3 months","M"= "month" ))
      a<-a[-1]
      for(i in seq_along(a)){
        if(weekdays(a[i])=="Sunday"){a[i] <- a[i] + 1}
        if(weekdays(a[i])=="Saturday"){a[i] <- a[i] + 2}
      }
      
      
      times <- switch(input$CouponFreq, "A"= 1, "H"= 2,"Q"= 4,"M"= 12 )
      CouponAmt <- input$Par * input$CouponRate / times
      Tenor <- seq(from=1/times, to=input$Tenor, by=1/times)
      cashflow <- rep(1,times*input$Tenor) * CouponAmt
      cashflow[length(cashflow)]=cashflow[length(cashflow)]+input$Par
      d_cashflow <- cashflow*((1+input$YTM/times)^(-Tenor*times))
      
      df <- data.frame(a, Tenor, cf =cashflow, dcf=d_cashflow)
  }
  
  
  observeEvent(input$Cal,{
    t <- cftable()
    output$NPV <- renderText({sum(t$dcf)})
    output$cf <- renderDataTable(t,options = list(pageLength = 12),server = FALSE)
    #output$p1<-renderPlot({plot(t$a,cftable()$cf,type="h")})  
    output$p1<-renderPlot({ggplot(t, aes(x=t$a,y=t$cf)) +geom_bar(stat="identity")+xlab("Date")+ylab("Amount")})  
    
  })

}

shinyApp(ui, server)