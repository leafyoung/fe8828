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
    ########  New boxes are added at the top
    observeEvent(input$add, {  
        
        shock <- isolate(input$shock)   
        
        if (!(shock %in% scenarios)) {      
            scenarios <<- c(shock, scenarios)     
            updateCheckboxGroupInput(session, "scenarios",                               
                                     choices = scenarios,
                                     selected = scenarios)                                                                                                                                       
        }
        
        # put a new random value    
        updateNumericInput(session, "shock", value = round(runif(1) * 1000))
        
        })
    
    ########  Upon clicking the remove button the box that is at the top and which is also the most
    ########  recent gets removed .
    ########  Can also remove any specific box by entering the value.
    
    observeEvent(input$remove, {  
        
        shock <- isolate(input$shock)   
        
        if (shock %in% scenarios) {      
            scenarios <<- scenarios[scenarios!=shock]     
            updateCheckboxGroupInput(session, "scenarios",                               
                                     choices = scenarios,
                                     selected = scenarios)                                                                                                                                       
        }
        
        # put a new random value    
        updateNumericInput(session, "shock", value = scenarios[1])
    }) 
    
    output$o1 <- renderPrint({    
        x <- input$scenarios    
        str(x)    
        cat(paste0("length: ", length(x), "\n"))    
        cat(paste0(x, "\n"))  
    }) 
    }
    shinyApp(ui, server)
    
