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

