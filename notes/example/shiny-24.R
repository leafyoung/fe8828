library(shiny)

ui <- fluidPage(
  numericInput("num", "Num", 10),
  tableOutput("p1"),
  hr(),
  dataTableOutput("p2")
)

server <- function(input, output, session) {
  output$p1 <- renderTable(iris[1:10,], striped = T, hover = T)
  output$p2 <- renderDataTable(iris, options = list(
    pageLength = 5
  ))  
  
}

shinyApp(ui, server)