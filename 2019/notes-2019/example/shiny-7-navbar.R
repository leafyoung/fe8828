library(shiny)

ui <- fluidPage(
    navbarPage(title = "Runchee Technology",
               tabPanel("Product", 
                        titlePanel("Hello!"),
                        "One more thing!",
                        p("another paragragh")),
               tabPanel("About us",
                        fluidPage(titlePanel("Hello!"),
                                  "Exordinary people"))
               ,
               navbarMenu(title = "Contact Us",
                          tabPanel("Address", "3/4 platform"),
                          tabPanel("Phone", "+123.456")
               )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


