library(shiny)
library(knitr)
library(kableExtra)

ui <- fluidPage(
  numericInput("num", "Num", 5),
  verbatimTextOutput("d1"),
  hr(),
  textOutput("d2"),
  hr(),
  verbatimTextOutput("d3")
)



server <- function(input, output, session) {
  values <- reactiveValues(data = "")
  output$d3 <- renderText({ values$data })

  observe({
    output$d1 <- renderPrint({
      tryCatch({
        cat("foo", "\n")
        runif(1)
        cat(1 / 0, "\n")
        cat(sqrt(-1), "\n")
        runif(-1)
      }, error = function(e) {
        cat(as.character.condition(e))
        cat("\n")        
      })
    })
    
    output$d2 <- renderText({ print("foo"); "bar1 bar2" })

    isolate(values$data <- paste0(values$data, "one ", "\n"))
  })
}

shinyApp(ui, server)