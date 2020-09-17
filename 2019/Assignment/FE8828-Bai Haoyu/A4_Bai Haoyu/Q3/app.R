#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Three buttons:
# you can add in element by pressing Add
# you can input an existing element and remove it by pressing Remove
# you can input nothing and directly remove the last element by pressing RemoveLast

library(shiny)
ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  actionButton("remove", "Remove"),
  actionButton("remove2", "RemoveLast"),
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
    # put a new random value
    updateNumericInput(session, "shock", value = round(runif(1) * 1000))
  })
  
  observeEvent(input$remove, {

    shock <- isolate(input$shock)
    if (shock %in% scenarios) {
      scenarios <<- sort(scenarios[-which(scenarios %in% shock)])
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
    }
    # put a new random value
    updateNumericInput(session, "shock", value = round(runif(1) * 1000))
  })
  
  observeEvent(input$remove2, {

    shock <- isolate(input$shock)
    scenarios <<- sort(scenarios[-length(scenarios)])
    updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)
    # put a new random value
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