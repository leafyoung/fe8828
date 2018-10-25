#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application 
ui <- fluidPage(
  
  
  selectInput("colors","colors",choices = colors()),
  plotOutput("p1")
)



server = function(input, output, session) {
  output$p1 = renderPlot({
    plot(1:10, pch=19, cex=1, col=input$colors)
  })
}



# Run the application 
shinyApp(ui = ui, server = server)

