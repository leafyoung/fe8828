library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 10),
  plotOutput("p1")
)

server <- function(input, output, session) {
  output$p1 <- renderPlot({
    hist(rnorm(input$num))
  })
}

shinyApp(ui, server)