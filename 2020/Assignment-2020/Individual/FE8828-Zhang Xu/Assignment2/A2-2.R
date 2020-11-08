library(conflicted)
library(shiny)
library(DT)
library(bizdays)
library(tidyverse)
conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

ui <- fluidPage(
    textInput("start_day","start day","2020-09-30"),
    numericInput("tenor","tenor",3),
    numericInput("ytm","yield to maturity",0.05),
    numericInput("coupon_rate","coupon rate",0.1),
    textInput("coupon_fre","coupon frequency","quarter"),
    actionButton("go","Go"),
    
    dataTableOutput("df"),
    h3("Bond price"),
    textOutput("text")
)



server <- function(input, output, session) {
    # Refer to shiny-23.R for the idea.
    # here we have a reactivity map of N inputs -> 1 data frame -> 2 outputs
    
    bond_cf <- eventReactive(input$go, {
        start_day <- isolate(as.Date(input$start_day))
        
        
        tenor<- isolate(input$tenor)
        tol_days<-tenor*360 
        ytm <- isolate(input$ytm)
        coupon_rate<-isolate(input$coupon_rate)
        coupon_fre<-isolate(input$coupon_fre)
        if (coupon_fre=="quarter"){
            fre_days=90
        }
        if (coupon_fre=="half year"){
            fre_days=180
        }
        if (coupon_fre=="year"){
            fre_days=360
        }
        print(tol_days)
        
        print(fre_days)
        
        print(tol_days/fre_days)
        cf<-rep(100*coupon_rate,tol_days/fre_days)#seems something wrong here
        cf[length(cf)]<-cf[length(cf)]+100
        
        
        Dates<-list()
        Dates[1]<-start_day
        for (k in 2:(tol_days/fre_days)) {
            Dates[k]<-add.bizdays(as.Date.numeric(sapply(Dates[k-1], function(v) return(v[1])),origin="1970-01-01"),fre_days,cal="weekends")
        }
        
        
        Dates<-as.Date(as.Date.numeric(sapply(Dates, function(v) return(v)),origin="1970-01-01"),"%m/%d/%y")
        
        bond_cf <- tibble(date = c(Dates), cf = c(cf) )
        bond_cf["ts"]<- 1:(tol_days/fre_days)/360*(tol_days/fre_days)
        bond_cf
    })
    
    # what goes inside renderXXX function is a segment of code with {}
    output$df <- renderDataTable({
        # use the reactive event like a function.
        bond_cf()
    })
    
    output$text <- renderText({
        # Note that I also used bond_cf() here
        bond_value <- sum(exp(- isolate(input$ytm) * bond_cf()$ts) * bond_cf()$cf)
        paste0("Bond value: ", bond_value)
    })
    
}

shinyApp(ui, server)
