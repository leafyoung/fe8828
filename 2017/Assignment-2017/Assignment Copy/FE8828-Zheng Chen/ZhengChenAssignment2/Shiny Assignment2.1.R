library(lubridate)
library(bizdays)
library(shiny)
ui <- fluidPage(
tabPanel(
    "Colors Slection",
    selectInput("color","select a color:", 
                c("Skyblue" ="skyblue1",
                  "Red"="red",
                  "Gray"="gray",
                  "Pink"="pink",
                  "Black"="black",
                  "Orange" = "orange")),
    plotOutput("colorPlot", width = "900px", height = "600px")
  ))

server <- function(input, output, session) {
    output$colorPlot<- renderPlot({
    plot(1:10, pch = 19, cex = 1, col = input$color)
  })}


shinyApp(ui = ui, server = server)