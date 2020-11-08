# shiny-51-renderPrint.R
library(shiny)

ui <- fluidPage(
  actionButton('go', 'Go'),
  verbatimTextOutput("t1"),
  verbatimTextOutput("t2"),
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    for (i in 1:10) {
      output$t1 <- renderText({ 
        print("loading")
        # do loading
        print("calcuation")
        # do calculation
        print('result')
        # do result
      })
    }    
  })

  observeEvent(input$go, {
    output$t2 <- renderPrint({ 
        print("loading")
        # do loading
        print("calcuation")
        # do calculation
        print('result')
        # do result      
    })
  })  
}

shinyApp(ui, server)