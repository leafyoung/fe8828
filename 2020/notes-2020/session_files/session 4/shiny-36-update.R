# shiny-36-update.R

library(shiny)

ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c()),

  verbatimTextOutput("o1")
)

server <- function(input, output, session) {
  updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)  

  scenarios <- c(-100, -50, 0, 50, 100)
  this_env <- environment()
  observeEvent(input$add, {  
    shock <- isolate(input$shock)
    if (!(shock %in% scenarios)) 
    {
      assign('scenarios',sort(c(scenarios, shock)),envir=this_env)
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
    }
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
