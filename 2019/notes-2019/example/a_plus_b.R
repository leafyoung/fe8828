library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  numericInput("a", "a", 0),
  h1("+"),
  numericInput("b", "b", 0),
  h1("="),
  actionButton("go", "Go"),
  textOutput("result"),
  h1("bbb"),
  verbatimTextOutput("bbb"),
  
  plotOutput("ppp")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observeEvent(input$go, {
    output$result <- renderText({ isolate(input$a) * isolate(input$b) })
  })
  
  output$bbb <- renderText({ input$zzz })
  
  output$ppp <- renderPlot({
    hist(rnorm(10000, input$a, input$b))
  })
}
 
shinyApp(ui = ui, server = server)

