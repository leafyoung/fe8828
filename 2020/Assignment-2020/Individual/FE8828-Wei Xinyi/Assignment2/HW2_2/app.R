#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


ui <- fluidPage(
  titlePanel("Bond Schedule"),
  sidebarPanel(
    numericInput("maturity_value", "maturity_value", 1000),
    numericInput("start_date", "start_date", 1),
    numericInput("tenor", "tenor", 4),
    numericInput("coupon_rate", "coupon_rate", 0.1),
    numericInput("coupon_frequency", "coupon_frequency", 2),
    numericInput("yield_to_maturity", "yield_to_maturity", 0.15)
  ),
  mainPanel(
    plotOutput("p1")
  )
)

server <- function(input, output, session) {
 
  output$p1 <- renderPlot({ 
     library(ggplot2)
  
  D <- seq(input$start_date+1/input$coupon_frequency, input$start_date+input$tenor, 1/input$coupon_frequency)
  
  C = rep(NA, input$tenor*input$coupon_frequency)
  for(i in 1:(input$tenor*input$coupon_frequency)){
    C[i] = (input$maturity_value*input$coupon_rate/input$coupon_frequency)/((1+input$yield_to_maturity/input$coupon_frequency)^(i))
  }
  C[input$tenor*input$coupon_frequency] = (input$maturity_value*(1+input$coupon_rate/input$coupon_frequency))/((1+input$yield_to_maturity/input$coupon_frequency)^(input$tenor*input$coupon_frequency))
  CF<-data.frame(D, C)

    ggplot(data = CF) + 
      
      geom_bar(mapping = aes(x = D, y = C), stat = "identity")
  })
}

shinyApp(ui, server)