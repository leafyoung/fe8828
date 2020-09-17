library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  fluidPage(sidebarLayout(
    sidebarPanel("This is a panel on the side"),
    mainPanel("This is the main panel")
  )),

  fluidPage(sidebarLayout(
    sidebarPanel("This is a panel on the side"),
    mainPanel("This is the main panel")
  ))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


