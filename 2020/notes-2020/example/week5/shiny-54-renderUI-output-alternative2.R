# shiny-54-renderUI-output-not-working.R

library(shiny)

ui <- fluidPage(
  uiOutput("p1")
)

server <- function(input, output, session) {
  output$p1 <- renderUI({
    uiopt <- tagList()
    for (i in 1:3) {
      uiopt <- tagList(
        uiopt,
        h1(paste0("HTML t", i)),
        h1(paste0("Plot p", i)),
        plotOutput(paste0("plot", i)))
    }
    uiopt                     
  })
  
  for (i in 1:3) {
    (function(i) {
      print(i)
      output[[paste0("plot", i)]] <- renderPlot({
        hist(rnorm(1000, 0, i * 100))  
      })    
    })(i)
  }
}

shinyApp(ui, server)

