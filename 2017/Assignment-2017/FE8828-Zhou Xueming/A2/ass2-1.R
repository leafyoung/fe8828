library(shiny)
ui <- fluidPage(
  selectInput("color", "color",
              c("Red","Orange","Yellow","Green","Blue","Purple")),
  textOutput("color"),
  plotOutput("colors")
  
)

server <- function(input, output) {
 output$color <-  renderText({paste("Color plot", input$color)})
  output$colors<- renderPlot({plot(1:10, pch = 19, cex = 1, col = input$color)
 })
  
  
}

shinyApp(ui, server)