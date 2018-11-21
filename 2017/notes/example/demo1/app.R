library(shiny)

ui <- pageWithSidebar(
  headerPanel("Interactive Histogram"),
  sidebarPanel(
    numericInput("n", "Generate this many points", 
                 min = 1, value = 1000),
    selectInput("family", "From this family",
                choices = c("Normal",
                            "Uniform",
                            "Exponential"),
                selected = "normal"),
    sliderInput("bins", "number of bins", 
                min = 1, max = 100, value = 50)
  ),
  mainPanel(
    plotOutput("histogram")
  )
)

server <- function(input, output) {
  data <- reactive({ 
    FUN <- switch(input$family,
                  "Normal" = rnorm,
                  "Uniform" = runif,
                  "Exponential" = rexp)
    FUN(input$n)
  })
  
  output$histogram <- renderPlot({
    hist(data(), breaks = input$bins)
  })
}

# Return a Shiny app object
shinyApp(ui = ui, server = server)

