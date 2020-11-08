# shiny-52-update-min.R

library(shiny)

ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c()),
  verbatimTextOutput("o1")
)


server <- function(input, output, session) {
  scenarios <- c(-100, -50, 0, 50, 100, 200)
}


server <- function(input, output, session) {
  scenarios <- c(-100, -50, 0, 50, 100, 200)
  updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)
}

shinyApp(ui, server)

