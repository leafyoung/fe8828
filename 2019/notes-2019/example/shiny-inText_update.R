library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  textInput("inText", "inText", ""),
  actionButton("go", "Go"),
  textOutput("dupText")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  observeEvent(input$go, {
    inText <- isolate(input$inText)
    updateTextInput(session, "inText", label = inText)  
    output$dupText <- renderText({
      paste(inText, inText)
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

