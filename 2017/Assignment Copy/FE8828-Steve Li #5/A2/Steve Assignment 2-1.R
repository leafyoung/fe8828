library(shiny)

ui <- fluidPage(
    selectInput("colors","Please choose a color here",choices = colors()),
    plotOutput("picture")
  )


  server = function(input, output) {
    output$picture <- renderPlot(
      plot(1:10, pcg=19, cex=1, col= input$colors)
    )
  }

shinyApp(ui, server)