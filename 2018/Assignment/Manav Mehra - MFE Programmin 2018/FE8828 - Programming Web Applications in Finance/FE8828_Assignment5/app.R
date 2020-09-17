# shiny-36-update.R
library(shiny)
ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  selectInput("shock2", "Remove: ", choices = c(), selected = c()),
  actionButton("remove", "Remove"),
  checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c()),
  verbatimTextOutput("o1")
)
scenarios <- c(-100, -50, 0, 50, 100)
server <- function(input, output, session) {
  updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)
  updateSelectInput(session, "shock2",
                    choices = scenarios,
                    selected = scenarios)
  observeEvent(input$add, {
    shock <- isolate(input$shock)
    if (!(shock %in% scenarios)) {
      scenarios <<- sort(c(scenarios, shock))
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
      updateSelectInput(session, "shock2",
                        choices = scenarios,
                        selected = scenarios)
    }
    # put a new random value
    updateNumericInput(session, "shock", value = round(runif(1) * 1000))
  })
  observeEvent(input$remove, {
    shock2 <- isolate(input$shock2)
    if ((shock2 %in% scenarios)) {
      scenarios <<- scenarios[-which(scenarios==shock2)]
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
      updateSelectInput(session, "shock2",
                        choices = scenarios,
                        selected = scenarios)
    }
  })
  output$o1 <- renderPrint({
    x <- input$scenarios
    str(x)
    cat(paste0("length: ", length(x), "\n"))
    cat(paste0(x, "\n"))
  })
}
shinyApp(ui, server)