library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(lubridate)

ui <- fluidPage(
    fluidPage(sidebarLayout(
        sidebarPanel(h3("Bond Calculator")),
        mainPanel("")
    )),
    fluidPage(sidebarLayout(
        sidebarPanel("Suppose par value is $100"),
        mainPanel("")
    )),
    dateInput("sd", "Start Date", Sys.Date()),
    numericInput("t", "Tenor(in year)", 0.5),
    numericInput("r", "Coupon Rate", 0.05),
    numericInput("freq", "Coupon Frequency", 10),
    numericInput("ytm", "Yield To Maturity",0.05),
    verbatimTextOutput("t1"),
    plotOutput("p1"),
    dataTableOutput("dt1")
)

server <- function(input, output, session) {
        
        pd <- reactiveVal(0)
        cal_pd <- function(){
            cnt <- seq(1,input$freq)
            temp <- rep(input$sd,input$freq)
            month(temp) <- month(temp)+cnt*12*input$t
            pd(temp)
        }
        observeEvent(input$t,cal_pd())
        observeEvent(input$freq,cal_pd())
        observeEvent(input$sd,cal_pd())

        payment <- reactiveVal(0)   #construct payments
        cal_py <- function(){
            coupon <- 100*(input$r)*(input$t)
            temp <- c(rep(coupon,input$freq-1),coupon+100)
            payment(temp)
        }
        observeEvent(input$freq,cal_py())
        observeEvent(input$r,cal_py())
        observeEvent(input$t,cal_py())
        
        npv <- reactiveVal(0)            
        calc_npv <- function(){
            sum <- 0
            cnt <- seq(1,input$freq)
            sum <- sum(payment()/(1+input$ytm*input$t)^(cnt))
            npv(sum)
        }
        observeEvent(input$t,calc_npv())
        observeEvent(input$ytm,calc_npv())
        observeEvent(input$freq,calc_npv())

        df <- reactiveVal(0)
        observeEvent(pd(), df(tibble(Date = pd(), Payment = payment())))
        observeEvent(payment(), df(tibble(Date = pd(), Payment = payment())))

        
        output$p1 <- renderPlot({
            plot(x = df()$Date,y = df()$Payment,type = "S",
                 xlab="Payment Schedule", ylab="Payment")
        })
        output$dt1 <- renderDataTable(df(), options = list(pageLength = 10))
        output$t1 <- renderPrint({
            cat("Result\n","NPV value/Bond Price:",npv())
        })    
}

shinyApp(ui, server)