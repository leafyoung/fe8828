library(shiny)

ui <- fluidPage(
  titlePanel("Hello World with a Histogram"),
  # Input() functions
  numericInput("num", "Number of Sample", value = 30),
  # Output() functions
  plotOutput("hist")
)

server <- function(input, output, session) {
  # Enable either one of two
  output$hist <- renderPlot({ hist(rnorm(100)) })
  
  output$hist <- renderPlot({
    title("a normal random number histogram")
    hist(rnorm(input$num))
  })
}
shinyApp(ui = ui, server = server)