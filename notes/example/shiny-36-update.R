library(shiny)

ui <- fluidPage(
  uiOutput("p1"),
  verbatimTextOutput("o1")
)

scenarios <- c(-100, -50, 0, 50, 100)

server <- function(input, output, session) {
  output$p1 <- renderUI({
    tagList(
      numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
      actionButton("add", "Add"),
      checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c())
    )
  })
  
  updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)  

  observeEvent(input$add, {
    shock <- isolate(input$shock)
    if (!(shock %in% scenarios)) {
      scenarios <<- sort(c(scenarios, shock))
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
    }
    updateNumericInput(session, "shock", value = round(runif(1) * 1000))
  })
  
  output$o1 <- renderPrint({
    x <- input$scenarios
    str(x)
    cat(paste0("length: ", length(x), "\n"))
    cat(paste0(x, "\n"))
  })
}

shinyApp(ui, server)

