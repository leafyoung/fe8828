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
  
  data2 <- reactiveVal(NA)

  # input$go <-> data() --> output$p1 -> data2() --> output$p2
  #                                              \-> output$p3
  
    # Variable data becomes a reactive variable.
  # What changes to it will trigger the output.
  output$p1 <- renderPlot({
    hist(data());
    data2(rnorm(1000))
  })
  
  output$p2 <- renderPlot({
    if (! is.na(data2())) {
      hist(-data2())
    }
  })
}

shinyApp(ui, server)