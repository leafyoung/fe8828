
library(shiny)

UI <- fluidPage(
   fluidPage(
     navbarPage(title = "Hi! Welcome to Calvin Company!",
                tabPanel("Our Company",
                         h1("Calvin Company is one of the most renowned companies focused on providing professional career counseling and help for college students based in Singapore. Over the past year, 
                         we've helped tens of thousands of students to find the true direction they're interested in."), 
                         h2("More Details: Create Time: October 1st, 2016 & Registered Capital of Our Company: One Billion Singapore Dollars")),
                navbarMenu(title = "Our Service",
                           tabPanel("Main Services We Offer",
                                    fluidPage(
                                      titlePanel("Career Interest Counseling"),
                                      navlistPanel(
                                        "",
                                        tabPanel("Self-Cognition and Positioning"),
                                        tabPanel("Guidance and Practice"),
                                        tabPanel("Track Investigation and Feedback"),
                                        tabPanel("Regular Appointment and Communication")
                                      )
                                    )
                           ),
                           tabPanel("Developing")
                )
                
    ),
                tabPanel("Contact Us",
                           mainPanel(
                           tabsetPanel(
                              tabPanel("Address",
                                        p("Add: Nanyang Business School, Nanyang Technological University")
                               ),
                              tabPanel("Phone",
                                        p("Phone: +65 9895 1715, Mr. Wu Kaibin")
                              )
                           )
                           )
                         )
   )
)
           
      
SERVER <- function(input, output) {}
shinyApp(ui = UI, server = SERVER)

