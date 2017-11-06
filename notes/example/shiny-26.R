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
  values <- reactiveValues(data = "")
  output$d3 <- renderText({ values$data })
  
  observe({
    row_num <- input$num

    output$p1 <- renderUI({
      tagList(
        tags$h1("This is a header"),
        {
          hx <- paste0("h", row_num)
          (tags[[hx]])("H1")
        },
        kable(iris[1:row_num, , drop = T], format = "html")
      )
    })
    
    # Use anything together with kable, use function() { paste0(...) }
    output$p2 <- function() {
      paste0(
        tags$h1("This is a header"),
        kable(iris[1:row_num, , drop = T], format = "html"))
    }
  })
}

shinyApp(ui, server)