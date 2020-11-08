library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 10),
  actionButton("go", "Go"),
  plotOutput("p1")
)

# input$go -> output$p1
# (input$num)


server <- function(input, output, session) {
  observeEvent(input$go, {
    output$p1 <- renderPlot({
      # Concise code
      # hist(rnorm(isolate(input$num)))      
      
      # Detailed code
      # To make code in good clarity, I re-write above one line as below.
      # Additional variable input_num to hold the value from input$num.
      input_num <- isolate(input$num)
      hist(rnorm(input_num))
    }) 
  })
}

shinyApp(ui, server)