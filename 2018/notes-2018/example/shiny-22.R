library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 10),
  actionButton("go", "Go"),
  plotOutput("p1")
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    output$p1 <- renderPlot({
      # hist(rnorm(isolate(input$num)))
      # To make code in good clarity, I re-write above one line into below two lines
      # with additional variable input_num to hold the value from input$num.
      input_num <- isolate(input$num)
      hist(rnorm(input_num))
    }) 
  })
}

shinyApp(ui, server)