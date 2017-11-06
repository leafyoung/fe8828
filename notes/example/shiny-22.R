library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 10),
  actionButton("go", "Go"),
  plotOutput("p1")
)

server <- function(input, output, session) {
  if (FALSE) {
    observeEvent(input$go, {
      output$p1 <- renderPlot({
        hist(rnorm(isolate(input$num)))
      }) 
    })
  }

  data <- eventReactive(input$go, {
    hist(rnorm(input$num))
  })
  
  output$p1 <- renderPlot({ data() }) 
}

shinyApp(ui, server)