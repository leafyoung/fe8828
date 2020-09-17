# FE8828 Assignment 5
# Fang You G1800202G

library(shiny)

ui <- fluidPage(
  
  h1("FE8828 Assignment 5"),
  h2("Fang You G1800202G"),
  
  h3("The most frustrating game that seems to defy probability."),
  h4("In this game, a random integer between 0 to 3 is generated based on uniform distribution. If the number generated is not in the list below, this number will be added to the list, otherwise, this number will be deleted from the list"),
  h4("The objective of this game is to get a complete list with all integers from 0 to 3"),   
  
  h4("In theory, the chances of getting 4 different integers 0 to 3 consecutively is 4!/(4^4) = 0.09375 or one in 10.7 chances"),
  h4("How lucky are you? (for the less patient, you may manually overwrite the input finish the game early to see what happens"),
  
  numericInput("shock","Shock",value = round(runif(1)*3),0),
  actionButton("add","Add/Remove"),
  verbatimTextOutput("counter"),
  checkboxGroupInput("scenarios","Scenarios",choices = c(),selected = c())
  
)

scenarios <- c()
tries <- 1

server <- function(input, output,session) {
  updateCheckboxGroupInput(session,"scenarios",choices = scenarios,selected = scenarios)
  
  observeEvent(input$add, {
    shock <- isolate(input$shock)
    
    if(!(shock %in% scenarios)) {
      
      scenarios <<- sort(c(scenarios,shock))
      
      updateCheckboxGroupInput(session, "scenarios", choices = scenarios,selected = scenarios)
    } else {

      index <- match(shock,scenarios)
      scenarios <<- sort(scenarios[-c(index)])

      updateCheckboxGroupInput(session, "scenarios", choices = scenarios,selected = scenarios)
    }
    
    #put a new random value
    updateNumericInput(session,"shock",value = round(runif(1)*3))
    #tries <<- tries +1
    
    #notification appears when player successfully gets all 4 integers into the list
    if(length(scenarios) == 4){
      showNotification("You made it!")
      updateNumericInput(session,"shock",value = "")
    } 

  })
  
  observeEvent(input$add, {
    if(length(scenarios) == 4) {
    tries <<- tries
    output$counter <- renderPrint({
      cat(paste0("No. of tries: ",tries, "\nThank you Prof Yang for teaching FE8828. I thoroughly enjoyed the class and practicing on the assignments. I find the content very useful in my journey to learn R programming."))
    })
    } else {
      tries <<- tries + 1
    }
    # output$counter <- renderPrint({
    #   cat(paste0("No. of tries: ",tries))
    # })
  }) 
  
}

# Run the application 
shinyApp(ui = ui, server = server)

