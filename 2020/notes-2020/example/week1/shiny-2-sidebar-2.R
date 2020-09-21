library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  fluidPage(sidebarLayout(
    sidebarPanel("This is a panel on the side"),
    mainPanel("",
              h1("A"))
  ))
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


