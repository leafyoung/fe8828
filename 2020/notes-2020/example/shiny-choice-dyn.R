# shiny-34-renderUI.R

library(shiny)

# f1.R
# aFunc <- function(aString) {}

# f2.R
# aFunc <- function(aNumeric) {}

ui <- fluidPage(
  selectInput("prog", "Program", choices = c("f1.R", "f2.R"), selected = "f1.R"),
  actionButton("go")
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    source(isolate(input$prog))
    
    output$textOutput <- renderVerbatimText({
      aFunc("")
    })
  })
}

shinyApp(ui, server)

