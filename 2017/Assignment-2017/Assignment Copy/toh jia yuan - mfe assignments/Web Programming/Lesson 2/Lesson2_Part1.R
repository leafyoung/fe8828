library(shiny)
library(DT)
ui <- fluidPage(
  
  selectInput("colors","colors",choices = colors()),
  plotOutput("p1")
)


server <- function(input, output, session) {
  output$p1 <- renderPlot({
    plot(1:10, pch=19, cex=3, col=input$colors)
  })
}
shinyApp(ui, server)