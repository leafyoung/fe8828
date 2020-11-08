library(shiny)

ui <- fluidPage(
          style = "background:#5c8a8a",
          navbarPage(title = "ClimateTick",
              tabPanel("Home",
                       fluidRow(
                           column(12,
                                img(src = "https://cdn.downtoearth.org.in/library/large/2019-09-22/0.43013100_1569136886_earth-in-forest.jpg", width = "100%")
                                 )
                       ),
              
                       h2("Empower for a better future", style = "color:white;background:#3d3d29"),
                       h4("ClimateTick, launched with the vision of providing intelligent energy solutions, 
                               offers services to private and institutional clients to optimize electricity consumption, 
                               reduce carbon footprint and bridge clients with startups for latest green technology. 
                               We empower our clients, including households and companies, with innovative solutions for a better planet. "
                              , style = "color:#ebebe0"), br(),
                       
                       
                        fluidRow(
                          column(4,
                            wellPanel(
                              h2("Household"),
                              tags$p("Download our ClimateTick app to start creating your green home."),
                              tags$p("Get personalized advice for a better structured consumption plan."),
                              tags$p("Join the green community to find out more about low carbon life and share your stories as well!"),
                              )),
                          
                          column(4,
                                 wellPanel(h2("Company"),
                                           tags$p("We offer end-to-end optimization service for companies that are looking for more efficient and 
                                           cheaper energy consumption with reduced carbon release."),
                                           tags$p("Starting from on-site analysis, our experts find 
                                           the best structure and technology, and provide continuous support after deployment.")
                                 )),
                          column(4,
                                 wellPanel(h2("Green Startups"),
                                           tags$p("Innovations are welcomed! If you are launching a startup with products or technologies 
                                                  tackling climate change, energy saving etc -- Talk to us!"),
                                           tags$p("We are creating a platform to direct the solution to the problem. While finding the best solution for our clients, we also find the best place to implement your products!"),

                                 ))                          
                          )
                        ),
              navbarMenu(title = "Products + Services",
                         tabPanel("ClimateTick App", 
                                 
                                  sidebarPanel(
                                      h2("ClimateTick App"),
                                      br(),
                                      tags$li("Version: 2.33"),
                                      tags$li("Available: iOS, Android"),
                                      tags$li("Subscription: FREE"),
                                      tags$li("Rating: \U2605 \U2605 \U2605 \U2605 \U2605"),
                                      br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                    
                                      a("Download", href="http://www.google.com"),
                                      br(),br(),
                                                                        ),
                                  mainPanel(
                                   
                                      h2("A housekeeper who looks after your wallet and the planet", style = "color:white"),
                                
                                      tags$strong("Action today and start with downloading ClimateTick app! Create an account for your house so that you can: " ),
                                      br(),
                                      tags$li("Monitor utility usage and receive personalized advice for utility savings."),
                                      tags$li("Connect the app with your smart appliances to create a smart green home."),
                                      tags$li("Follow other users to share and find out tips of leading a green life."), 
                                      br(),
                                      img(src = "https://qualityhomes.com.sg/wp-content/uploads/2019/12/slider-image-1-1240x536.jpg", width = 500),br(),br(),
                                  ),
 
                         ),
                         tabPanel("Green Consulting", 
                                  fluidRow(
                                      column(7,
                                             img(src = "https://ic-cz.com/wp-content/uploads/2018/11/hp-img.jpg", width = "100%"),
                                             tags$p(" "), #blank line
                                             ),
                                      column(5,
                                             h2("Solution to the future", style = "color:white")
                                             
                                      )
                                  ),
                                  wellPanel(
                                    h4("We offer end-to-end service and bring you the optimal energy solution through a well structured project lifecycle: "),
                                  
                                    navlistPanel(
                                        tabPanel("1. On-site Anaysis",
                                            tags$p("We understand AS-IS, define requirements and assess opportunities for energy saving and carbon reducing.")
                                             ),
                                        tabPanel("2. Design", 
                                            tags$p("We design the future stage with combined levers including but not limited to process re-engineering and latest green technology")
                                              ), 
                                        tabPanel("3. Installation", 
                                            tags$p("We implement the solution with extensive testing and user education")
                                             ),
                                       tabPanel("4. Continuous Support", 
                                            tags$p("Post installation we continue to provide support in monitoring, maintenance and upgrading.")
                                             )
                                    )
                                  )
                        )
              ),
                       
              tabPanel(title = "Contact Us",
                         wellPanel(
                          tags$li("Address", "2888 Nanyang ABC Drive, DEF Tower F6, 123456"),
                          tags$li("Phone", "+65 8888 9999"),
                          tags$li("Email: solutions@ClimateTick.com")
                         )
               )
    )
  )


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


