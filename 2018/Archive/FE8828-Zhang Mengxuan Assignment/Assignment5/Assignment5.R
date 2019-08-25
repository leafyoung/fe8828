library(shiny)
#add a button, say remove, try to look it up in scenario list, and remove
ui <- fluidPage(
  numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
  actionButton("add", "Add"),
  actionButton("remove","Remove"),
  checkboxGroupInput("scenarios", "Scenarios", choices = c(), selected = c()),
  verbatimTextOutput("o1")
)
scenarios <- c(-100, -50, 0, 50, 100)
server <- function(input, output, session) {
  updateCheckboxGroupInput(session, "scenarios",
                           choices = scenarios,
                           selected = scenarios)
  #add
  observeEvent(input$add, {
    shock <- isolate(input$shock)
    if (!(shock %in% scenarios)) {
      #try to find the value and change it, 
      scenarios <<- sort(c(scenarios, shock))
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
    }
    # put a new random value
    updateNumericInput(session, "shock", value = round(runif(1) * 1000))
  })
  
  #remove
  observeEvent(input$remove, {
    shock <- isolate(input$shock)
    if ((shock %in% scenarios)) {
      #try to find the value and remove it, 
      #x2 <- x[!x %in% 3:10]
      #str(shock)
      scenarios <<- sort(scenarios[!scenarios %in% shock])
      #scenarios <<- sort(c(!shock %in% scenarios))
      updateCheckboxGroupInput(session, "scenarios",
                               choices = scenarios,
                               selected = scenarios)
    }
    else{
      showNotification(paste0(shock," not in the list"),duration=5,type="error")
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