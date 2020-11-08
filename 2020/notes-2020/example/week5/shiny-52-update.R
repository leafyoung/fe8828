# shiny-52-update-fixed.R

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
    scen_sel <- isolate(input$scenarios)
    
    if (!(shock %in% scenarios)) {
      # <<- will try to assign a value outside current environment
      # See help of <<-
      # scenarios <<- sort(c(scenarios, shock))
      # I would prefer to use assign to be specific for which environment
      assign("scenarios", sort(c(scenarios, shock)), envir = this_env)

      if (TRUE) {
        # Implementation 1
        updateCheckboxGroupInput(session, "scenarios",
                            choices = scenarios,
                            selected = scenarios)
      } else {
        # Implementation 2
        # Below code is a better implementation than above 
        updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = c(scen_sel, shock))
      }
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
