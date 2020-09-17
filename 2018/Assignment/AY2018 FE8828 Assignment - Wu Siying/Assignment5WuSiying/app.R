library(shiny)

ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  #Remove Button
  actionButton("remove", "Remove"),
  checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c()),
  verbatimTextOutput("o1")
)

scenarios <- c(-100, -50, 0, 50, 100)

server <- function(input, output, session) {
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
  
  #Remove
  observeEvent(input$remove, {
    shock <- isolate(input$shock)
    if (shock %in% scenarios) {
      scenarios <<- scenarios[scenarios!=shock]
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

