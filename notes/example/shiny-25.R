library(shiny)
library(knitr)
library(kableExtra)

ui <- fluidPage(
  numericInput("num", "Num", 5),
  tableOutput("p1"),
  hr(),
  tableOutput("p2")
)

server <- function(input, output, session) {
  observe({
    row_num <- input$num

    output$p1 <- function() {
      kable(iris[1:row_num, , drop = T], format = "html")
    }
    
    output$p2 <- function() {
      kable(iris[1:row_num, , drop = T], format = "html")
    }
  })
}

shinyApp(ui, server)