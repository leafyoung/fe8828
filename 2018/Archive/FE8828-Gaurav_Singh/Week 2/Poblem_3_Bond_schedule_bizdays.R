library(shiny)
library(DT)
library(bizdays)
library(tidyverse)
library(shinythemes)
selectedTheme<-shinytheme("united")
completeOutput <- fluidPage(
                h2("Coupon Scedule"),
                fluidRow(
                  column(width=6,wellPanel(
                    dateInput(inputId="startDate","Enter Start Date:",value=Sys.Date()),
                    numericInput(inputId="ytm","Enter YTM:",value=4.0))
                  ),
                  column(width=6,wellPanel(
                    numericInput(inputId="tenor","Enter Tenor:",value=1,min=1),
                    selectInput(inputId="tenor_freq","Select Tenor Frequency:",c("Days"=1,"Months"=30,"Years"=360),selected=360)
                  ))
                ),
                wellPanel(fluidRow(
                  column(width=6,numericInput(inputId="rate","Enter Coupon Rate (%):",value=4)),
                  column(width=6,selectInput(inputId="freq","Select Coupon Frequency:",c("Monthly"=12,"2-months"=6,"Quarterly"=3,"Half-Yearly"=2,"Annualy"=1),selected=2))
                )),
                h3("Summary:"),
                wellPanel(tableOutput("table2")),
                navBar<-navbarPage(
                  "Coupon Schedule",
                  tabPanel(
                    "Complete Output",
                    wellPanel(tableOutput("table1"),
                              wellPanel("The table shows days and dates for calculated and actual payment of coupons and can be filtered to just give crisp output of the final dates. Also, the code for this bond schedule is a bit long because it accounts for possibility of maturity date lying before complete period of coupon payment.(Like hypothetically, 9 month bond giving coupon every 2 months and remaining on maturity.")
                              )
                    ),
                  tabPanel(
                    "Crisp Output",
                    wellPanel(tableOutput("table3"))
                    )
                  )
)

ui<-fluidPage(theme=selectedTheme,completeOutput)

server <- function(input, output, session) {
  generateSchedule<-reactive(
    {
      create.calendar(name='MyCalendar', weekdays=c('sunday', 'saturday'),adjust.from=adjust.next, adjust.to=adjust.previous)
      tenure_days<-as.numeric(input$tenor) * as.numeric(input$tenor_freq)
      bond_start<-input$startDate
      maturity_date<-as.Date(input$startDate+tenure_days)
      coupon_freq<-as.numeric(input$freq)
      rate_eff<-1+0.01*(as.numeric(input$ytm)/coupon_freq) #effective_period_discounting factor
      
      closest_payout<-maturity_date
      while(as.numeric(closest_payout-Sys.Date())>0)
      {
        closest_payout<-closest_payout-(12/coupon_freq)*30
      }
      closest_payout<-closest_payout+(12/coupon_freq)*30
      df2<-data.frame(
        "Date"=seq(from=bond_start,to=maturity_date,by=(12/coupon_freq)*30),
        "Day.Week"=weekdays(seq(from=bond_start,to=maturity_date,by=(12/coupon_freq)*30)),
        "Date2"=0,
        "Day.Week2"=0,
        "Days.Elapsed"=seq(from=0,to=tenure_days,by=(12/coupon_freq)*30),
        "payment"=round(input$rate/coupon_freq,digits=2),
        "discountedVal"=0
      )
      flag<-0
      curent_day<-0
      if(df2$Date[length(df2$Date)]==maturity_date)
      {
        flag=1
      }
      if(flag==0)
      {
        df1<-data.frame(maturity_date,weekdays(maturity_date),0,0,as.integer(maturity_date-bond_start),input$rate/coupon_freq,0)
        curent_day<-maturity_date-bond_start
        colnames(df1)<-colnames(df2)
        df2<-rbind(df1,df2)
      }
      
      df2$Date<-as.character(as.Date(df2$Date,origin="1970-01-01"))
      df2$Days.Elapsed<-as.integer(df2$Days.Elapsed)
      df2<-arrange(df2,Days.Elapsed)
      df2$Date2<-following(df2$Date,"MyCalendar")
      df2$Date2<-as.character(as.Date(df2$Date2,origin="1970-01-01"))
      df2$Day.Week2<-weekdays(as.Date(df2$Date2))
      df2$payment[1]<-0
      df2$payment[nrow(df2)]<-df2$payment[nrow(df2)]+100
      
      for(i in 1:nrow(df2))
      {
        df2$discountedVal[i]<-round(df2$payment[i]*(rate_eff ** (-i+1)),digits=2)
      }
      
      colnames(df2)<-c(
        
        "Date of Coupon",
        "Original Day Of The Week",
        "Actual Payment Date",
        "Payment Day",
        "Days Elapsed since start",
        "Coupon Payment",
        "Discounted Value"
      )
      return(df2)
    }
  )
  
  output$table1 <- renderTable(generateSchedule())
  
  output$table2 <- renderTable({
    data1<-generateSchedule()
    return(data.frame("Bond NPV"=sum(data1$"Discounted Value"),"Sum of Coupons"=sum(data1$"Coupon Payment")))
  })
  
  output$table3 <- renderTable({
    df1<-generateSchedule()
    dd<-cbind(df1$"Actual Payment Date",df1$"Coupon Payment",df1$"Discounted Value")
    colnames(dd)<-c("Actual Payment Date","Coupon Payment","Discounted Value")
    return(dd)
  })
  
}
shinyApp(ui, server)