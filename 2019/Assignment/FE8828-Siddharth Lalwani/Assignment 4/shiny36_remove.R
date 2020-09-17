# shiny-36-update.R
# There was an confusion regarding the functionality of remove button. 
# I have implemented the removing of last element from scenarios array 
# when remove button is clicked.
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
        
        shock <- isolate(input$shock)
        scenarios<<- scenarios[-length(scenarios)]
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
