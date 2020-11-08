library(tidyverse)
library(conflicted)
library(shiny)
library(DT)
library(bizdays)
conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

ui <- fluidPage(
  textInput("start_day","Start day","2020-08-01"),
  numericInput("tenor","Tenor",5),
  numericInput("YTM","Yield to maturity",0.08),
  numericInput("coupon_rate","Coupon rate",0.05),
  textInput("coupon_freq","coupon frequency : Annual, Semi-Annual, Quarter","Semi-Annual"),
  actionButton("go","Go"),
  plotOutput("p1"),
  dataTableOutput("df"),

  h3("Bond Price"),
  textOutput("text")
)


server <- function(input, output, session) {
  
  bond_cf <- eventReactive(input$go, {
    start_day <- isolate(as.Date(input$start_day))
    tenor<- isolate(input$tenor)
    YTM <- isolate(input$YTM)
    coupon_freq<-isolate(input$coupon_freq)
    coupon_rate<-isolate(input$coupon_rate)
    total_days<-tenor*360  #total duration
    if (coupon_freq=="Annual"){
      coupon_freq_dys=360    #each coupon payment duration
    }
    if (coupon_freq=="Semi-Annual"){
      coupon_freq_dys=360/2
    }
    if (coupon_freq=="Quarter"){
      coupon_freq_dys=360/4
    }
    # CF calc
    cf<-rep(100*coupon_rate,total_days/coupon_freq_dys)
    cf[length(cf)]<- tail(cf) + 100  # last cf = coupon + 100 face value
    
    
    dates<-list()
    dates[1]<-start_day #initialize first start day
    for (k in 2:(total_days/coupon_freq_dys)) {
      dates[k]<-add.bizdays(as.Date.numeric(sapply(dates[k-1], function(v) return(v[1])),origin="1970-01-01"),coupon_freq_dys,cal="weekends")
    }
    
    dates<-as.Date(as.Date.numeric(sapply(dates, function(v) return(v)),origin="1970-01-01"),"%m/%d/%y")
    
    bond_cf <- tibble(date = c(dates), cf = c(cf) )
    bond_cf["factor"]<- 1:(total_days/coupon_freq_dys)/360*(total_days/coupon_freq_dys)
    bond_cf
    
    #output$p1 <- renderPlot({ plot(c(dates),c(cf)) })
  })
  
  output$p1 <- renderPlot({ 
    title("Bond Schedule")
    plot(bond_cf()$date , bond_cf()$cf ) 
  })
  
  output$df <- renderDataTable({
    
    bond_cf()
  })

  
  output$text <- renderText({
    
    bond_price <- sum(exp(- isolate(input$YTM) * bond_cf()$factor) * bond_cf()$cf)
    paste0("Bond Price is: ", bond_price)
  })
  
}

shinyApp(ui, server)
