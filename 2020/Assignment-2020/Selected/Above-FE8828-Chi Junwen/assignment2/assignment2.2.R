library(shiny)
library(DT)
library(lubridate)


ui <- fluidPage(

    titlePanel("Bond Schedule"),
    numericInput("par","par value",100),
    dateInput("start","start date",as.Date("2010-1-1")),
    numericInput("tenor","tenor",10),
    numericInput("rate","coupone rate",0.037),
    selectInput("freq","coupon frequency",choices=c("Annually","Semiannually","Quarterly")),
    numericInput("YTM","yield to maturity",0.025),
    actionButton("go","Go!"),
    h1("Coupon schedule"),
    dataTableOutput("schedule"),
    h1("Cash Flow Scatter Plot"),
    plotOutput("CF"),
    div(textOutput("npv"),style = "font-size:30px;",align="center")
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    df<-eventReactive(input$go,{
        
        if(input$freq=="Annually"){freq=1
        }else if(input$freq=="Semiannually"){freq=2
        }else{freq=4}
        
        len_date<-input$tenor*freq
        init_date<-input$start
        seq_date<-c(init_date)
        for (i in 1:(len_date-1)){
            month(init_date)<-month(init_date)+6
            seq_date<-c(seq_date,init_date)
            
        }
        cf<-input$par*input$rate/freq
        seq_cf<-c(rep(cf,len_date-1),input$par+cf)
        seq_discoutcf<-c()
        for(i in 1:len_date){
            seq_discoutcf<-c(seq_discoutcf,seq_cf[i]*(1+input$YTM/freq)^(-i))
        }
        data.frame(Date=seq_date,Cashflow=seq_cf,DiscountedCashflow=
                       seq_discoutcf)
        
    })
    output$CF<-renderPlot({
        plot(df()$Date,df()$Cashflow,ylim=c(0,max(sum(df()$DiscountedCashflow),df()$Cashflow[length(df()$Cashflow)])),type="p",xlab="Date",pch=1,col="red",ylab="Amount")
        points(df()$Date,df()$DiscountedCashflow,pch=5,col="blue")
        points(df()$Date[1],sum(df()$DiscountedCashflow),pch=15,col="green")
        legend("top",c("Cashflow","DiscountedCashflow","NPV"),text.col=c("red","blue","green"),inset=.05)
        
    })
    
    
    output$schedule<-renderDataTable(df())
    
    output$npv<-renderText(paste0("The net present value of the bond is:", sum(df()$DiscountedCashflow)))

}

# Run the application 
shinyApp(ui = ui, server = server)
