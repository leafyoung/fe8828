
library(shiny)
library(DT)

ui <- fluidPage(

    titlePanel("Bond Schedule"),

    sidebarLayout(
        sidebarPanel(
            dateInput("sdate", "Start Date:", value = "2019-01-01"),
            numericInput("tenor","Tenor (years)",0,min=0,step=1),
            numericInput("crate","Coupon Rate %",0,min=0,step=0.01),
            selectInput("cfreq","Coupon Frequency",c("Annually"="an","Semi-Annually"="semian",
                                                     "Monthly"="mo","Quarterly"="3mo")),
            numericInput("ytm","Yield to Maturity %",0,min=0,step=0.01),
            actionButton("go","Go")
        ),
        
        mainPanel(
           tableOutput("coupons"),
           plotOutput("NPV")
        )
    ),
    for (i in 1:input$tenor)
    {
        npv<-0
        CF<-input$crate*1000
        npv=npv+(CF/((1+ytm)**i))
    }
)


server <- function(input, output) {
observeEvent(input$go,{
    
        output$coupons <- DT::renderDataTable({
            DT::datatable(input$sdate, input$tenor, input$crate, input$ytm)
    })
        })
    
    output$NPV<-renderPlot({
        plot(input$tenor,input$npv)
    })
    
 
}

# Run the application 
shinyApp(ui = ui, server = server)
