library(shiny)
library(shinythemes)
library(lubridate)
library(bizdays)
Webpagetheme<-shinytheme("journal")

#wellpanel1<-wellPanel(tags$h4("Net Present Value"),verbatimTextOutput("summary"))


ui <- fluidPage(theme=Webpagetheme,titlePanel("Bond Pricer"),
                sidebarLayout(
                  sidebarPanel(
                    helpText("Enter The Start Date, Tenor, Coupon Frequency and Yield to Maturity below"),
                    dateInput("StartDate"," Issue Date","2018-01-01"),
                    numericInput("Par","Issue Price","100","0","","1"),
                    numericInput("Tenor","Bond Tenor(Years)","8",">0","","1"),
                    numericInput("CouponRate","Coupon Rate(%)","7.25","0","","0.01"),
                    radioButtons("Frequency", "Coupon Frequency:",
                                 c("Annual" = "Ann",
                                   "Semi-Annual" = "Sann",
                                   "Quarterly" = "Quar",
                                   "Monthly" = "Mon")),
                    numericInput("YTM","Yield to Maturity(%)","5.6","0","","0.01"),
                    wellPanel(tags$h4("Net Present Value"),verbatimTextOutput("summary"))),
                    mainPanel(dataTableOutput("table1"))
                   
                  
                )
)
server <- function(input, output) {
 
  BondPricer <- reactive({
    CF<-switch(input$Frequency,
               Ann = 360,
               Sann = 180,
               Quar = 90,
               Mon = 30,
                      360)
    
    numberofpayments=floor(input$Tenor*(360/CF))
    PeriodDifference=input$Tenor*(360/CF)-floor(input$Tenor*(360/CF))
    yieldtomaturity=(1+input$YTM/100)^(1/(360/CF))-1
    AdjustedCoupon=input$CouponRate/(360/CF)
    dateincrement=CF/30
    d1=as.Date(input$StartDate)
    datearray[1]=d1
    if(numberofpayments==0)
    {
      return(bondtable<-data.frame(datearray,couponpayment,discountrate,cashflow))
    }
      for(i in 1:numberofpayments)
      {
        # month(d1)=month(d1)+(dateincrement)
        # d1=following(d1)
        # datearray[i]=as.character(d1)
        month(d1)=month(d1)+(dateincrement)
        if(weekdays(d1)=="Saturday")
        {
          temp=as.Date(d1)
          day(temp)=day(temp)+2
          datearray[i]=as.character(temp)
        }
        else if(weekdays(d1)=="Sunday")
        {
          temp=as.Date(d1)
          day(temp)=day(temp)+1
          datearray[i]=as.character(temp)
        }
        else
        {
          month(d1)=month(d1)+(dateincrement)
          datearray[i]=as.character(d1)
        }
        if(i==numberofpayments)
          couponpayment[i]=round((AdjustedCoupon/100)*input$Par + input$Par,3)
        else
          couponpayment[i]=round((AdjustedCoupon/100)*input$Par,3)
        discountrate[i]=round(1/(1+(yieldtomaturity))^(i+PeriodDifference),3)
        cashflow[i]=discountrate[i]*couponpayment[i]
      }
      bondtable<-data.frame(datearray,couponpayment,discountrate,cashflow)
      names(bondtable)[1]<-paste("Payment Dates")
      names(bondtable)[2]<-paste("Coupon Payments")
      names(bondtable)[3]<-paste("Discount Factor")
      names(bondtable)[4]<-paste("Present Value of Cash Flows")
      return(bondtable)
    
  })
  output$summary<-renderText({
      df<-BondPricer()
      sum(round(df[4],1))
    }
  )
  
  output$table1<-renderDataTable(BondPricer(),
                                 options = list(pageLength = 100,searching=FALSE),
                                 server = FALSE)
}
shinyApp(ui = ui, server = server)