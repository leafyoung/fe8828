library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 100),
  actionButton("go", "Go"),
  plotOutput("p1"),
  plotOutput("p2"),
)

server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    rnorm(isolate(input$num))
  })
  
  # input$go <-> data() --> output$p1
  #                     \-> output$p2
  
  # Variable data becomes a reactive variable.
  # What changes to it will trigger the output.
  output$p1 <- renderPlot({ hist(data()) })
  
  output$p2 <- renderPlot({ hist(-data()) })
}

shinyApp(ui, server)