library(shiny)
library(lubridate)
library(DT)
library(bizdays)
library(ggplot2)

ui <- fluidPage(
  
  h1(align = "Left", strong("Bond Price Calculator")),
  sidebarLayout(position="right",
  sidebarPanel(
  h4(align ="center", strong("Bond Detail")),
  helpText("Please input the bond data in the blow table."),
  helpText(a("For company infomration, please click here", href ="https://finance.google.com/finance?q=google&ei=s2YRWunrMtTaugT4sJb4Bw")), 
  textInput("Name","Ticker Name",value = "Alphabet Inc."),
  dateInput("Start_Date", "Start Date (YYYY/MM/DD) ", value = Sys.Date()),
  sliderInput("Tenor", "Tenor (years)", value = 20, min=0, max=100),
  numericInput("Coupon", "Coupon Rate (%)", value = 8, min=0, max=100, step=0.01),
  numericInput("YTM", "Yield To Maturity (%)", value = 8, min=0, max=100, step=0.01),
  radioButtons("Frequency","Coupon Frequency",c("year","6 months","quarter")),
  numericInput("FaceValue", "Face Value", 1000, min=0),
  actionButton("CAL", "Calculate")
  ),
 
  mainPanel(
    h3(align = "left",tags$b(textOutput("Title"))),
    
    # plot the cash flow chart
    #h3(align = "left", plotOutput('distPlot')),
    
  h4(align = "central", tags$strong(p("Bond Price(NPV)")),
  textOutput("text")),
 
  
  fluidRow(
    column(10,
           tableOutput('table')
    )
  )
)))

server <- function(input, output) {
  
  bond <- reactiveValues() #calculate the bond NPV, cash flow, period
  observeEvent(input$CAL,{ 
    bond$A1 <- input$Frequency
    bond$A2 <- ifelse(bond$A1=="year",1,ifelse(bond$A1=="6 months",0.5,0.25))
    bond$A3 <- ifelse(bond$A1=="year",1,ifelse(bond$A1=="6 months",2,4))
    isolate(bond$CF <- rep(bond$coupon,input$Tenor*bond$A3+1))
    bond$tenor <- input$Tenor*bond$A3
    bond$date <- as.character(seq((input$Start_Date), by = input$Frequency, length.out = bond$tenor +1))
    bond$coupon <- input$Coupon*input$FaceValue*bond$A2/100
    bond$r <- input$YTM*bond$A2/100
    
    isolate(bond$CF <- rep(bond$coupon,input$Tenor*bond$A3+1))
    isolate(bond$CF[1] <- 0)
    isolate(bond$CF[length(bond$CF)] <- bond$CF[length(bond$CF)]+input$FaceValue)
    isolate(bond$A1 <- 1/((1+bond$r)^(length(bond$CF)-1)))
    isolate(bond$price <- bond$coupon*(1-bond$A1)/bond$r + (input$FaceValue)*bond$A1)
    
  })
  
  output$table <- renderTable(data())
  output$text <- renderText(bond$price)
  data <- eventReactive(input$CAL,
                        cbind(Date=c(bond$date),
                              Cashflows=(bond$CF),
                              DayOfWeek=bond$weekday)
  
                        )
  
  #output$distPlot <-renderPlot({
    
    #x<-length(bond$tenor)
    #bins<-seq(1,max(x), length.out=bond$tenor+3)
    
    #hist(x, breaks=bin, col = "#75AADB", border = "white",
         #xlab="cash flow chart",
         #main="Ticker name"
         #)
    
    #p<-ggplot(renderTable(data), TRUE, aes(Date))
    #p+geom_bar(stat = "identity")
    #})
  
    
  #})

  
}
shinyApp(ui, server)