library(shiny)
library(ggplot2)
ui <- fluidPage(
  fluidPage(
    navbarPage(title = "Battlegrounds",
               tabPanel("About Us",
                        h1(strong("Welcome to Battlegrounds!")),
                        hr(),
                        h3("The ultimate entertainment platform."),
                        h3("Play, connect, create and more."),
                        h3("Install Battlegrounds today and start gaming!"),
                        wellPanel(
                          actionButton("goButton", "Install Battlegrounds now!")
                        ),
                        img(src = "hahaha.png", width = "70%"),
                        sidebarLayout(
                          sidebarPanel(
                            h3(em("Instant Access to Games")), 
                            p("We have lots of games.Enjoy exclusive deals,
                               automatic game updates and other great perks."),
                            h3(em("Create and Share Content")),
                            p("Gift your friends, trade items, and even create new content for games in the Workshop.
                              Help shape the future of your favorite games.")
                            ),
                          mainPanel(
                            br(),
                            h3(em("Entertainment Anywhere")),
                            p("Whether you are on a PC, mobile device, or even your television,
                              you can enjoy the benefits of Battlegrounds."),
                            p("Take the fun with you."),
                            wellPanel(
                              actionButton("goButton", "Install Battlegrounds now!")
                            )
                            )
                            )
                                   ),
               tabPanel("Store",
                                 tabsetPanel(
                                   
                                   tabPanel("Recommended",
                                            h1("Featured & Recommended"),
                                            hr(),
                                            br(),
                                            fluidRow(
                                              column(4,
                                                     h3("ATOMEGA"),
                                                     wellPanel(
                                                       img(src = "ATOMEGA.png",width="100%")
                                                     ),
                                                     p("Grow, fight, collect and evade in the last cosmic 
                                                       arena the very end of time. Acquire MASS to evolve 
                                                       your EXOFORM from the nimble ATOM to the godlike OMEGA 
                                                       and compete for fun and dominance in a fast-paced, 
                                                       multiplayer shooter.")
                                                     
                                              ),
                                              column(4,
                                                     h3("Assassin's Greed Origins"),
                                                     wellPanel(
                                                       img(src = "enenen.png",width="100%")
                                                     ),
                                                     p("Ancient Egypt, a land of majesty and intrigue,
                                                       is disappearing in a ruthless fight for power. 
                                                       Unveil dark secrets and forgotten myths as you
                                                       go back to the one founding moment.")
                                              ),
                                              column(4,
                                                     h3("See No Evil"),
                                                     wellPanel(
                                                       img(src = "see no evil.png", width = "100%")
                                                     ),
                                                     p("See No Evil is a dark, isometric puzzle game about
                                                       sound manipulation. A harsh fantasy where the willingly
                                                       blind are hostile to the nonconformist. Sometimes, the
                                                       world seems darker with your eyes open.")
                                              )
                                             
                                            )
                                            ),
                                   tabPanel("Curators",
                                            h1("Battlegrounds Curators"),
                                            hr(),
                                            br(),
                                            h2("Products recommended by Battlegrounds Curators that you follow."),
                                            br(),
                                            h3("Sign in to follow curators"),
                                            p("You will need to sign in before you can see recent recommendations
                                              from any Battlegrounds Curators you follow."),
                                            wellPanel(
                                              actionButton("goButton", "Sign in")
                                            )
                                            ),
                                   tabPanel("News",
                                            h1("All News"),
                                            hr(),
                                            br(),
                                            h2("Daily Deal - Last Day of June, 40% Off"),
                                            p("Save 40% on Last Day of June! Offer ends Tuesday at 10AM Pacific Time."),
                                            img(src = "news.png", width="50%"),
                                            br(),
                                            br(),
                                            h2("Daily Deal - Night Dive Advert Thing, 80% Off"),
                                            p("Today's Deal: Save 80% on Night Dive Advert Thing!
                                              Offer ends Thursday at 10AM Pacific Time."),
                                            img(src = "xixixi.png", width="50%")
                                            )
                                 )
                                 

                       
               ),
               tabPanel("Support",
                        h1("Battlegrounds Support"),
                        hr(),
                        br(),
                        h2("What do you need help with?"),
                        br(),
                        p("Sign in to your Battlegrounds account to review purchases, account status, and get personalized help."),
                        fluidRow(
                          column(2,
                                 wellPanel(
                                   actionButton("goButton", "Sign in to Batttlegrounds"))
                                 ),
                          column(2,
                                 wellPanel(
                                   actionButton("goButton", "Help, I can't sign in"))
                                 )
                        ),
                        br(),
                        navlistPanel(
                          tabPanel("Games, Software, etc."),
                          tabPanel("Purchases"),
                          tabPanel("My Account"),
                          tabPanel("I have charges from Steam that I didn't make")
                        )
                            
                        )
    )
  ))
# Define server logic required to draw a histogram
server <- function(input, output) {
} 
# Run the application
shinyApp(ui = ui, server = server)
