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
  
  sapply(1:3, function(i) {
    # This creates new environment for each value of i.
    # i.e. i has been duplicated many times for difference values.
    # When the block of code runs in renderPlot, it can get the correct value i.
    output[[paste0("plot", i)]] <- renderPlot({
      hist(rnorm(1000, 0, i * 100))  
    })
  })
}

shinyApp(ui, server)

