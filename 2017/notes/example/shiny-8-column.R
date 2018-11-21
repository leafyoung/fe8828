library(shiny)

ui <- fluidPage(
  fluidPage(
    fluidPage(
      titlePanel("Hello Shiny!"),
      fluidRow(
        column(4,
               wellPanel(
                 dateInput("date", "How's weather today?")
               )
        ),
        column(6,
               h3("Plot"),
               wellPanel(plotOutput("distPlot"))
        ),
        column(2, h3("Extra"),
               wellPanel(plotOutput("extraPlot"))
               )
      )
    )

    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


