# shiny-53-renderUI.R

library(shiny)

ui <- fluidPage(
  uiOutput("p1")
)

server <- function(input, output, session) {
  output$p1 <- renderUI({
    tl <- tagList(
      h1("HTML t1"),
      uiOutput("t1"),
      h1("Plot p1p1"),
      plotOutput("p1p1")
    )

    tl
  })
  
  output$t1 <- renderUI({
    tagList(
      h1("HTML p1t1 inside t1"),
      plotOutput("p1t1")
    )
  })

  output$p1t1 <- renderPlot({
    plot(1:100, runif(100))
  })
  
  output$p1p1 <- renderPlot({
    plot(1:100, runif(100))
  })
  
  
}

shinyApp(ui, server)

