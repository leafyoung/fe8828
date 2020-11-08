library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 100),
  # For rnorm()
  # numericInput("mean", "Mean", 5),
  # numericInput("sd", "SD", 3),
  # For rpois()
  numericInput("lambda", "Lambda", 1),
  plotOutput("p1")
)

# input$num    --> output$p1
# input$lambda -/

server <- function(input, output, session) {
  output$p1 <- renderPlot({
    # hist(rnorm(input$num, mean = input$mean, sd = input$sd))
    hist(rpois(n = input$num, lambda = input$lambda))
  })
}

shinyApp(ui, server)