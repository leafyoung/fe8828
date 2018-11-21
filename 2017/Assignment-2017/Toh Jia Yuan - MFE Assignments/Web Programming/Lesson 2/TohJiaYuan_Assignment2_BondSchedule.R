library(shiny)
library(lubridate)
library(DT)
library(bizdays)
library(ggplot2)
ui <- fluidPage(

  headerPanel(
    column(8,offset=4, tags$h1(tags$strong(("Bond CashFlow Schedule"))))),
  
  br(),
  br(),

  fluidRow(
    column(4,
           dateInput("StartDate", "Start date (YYYYMMDD) ", value = Sys.Date()),
           numericInput("Tenor", "Tenor (years)", 5, min=0, max=100, step=0.5),
           numericInput("Coupon", "Coupon rate (%)", 10, min=0, max=100, step=0.1),
           numericInput("YTM", "Yield to maturity (%)", 10, min=0, max=100, step=0.1),
           selectInput("Frequency","Coupon frequency",c("year","6 months","quarter")),
           numericInput("FaceValue", "Face value", 1000, min=0),
           actionButton("go", "Calculate")
           ),
    column(6,
           p("Note: If coupon payment date happens to be on a weekend, actual payment will be shifted to following Monday."),
           dataTableOutput('table')
           )
    ),
  
  br(),
  
  tags$h3(tags$strong(p("Bond Price"))),
  tags$h1(textOutput("text")),
  
  br(),
  mainPanel(
     fluidRow(
       column(12,offset=3, plotOutput("p1"))
                  )
  )
)

server <- function(input, output, session) {
  state <- reactiveValues()
  observeEvent(input$go,{ #if use observe, dont need input$go
    state$x <- input$Frequency
    state$y <- ifelse(state$x=="year",1,ifelse(state$x=="6 months",0.5,0.25))
    state$z <- ifelse(state$x=="year",1,ifelse(state$x=="6 months",2,4))
    state$tenor <- input$Tenor*state$z
    state$date <- as.character(seq((input$StartDate), by = input$Frequency, length.out = state$tenor +1))
    state$coupon <- input$Coupon*input$FaceValue*state$y/100
    isolate(state$CF <- rep(state$coupon,input$Tenor*state$z+1))
    isolate(state$CF[1] <- 0)
    isolate(state$CF[length(state$CF)] <- state$CF[length(state$CF)]+input$FaceValue)
    state$r <- input$YTM*state$y/100
    isolate(state$a <- 1/((1+state$r)^(length(state$CF)-1)))
    isolate(state$price <- state$coupon*(1-state$a)/state$r + (input$FaceValue)*state$a)
    state$weekday <- as.character(weekdays(seq(input$StartDate, by = input$Frequency, length.out = state$tenor +1)))
  })
  
  data <- eventReactive(input$go,
                        cbind(Date=c(state$date),
                              Cashflows=(state$CF),
                              DayOfWeek=state$weekday)
                        )
                        
  output$table <- renderDataTable(data())
  output$text <- renderText(state$price)
  output$p1 <- renderPlot({
    df <- data.frame(
      Cashflows = state$CF,
      #Date = format(as.Date(state$date),"%b%Y")
      Date=state$date
    )
    p <- ggplot(df, aes(x=Date, y=Cashflows))
    p <- p+geom_bar(stat = "identity")
    print(p)
    })
  
}

shinyApp(ui, server)