#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


ui <- fluidPage( 
  navbarPage(title = "Chinese Instrument Shop",
             tabPanel("Introduction", 
                      titlePanel("Welcome!"),
                      sidebarLayout(
                        sidebarPanel( 
                          h3("This is our shop"), 
                          h5("We are a shop with a long history of creating high-quality musical Chinese instruments.")), 
                        mainPanel( 
                          img(src = "pic1.jpg",width = "90%") ))
                     ), 
             tabPanel("Product", 
                      fluidPage(titlePanel("Various types!"),
                                navlistPanel(
                                  "Strings",
                                  tabPanel("Erhu", 
                                           h1("Erhu"),
                                           img(src = "pic2.jpg",width = "90%")),
                                  tabPanel("Violin",
                                           h1("Violin"),
                                           img(src = "pic3.jpg",width = "90%")),
                                  "Plucked string",
                                  tabPanel("Pipa",
                                           h1("Pipa"),
                                           img(src = "pic1.jpg",width = "90%")),
                                  tabPanel("Guzheng",
                                           h1("Guzheng"),
                                           img(src = "pic4.jpg",width = "90%"))
                                )
                        ) ), 
             navbarMenu(title = "Contact Us",
                        tabPanel("Address", 
                                 fluidRow(
                                   column(6,
                                          h3("Map"),
                                          wellPanel(img(src = "pic5.jpg",width = "90%"))
                                   ))), 
                        tabPanel("Phone", "+66666666") 
                        ) 
             ) 
  )
# Define server logic required to draw a histogram 
server <- function(input, output) {
  
}
# Run the application 
shinyApp(ui = ui, server = server)


