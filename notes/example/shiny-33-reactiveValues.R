library(shiny)
library(knitr)
library(kableExtra)

ui <- fluidPage(
  textInput("text", "Tell me something", "Long long time ago", width = "100%"),
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
    tell_me <- input$text
    
    output$d1 <- renderPrint({
      tryCatch({
        cat(paste0(tell_me, "\n"))    
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

    values$data <- isolate(paste0(values$data, tell_me, "\n"))
  })
}

shinyApp(ui, server)