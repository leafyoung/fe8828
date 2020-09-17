#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#


library(shiny)

# Define UI for the officical website of my new company
ui <- fluidPage(
    
    # Warm-up
    titlePanel("Welcome!"),
    
    navbarPage(
        title = "Home of Fake Fan",
        
        # Colunmn-based layout for About US
        tabPanel("About us",
                 titlePanel("Introduction to Home of Fake Fan"),
            fluidRow(
            column(5,
                   h2("When you book a ticket to a musical festival or concert
                      do you feel:"),
                   h4("Only 1/10 singers are familiar with?"),
                   h4("Embarrassed when you can not join the chorus?"),
                   h4("Afraid to waste your valuable tickets 
                      because of not fully enjoying the festival or concert?")
            ),
            column(5,
                   h2("There is no need to worry about these anymore!"),
                   h2("No worry about being called a fake fan anymore!"),
                   h4("We are devoted to help you prepare for a musical festival/concert and
                      then get the best from them!"),
                   h4("Book service with us right now, and make your next on-site 
                      musical experience extrordinary and unforgettable!")
            ),
            column(2,
                   h2("Warm reminder:"),
                   h4("We are the ONLY provider for this kind of service!")
            )
        )),
        
        # Sidebar for Product
        tabPanel("Service",
                 titlePanel("Our services"),
            fluidPage(sidebarLayout(
            sidebarPanel(
                h5("Musical Festival Lover"),
                h5("Concert Lover")
            ),
            mainPanel("Product description:",
                      h2("Musical Festival Lover"),
                      h4("1. Get to know full list of singers quickly"),
                      h4("2. Grasp key background info of singers to talk with other
                         fans like a real fan"),
                      h4("3. Review all the lyrics in advance to join the chorus"),
                      h2("Concert Lover"),
                      h4("1. Get to know the musical basics and talk
                         like a master in a short time"),
                      h4("2. Get to know full list of songs before any others"),
                      h3("All the aformentioned info is delivered in the form of our carefully
                      crafted text AND video for you, 
                         to get fully prepared for your loved musical events!")
                      )
        ))),
        
        # Navlist for Contact Us
        tabPanel("Contact us",
                 titlePanel("For any inquiries please contact:"),
            navlistPanel(
            "Reach us by",
            tabPanel("Mobile",
                     h4("+65 1123-5813")
                     ),
                     
            tabPanel("Email",
                    h4("homeoff@mfe.com")
                     ),
            
            tabPanel("Address",
                    h4("A small dormitory of Nanyang Technological University")
                     )    
            )
        )
    )
)

# Define server logic without functions
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
