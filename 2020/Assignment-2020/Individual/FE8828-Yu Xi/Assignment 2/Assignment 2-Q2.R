library(conflicted)
library(shiny)
library(DT)
library(FinCal)
conflict_prefer('npv', 'FinCal')

ui <- fluidPage(
    h4("By default this is a bond maturing at 2030 with a face value of $100."),
    dateInput(inputId = "date1",
              label = "Start Date"),
    
    selectInput(inputId = "frequency",
                label = "Coupon Frequency:",
                choices = c(
                    "Quarter" = "quarter",
                    "Semi Annual" = "183 days",
                    "Annual" = "year")),
    
    numericInput(inputId = "yield",
                 label = "Yield to Maturity",
                 value = 0.1),
    
    actionButton(inputId = "go", 
                 label = "Go"),
    
    h4("Coupon Schedule"),
    DTOutput(outputId = "CouponSchedule"),
    plotOutput(outputId = "plotCF"),
)
server <- function(input, output, session) {
    observeEvent(input$go,{
        r1 = isolate(input$yield)
        date1 = as.Date(isolate(input$date1))
        date2 = as.Date('2030-12-31')
        NPV = 0
        Time_seq = seq(from = isolate(input$date1), to = date2, by = input$frequency)
        N = length(Time_seq) - 1
        for (i in 1:N) NPV = c(NPV, npv(r1, seq(100,100,length.out = i)))
        output$CouponSchedule = renderDT(data.frame(NPV))
        output$plotCF = renderPlot({
            plot(Time_seq, NPV)
        })
    })
}  
shinyApp(ui, server)