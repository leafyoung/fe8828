# shiny-36-update.R

library(shiny)

ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c()),
  
  verbatimTextOutput("o1")
)

scenarios <- c(-100, -50, 0, 50, 100, 200)

server <- function(input, output, session) {
  updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)  

  assign()
}

shinyApp(ui, server)

