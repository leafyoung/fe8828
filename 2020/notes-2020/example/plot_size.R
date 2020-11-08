library(shiny)

ui <- fluidPage(
  plotOutput('p1', width='auto', height='auto'),
  plotOutput('p2', width='auto', height='auto'),
)

server <- function(input, output, session) {
  output$p1 <- renderPlot({ hist(rnorm(1000)) }, width = 600, height = 400)
  output$p2 <- renderPlot({ hist(rnorm(1000)) }, width = 600, height = 200)
}

shinyApp(ui, server)