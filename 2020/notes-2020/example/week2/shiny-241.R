library(shiny)

ui <- fluidPage(
  numericInput("num1", "Num", 100),
  numericInput("num2", "Num", 100),
  h4("Sum"),
  textOutput("t1")
)

server <- function(input, output, session) {
  sum_v <- reactiveVal(0)
  
  # Instead of anonymous function, we use a named function
  calc_sum <- function() {
      sum_new <- isolate(input$num1) + isolate(input$num2)
      sum_v(sum_new)
  }
  
  # input$num1 --> sum_v -> output$t1
  # input$num2 -/
  
  observeEvent(input$num1, calc_sum())
  observeEvent(input$num2, {
    sum_new <- isolate(input$num1) + isolate(input$num2)
    sum_v(sum_new)
  })
  
  output$t1 <- renderText({ 
    sum_v()
  })
}

shinyApp(ui, server)