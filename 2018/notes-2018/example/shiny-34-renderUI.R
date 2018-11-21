<<<<<<< HEAD
# shiny-34-renderUI.R

library(shiny)

ui <- fluidPage(
  uiOutput("p1")
)

server <- function(input, output, session) {
  output$p1 <- renderUI({
    tagList(
      h1("HTML t1"),
      uiOutput("t1"),
      h1("Plot p1"),
      plotOutput("p1")
    )
  })
}

shinyApp(ui, server)

=======
# shiny-34-renderUI.R

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
  
  output[[paste0("plot", 1)]] <- renderPlot({ hist(rnorm(1000, 0, 1)) })
  output$plot2 <- renderPlot({ hist(runif(1000)) })
  
  for (i in 1:3) {
    output[[paste0("plot", i)]] <- renderPlot({ hist(rnorm(1000, 0, i)) })
  }
}

shinyApp(ui, server)

>>>>>>> 3e8105f2e09af3bd607a5ac90104531e2d4c6eb4
