require(shiny)

shinyApp(
  ui = fluidPage(
    selectInput("colors","colors",choices = colors()),
    plotOutput("p1")
  ),
  server = function(input, output) {
    output$p1 <- renderPlot(
      plot(1:10, pcg=19, cex=1, col= input$colors)
    )
  }
)
