library(shiny)
library(DT)
library(bizdays)
# library(FinCal)


ui <- fluidPage(
  h4("By default this is a 10 year bond."),
  dateInput("date1", "Start Date"),
  selectInput("frequency","Coupon Frequency:",choices = c("Quarter","Semi Annual","Annual")),
  numericInput("yield","Yield to Maturity",0.1),
  actionButton("go", "Go"),
  h4("Coupon Schedule"),
  tableOutput("CouponSchedule"),
  plotOutput("plotCF"),
)

server <- function(input, output, session) {
  
  date2 = as.Date("2030-12-31")
  
  Cal <- function(){
    if (isolate(input$frequency) == "Annual"){
      r1 = isolate(input$yield)
      date1 = isolate(input$date1)

      create.calendar(name='MyCalendar',weekdays=c('sunday', 'saturday'),start.date = date1,end.date = date2,
                      adjust.from=adjust.next, adjust.to=adjust.previous)
      N = (bizdays(date1,date2,cal="MyCalendar")/250)*10
      x<-seq(0,0)
      i<-1
      while(i<N+1){
        x<-c(x,npv(r1,seq(100,100,length.out = i)))
        i<-i+1
      }
      print(x)
      df1 = data.frame(x)
    }
    else if (isolate(input$frequency) == "Semi-Annual") {
      # add code here
    }
    else if (isolate(input$frequency) == "Quarter") {
      # add code here
    }
    
    # return df1 in the end
    df1 
  }
  
  # here build the reactivity between go button and cal()
  observeEvent(input$go,Cal())
  
  # calls the reactive event Cal like a function with ()
  output$CoupleSchedule<-renderDataTable({
    Cal()
  })

  # use isolate here so we don't build reactivity between input fields with output.
  # The inter-link is the go button.  
  output$plotCF<-renderPlot({
    plot(seq(from =  isolate(input$date1), to = date2, by = "year"), Cal())
  })

}

shinyApp(ui, server)