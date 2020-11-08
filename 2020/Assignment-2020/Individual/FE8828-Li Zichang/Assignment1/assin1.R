#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
        titlePanel("Welcome to U-Tennis!"),
        
            tabsetPanel(
            tabPanel(("About us"), h1("About us"),
                sidebarLayout(
                    sidebarPanel(h1("Our Story"),
                    tags$ul("About",
                    tags$li("Who are we"),
                    p("U-Tennis is the company aiming for best services for tennis."),
                    tags$li("What we do"), 
                    p("Provide everything you need for playing tennis!")
                        )),
                    mainPanel(
                      img(src = "tennis1.jpeg",width="90%")
                )
              )
            )  , 
            tabPanel(("Our Services"),
                navlistPanel(
                    "Court Reservation",
                    tabPanel("grass court",h1("grass court"),
                            p("We have 10 grass courts in total. Offered from 9a.m. to 10 p.m."),
                            p("The price is $40 per hour."),
                            a("Book Now!", href = "http://www.utennis.bookcourt-1.com")
                            ),
                    tabPanel("hard court",h1("hard court"),
                            p("We have 20 hard courts in total. Offered from 9a.m. to 10 p.m."),
                            p("The price is $25 per hour."),
                            a("Book Now!", href = "http://www.utennis.bookcourt-2.com")
                            ),
                    "Tennis training",
                    tabPanel("One-on-One training", h1("1 v.s. 1 training"),
                             p("We have many well-known tennis coaches."),
                             p("Come and experience it, honing your skills!")
                            ),
                    tabPanel("One to many training", h1("1 v.s. many training"),
                             p("Famous coaches. Invite your friends to enjoy!")
                            ),
                    "Tennis rackets and balls",
                    tabPanel("Rackets", h1("Rackets"),
                             p("A wide variety of choices- produed by famous brand.")
                             ),
                    tabPanel("Balls", h1("Balls"),
                             p("High quality tennis balls."),
                             p("Purchase in our stores!")
                          )
                    )
              ),
            tabPanel(("Contact us!"), h1("Contact Information"),
                      fluidRow(
                        column(4,
                               wellPanel(
                                 h2("Telephone"),
                                 p("Call us by 010-6668887.")
                               )
                        ),
                        column(6,
                               h2("Email"),
                               wellPanel(p("Any suggestions or thoughts?"),
                                         p("Email us: utennis_090@outlook.com"))
                        )
                      ))    
                )
            
      )

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)

