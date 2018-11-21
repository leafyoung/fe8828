#shiny selectInput
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
ui <- fluidPage(
  titlePanel(strong("Color setting")),
  hr(),
  selectInput("color","Please choose a color:", 
              c("RED"="red",
                "BLUE"="blue",
                "Yellow"="yellow",
                "SKYBLUE" = "skyblue1")),
  hr(),
  textOutput("color1"),
  plotOutput("colors")

)

server <- function(input, output) {
      output$color1 <-  renderText({
      paste("Plotting with", input$color," :")
    })
      output$colors<- renderPlot({
        plot(1:10, pch = 19, cex = 1, col = input$color)
      })
      
    
}

shinyApp(ui, server)


