


library(shiny)   #Problem 1, Submitted by Wu Kaibin, Matric. No. : G1700356B
ui <- fluidPage(
  h1("Display Color"),
  selectInput("colorChoice","Please choose a color:", 
              c("Brown" = "brown",
                "Red"="red",
                "Purple"="purple",
                "Blue"="blue",
                "Skyblue" ="skyblue1",
                "Green"="green")),
  textOutput("colorText"),
  plotOutput("colorPlot")

)

server <- function(input, output, session) {
      output$colorText <-  renderText({
      paste("The current color is:", input$colorChoice, ".")
    })
      output$colorPlot<- renderPlot({
        plot(1:10, pch = 19, cex = 1, col = input$colorChoice)
      })
}
shinyApp(ui, server)


