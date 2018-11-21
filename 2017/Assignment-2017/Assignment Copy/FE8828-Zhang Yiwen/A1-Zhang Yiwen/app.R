#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  fluidPage(
  navbarPage(title =strong("Zeven's Food Industry"),
             
             navbarMenu("Products",
                      titlePanel("Welcome!"),
                      br(),
                      tabPanel("Green Tea",br(),h4("Green Tea: "),img(src = "macha.png")),
                      tabPanel("Macha Cake",br(),h4("Cakes: "),img(src = "cake.png"))
                      ),
             
             
             tabPanel("Customer Service",
                      titlePanel("Hi! Please type in your request:"),
                      textInput("text",label = NULL),
                      submitButton("submit"),
                      br(),
                      h5("Address:NTU, 48 Nanyang Ave"),
                      h5("Phone number: 87964536"),
                      sidebarPanel(
                        sliderInput(
                          "rate","Rate the service:",
                                    max = 10,
                                    min = 0,
                                    value = 5)),
                        img(src="location.png", height = 400, width = 400)),
             
             tabPanel("Join us",
                      titlePanel("Contacting methods:"),
                      fluidRow(
                        column(5,
                               wellPanel("email: 4455558899@gmail.com")
                        ),
                        column(5,
                               wellPanel("Phone: 4455558")
                        ),
                        column(2,
                               wellPanel("Extra info")
                        )
                      )
                    
                    )
             )
  ),


 
      mainPanel(
        br(),
        "   @Since 2017, all right reserved by Zeven.")

   
)

# Define server logic required to draw a histogram

server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

