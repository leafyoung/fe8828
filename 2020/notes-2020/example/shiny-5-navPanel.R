library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  fluidPage(
    titlePanel("Hello Shiny!"),
    navlistPanel(
      "Header A",
      tabPanel("Section 1",
               
               h1("Section AA"),
               p("This is section 1. First lecture in FE8828."),
               p(""),
               p("")
               
               ),
      tabPanel("Section 2",
               h1("Section 2"),
               
               a("this way to google.",href="http://www.google.com"),
               p("abc"),
               p("def")
               
               ),
      "Header B",
      tabPanel("Section 3",
               h1("Section 3")),
      "-----",
      tabPanel("Component 5")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


