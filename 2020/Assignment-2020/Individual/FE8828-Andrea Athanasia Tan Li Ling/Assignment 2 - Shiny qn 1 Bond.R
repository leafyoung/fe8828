library(shiny)
library(tidyverse)
library(lubridate)

ui <- fluidPage(
    titlePanel("Bond Schedule"),
    
    sidebarLayout(
        sidebarPanel(
            dateInput("start","Start date"),
            sliderInput("tenor","Tenor",0,100,5),
            numericInput("couponrate","Coupon rate",0.05,0,100,0.01),
            selectInput("freq","Coupon frequency",c("Quarterly","Semi-Annually","Annually")),
            numericInput("ytm","Yield to maturity",0.05,0,100,0.01),
            actionButton("go","Go!")
        ),
        
        mainPanel(
            textOutput("price"),
            textOutput("NPV"),
            dataTableOutput("dt"),
            plotOutput("couponplot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    observeEvent(input$go,{
        if(isolate(input$freq)=="Quarterly"){
            freq <- 4
        } else if (isolate(input$freq)=="Semi-Annually"){
            freq <- 2
        } else {
            freq <- 1
        }
        
        n <- isolate(input$tenor)*freq
        cf <- isolate(input$couponrate)*100/freq
        start <- as.Date(isolate(input$start))
        int <- isolate(input$ytm)/freq
        
        bond_cf <- tibble(Period = 1:n)
        bond_cf <- mutate(bond_cf, Date = start %m+% months(Period*12/freq))
        bond_cf <- mutate(bond_cf, CF = ifelse(Period==n,cf+100,cf))
        bond_cf <- mutate(bond_cf, DCF = CF/(1+int)^Period)
        bond_cf <- mutate(bond_cf, Bond_Value = cumsum(DCF))

        #omit period column in table output
        schedule <- bond_cf[, c("Date","CF","DCF","Bond_Value")]
        output$dt <- renderDataTable(schedule)
        
        terminal <- 120 + cf
        output$couponplot <- renderPlot({
            #ylim has buffer of 20 to ensure upper label > terminal payout
            barplot(height=bond_cf$CF, names=bond_cf$Date,main="Coupon schedule",ylab="Payout",xlab="Date",ylim=c(0,terminal))
        })
        
        NPV <- bond_cf[n,5]
        working <- 1/((1+int)^n)
        bondprice <- cf*((1-working)/int)+100*working
        output$price <- renderText({paste("Price of this bond is: $",bondprice)})
        output$NPV <- renderText({paste("Net present value of this bond is: $",NPV)})
    })
}

shinyApp(ui = ui, server = server)
