library(shiny)
ui <- fluidPage(
    fluidPage(
        navbarPage(
            title=div(img(src="pic2.png",height=30,width=30), "SuccuLove"),
            tabPanel("Home",
                     img(src="pic4.png",width="100%"),
                     titlePanel("Welcome to SuccuLove!"),
                     p("Do you love succulents? We do too! Welcome to the world of succulents, where you can fulfill all your succulent needs and wants!"), 
                     p(""),
                     fluidRow(
                         column(8,align="center",
                                h3("Purchase Succulents!"),
                                p("SuccuLove offers a varierty of succulents!"),
                                p("No one will be able to resist their allure and beauty."),
                                p("Our succulents are all sourced from experienced nurseries in Korea, China and Taiwan")
                                
                         ),
                         column(4,
                                img(src="cagedflower.png",width="100%")

                         )
                     ),
                     fluidRow(
                       
                       column(4,
                              img(src="multicolour.png",width="100%")
                              
                       ),
                       column(8,align="center",
                              h3("Plant Care"),
                              p("Succulents are hardy plants. However, they still require your care in order to showcase their best side."),
                              p("With our tips and tricks, your succulents will grow healthy and strong!")
                       )
                     ),
                     fluidRow(
                       column(8,align="center",
                              h3("Succulent Lovers Unite!"),
                              p("Get onto our forum to connect with other succulent lovers!"),
                              p("Share your experiences and plant tips."),
                              p("Flaunt your own stunning succulents!")
                              
                       ),
                       column(4,
                              img(src="cactusred.png",width="100%")
                              
                       )
                     )),
                     
            navbarMenu(title = "Succulents",
                       tabPanel("Echeveria", 
                                img(src="echeveria.png",width="100%"),
                                h1("Echeverias"),
                                fluidRow(
                                  column(4,align="center",
                                         img(src="minima.png",width="100%"),
                                         h4("Echeveria Minima")
                                  ),
                                  column(4,align="center",
                                         img(src="blueatoll.png",width="100%"),
                                         h4("Echeveria Blue Atoll")
                                  ),
                                  column(4,align="center",
                                         img(src="perle.png",width="100%"),
                                         h4("Echeveria Perle von Nurnberg")
                                  )
                                )
                                ),
                       tabPanel("Aloe", 
                                img(src="aloe.png",width="100%"),
                                h1("Aloe"),
                                
                                fluidRow(
                                  column(4,align="center",
                                         img(src="greenaloe.png",width="100%"),
                                         h4("Green Aloe Vera")
                                  ),
                                  column(4,align="center",
                                         img(src="blackgem.png",width="100%"),
                                         h4("Black Gem Aloe Vera")
                                  )
                                )
                                ),
                       tabPanel("Cacti", 
                                img(src="cacti.png",width="100%"),
                                h1("Cacti"),
                                fluidRow(
                                  column(4,align="center",
                                         img(src="large.png",width="100%"),
                                         h4("Large Cacti")
                                  ),
                                  column(4,align="center",
                                         img(src="small.png",width="100%"),
                                         h4("Small Cacti")
                                  ),
                                  column(4,align="center",
                                         img(src="Opuntia.png",width="100%"),
                                         h4("Opuntia Cacti")
                                  )
                                ))
                       
            ),
            
            tabPanel("Plant Care",
                    fluidRow(
                      column(3,
                             img(src="sidebar.png",width="100%")),
                      column(9,
                              h1("Plant Care"),
                              h2("How to care for succulents?"),
                              p("Singapore's hot climate makes caring for succulents a tricky matter. With our tips and tricks, you will be a succulent expert in no time!"),
                              
                              h4("Tip 1: Make sure you water enough but not too much!"),
                              p("Succulents need a specific amount of water to ensure that it grows up healthy and beautiful. Each succulent requires different amounts of water at different times. A rule of thumb is to water the plant when the top 1.25 inches are dry. Make sure to let the soil dry between waterings!"),
                              h4("Tip 2: Ensure that the plant has sufficient sunlight"),
                              p("Succulents require sunlight and constant airflow. Ensure that they are put in an open area with sufficient indirect sunlight. Succulents burn easily so too much sunlight is bad too. Succulents also work very well under artificial light and you can consider purchasing succulent lamps to provide a proper amount of light for your beloved succulents"),
                              h4("Tip 3: Plant Succulents in the Right Soil!"),
                              p("Succulents need soil that drains, so regular potting soil—or dirt from your yard—won’t do. Choose cactus soil or mix potting soil with sand, pumice, or perlite. Succulent roots are very fragile so be gentle when repotting.")
                              )
                       
                     )
                     
                     
                     ),
            tabPanel("Forum",
                     fluidRow(
                       column(9,
                              h1("Forum"),
                              h2("Share your thoughts:"),
                              h4("Emily:"),
                              p("Hey, does anyone know where I can get good soil for my succulents?"),
                              h4("Charmaine:"),
                              p("I buy my succulent soil mix from Bukit Batok Nursery! You can check it out there!"),
                              h4("Pamela:"),
                              p("My succulents keep dying :( I need some help!"),
                              h4("Leah:"),
                              p("So happy to be able to join this community!"),
                              h4("Gordan:"),
                              p("My money are all flying away because of these succulents!"),
                              
                              h3("Anything to share?"),
                              textInput("text", "Name", 
                                        value = ""),
                              textInput("text1", "Comment", 
                                        value = "")
                              ),
                       column(3,
                              img(src="sidebar2.png",width="100%"))
                       )
                     ),
                     

            tabPanel("Contact Us",
                     
                     navlistPanel(
                       
                       tabPanel("Contact Details",
                                h1("Contact Details"),
                                p("Contact Number: +65 8347 32743"),
                                p("Email Address: succulove@gmail.com"),
                                img(src="pink.png",width="80%",align="centered")),
                       tabPanel("Locations",
                                h1("Locations"),
                                p("----------------------------------------------------------------------------------------"),
                                h4("Head Office"),
                                p("234 Ang Moh Kio Ave 10 #10-543"),
                                p("Singapore 995494"),
                                p("Opening Hours: 9am - 8pm, Mon- Fri"),
                                p(" -------------- "),
                                h4("Branches"),
                                p("654 Pioneer Road #4-23"),
                                p("Singapore 433333"),
                                p("Opening Hours: 9am - 8pm, Mon - Fri"),
                                img(src="purple.png",width="80%",align="centered")
                                )
                     ))
        )
    )
)

server <- function(input, output) {
}
# Run the application
shinyApp(ui = ui, server = server)