#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

ui <- fluidPage(
    navbarPage(title = "A Phone Pte Ltd",
               tabPanel("Product", 
                        titlePanel("The best phone yet."),
                        fluidRow(
                            column(4,
                                   h3("Since 1998"),
                                   wellPanel(p("Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua.
                                               Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua."),
                                             img(src="pixel-4a.jpg", width="100%"))
                                   
                            ),
                            column(5,
                                   h3("Features"),
                                   wellPanel(title = "Test",
                                   p("Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua."),
                                   img(src="hero_alt.png",width = "75%"),style="text-align: center;")
                            ),
                            column(3, h3("Current Promotions!"),
                                   wellPanel(p("Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua.
                                               Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua."))
                            )
                        ),
                        ),
               tabPanel("About us",
                        fluidPage(titlePanel("Who are we?"),
                                  navlistPanel(
                                      "How it all started",
                                      tabPanel("Humble Beginnings", 
                                               h1("Humble Beginnings"),
                                               p("Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua."),
                                               img(src="header.png",width = "100%")),
                                      tabPanel("Where are we now?",
                                               h1("Where are we now?"),
                                               img(src="hero.png",width = "100%"),
                                               p("Lorem ipsum dolor sit amet, 
                                               consectetur adipiscing elit, 
                                               sed do eiusmod tempor incididunt ut 
                                               labore et dolore magna aliqua."),
                                               )
                                  )))
               ,
               navbarMenu(title = "Contact Us",
                          tabPanel("Address", 
                                   sidebarLayout(
                                       sidebarPanel(
                                           h1("Main Address"),
                                           wellPanel(p("50 Nanyang Ave, 639798")),
                                           h2("Other Locations"),
                                           wellPanel(p("42 Nanyang Avenue, Singapore 639815"))
                                       ),
                                       mainPanel(
                                           img(src = "done.png",width="90%")
                                       )
                                   )),
                          tabPanel("Others", 
                            mainPanel(img(src="touch.png"),
                                titlePanel("Come contact us!"), style="text-align: center;",
                                wellPanel(
                                          p("Telephone: +65 6767 6767"),
                                          p("Email: hello@aphone.com")),style="text-align: center;",))
               )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
}

# Run the application 
shinyApp(ui = ui, server = server)

