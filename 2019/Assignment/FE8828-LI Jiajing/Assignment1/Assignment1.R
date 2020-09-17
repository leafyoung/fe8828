library(shiny)

ui <- fluidPage(
    fluidPage(
        
        navbarPage(title = tags$i("STARK INDUSTRIES"),
                   tabPanel("Product", 
                            titlePanel(img(src="logo.png",width="100%")),
                            sidebarLayout(
                                sidebarPanel(h4("Munitions"),img(src="munitions.jpg",width="100%")),
                                mainPanel(h5("For World Peace Concern"),
                                h5("Off Production")
                                    )
                            ),

                            sidebarLayout(
                                sidebarPanel(h4("Quinjets"),img(src="quinjet.png",width="100%")),
                                mainPanel(h5("The Quinjet is a unique, hybrid-wing aircraft with similar flight capabilities as modern VTOL aircraft and serves as a personnel transport and versatile attack vehicle."),
                                          h5("The Avengers Quinjet possesses advanced cloaking technology and possesses similar weapon systems like a GAU-17/A Gatling Gun."),
                                          h5("It does possess advanced auto-piloting systems (which is really J.A.R.V.I.S.) as well as a cargo bay capable of carrying the entire Avengers team to wherever they are needed."),
                                          h5("There is also a hidden motorcycle, which can be dropped down near the ground."))
                            ),
                            
                            sidebarLayout(
                                sidebarPanel(h4("Armors"),img(src="armors.jpg",width="30%")),
                                mainPanel(h5("Armors worn by Iron Man and War Machine"))
                                        ),
                            sidebarLayout(
                                sidebarPanel(h4("More..."),img(src="more.jpg",width="100%")),
                                mainPanel(h5("Welcome to our distributors all around the world for more information"))
                            )
                            ),
                   
                   tabPanel("About Us",
                            titlePanel(img(src="logo.png",width="100%")),
                            titlePanel("What are we"),
                            h5("Stark Industries is primarily a defense company that develops and manufactures advanced weapons and military technologies."),
                            h5("The company manufactures the armor worn by Iron Man and War Machine."),
                            h5("It builds the helicarriers used by S.H.I.E.L.D, and it produces the Quinjets used by the Avengers."),
                            titlePanel("Main Staff"),
                            fluidRow(
                                column(3,
                                       h3("Tony Stark"),
                                       wellPanel(
                                           h3("Iron Man"),
                                           img(src="Tony.jpg",width="100%"),
                                           p("Stark Industries is founded by Howard Stark and taken over by the wealthy American business magnate, playboy, and ingenious scientist, Anthony Edward Tony Stark. In 2008, Stark suffers a severe chest injury during a kidnapping. When his captors attempt to force him to build a weapon of mass destruction, he instead creates a mechanized suit of armor to save his life and escape captivity. Later, Stark develops his suit, adding weapons and other technological devices he designed through his company, Stark Industries. He uses the suit and successive versions to protect the world as Iron Man. In 2023, Stark uses the Infinity Stones to disintegrate Thanos and all of his forces, saving the universe but fatally injuring himself in the process due to the gamma radiation caused by the stones. He dies peacefully, surrounded by Rhodes, Parker and Potts.")
                                       )
                                ),
                                column(3,
                                       h3("Pepper Potts"),
                                       wellPanel(
                                           h3("CEO"),
                                           img(src="pepper.jpg",width="100%"),
                                           p("At first, Pepper Potts is personal secretary of Tony Stark. In 2008, Stark makes Pepper the new CEO of Stark Industries, trusting only her to shut down the company in his absence.")
                                       )
                                ),
                                column(3, 
                                       h3("Happy Hogan"),
                                       wellPanel(
                                           h3("Former Head of Security"),
                                           img(src="happy.jpg",width="100%"),
                                           p("At first, Hogan is hired by Tony Stark as his chauffeur and personal assistant. Later, Hogan becomes the most reliable assistant and friend of Tony."))
                                ),
                                column(3, 
                                       h3("LI Jiajing"),
                                       wellPanel(
                                           h3("Student of NTU MFE"),
                                           img(src="classified.jpg",width="100%"))
                            ))
                            ), 
                   

                    tabPanel(title = "Contact Us",
                             titlePanel(img(src="logo.png",width="100%")),
                             navlistPanel("Location",
                                    tabPanel("Stark Industries Headquarters", 
                                            h3("Stark Industries Headquarters"),
                                            h5("Los Angeles, California, USA, Earth-199999, Marvel Cinematic Universe"),
                                            img(src="building.png",width="100%")
                                            ),
                                    tabPanel("Avengers Headquarters",
                                            h3("Avengers Headquarters"),
                                            h5("SANY America, 318 Cooper Cir N, Peachtree City, Georgia, USA, Earth-199999, Marvel Cinematic Universe"),
                                            p(tags$i("Avengers: Endgame"),
                                            img(src="AH.jpg",width="100%"))
                                            ),
                                            "Phone",
                                    tabPanel("CLASSIFIED",
                                            h3("No Phone Number Available"),
                                            h3("Please Go Directly Like Him"),
                                            h5("Scott Lang in",tags$i("Avengers: Endgame"),
                                            img(src="Scott Lang.png"))
                                            )
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
