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
    actionButton("remove","Remove"),
    checkboxGroupInput("chkb_scenarios", "Scenarios", choices = c(), selected = c()),
    verbatimTextOutput("o1")
    
)


#initialize scenario
scenarios <- c(-100, -50, 0, 50, 100)

server <- function(input, output, session) {
     updateCheckboxGroupInput(session, "chkb_scenarios",
                              choices = scenarios,
                              selected = scenarios)
    
    observeEvent(input$add, {
        shock <- isolate(input$shock)
        if (!(shock %in% input$chkb_scenarios)) {
            addedChoices <<- sort(c(input$chkb_scenarios, shock))
            updateCheckboxGroupInput(session, "chkb_scenarios",
                                     choices = addedChoices,
                                     selected = addedChoices)
        }
        # put a new random value
        updateNumericInput(session, "shock", value = round(runif(1) * 1000))
    })
    
    #additional code to remove
    observeEvent(input$remove, {
        shock <- isolate(input$shock)
        
        if (shock %in% input$chkb_scenarios) {
            
            removedChoices <- input$chkb_scenarios[input$chkb_scenarios!=shock]
            updateCheckboxGroupInput(session, "chkb_scenarios",
                                     choices = removedChoices,
                                     selected = removedChoices)
        }  
         
        
    })
    
    output$o1 <- renderPrint({
        
        x <- input$chkb_scenarios
        str(x)
        cat(paste0("length: ", length(x), "\n"))
        cat(paste0(x, "\n"))
        
    })
}
shinyApp(ui, server)
