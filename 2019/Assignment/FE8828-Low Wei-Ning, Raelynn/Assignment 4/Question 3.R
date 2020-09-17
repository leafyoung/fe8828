#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
ui <- fluidPage(
    numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
    actionButton("add", "Add"),
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
        # put a new random value
        updateNumericInput(session, "shock", value = round(runif(1) * 1000))
    })
    observeEvent(input$remove, {
        scenarios<- isolate(input$scenarios)
            scenarios <<- scenarios[-(length(scenarios))]
            updateCheckboxGroupInput(session, "scenarios",
                                    choices = scenarios[-(length(scenarios))],
                                    selected = scenarios)
        })
    output$o1 <- renderPrint({
        x <- input$scenarios
        str(x)
        cat(paste0("length: ", length(x), "\n"))
        cat(paste0(x, "\n"))
    })
}
shinyApp(ui, server)