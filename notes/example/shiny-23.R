library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 10),
  tableOutput("p2"),
  plotOutput("p1")
)

server <- function(input, output, session) {
  output$p1 <- renderPlot({
    # hist(rnorm(isolate(input$num)))
    hist(rnorm(input$num))
  }) 
}

shinyApp(ui, server)