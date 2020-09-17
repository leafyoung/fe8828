library(shiny)

# Define UI for application 
ui <- fluidPage(
    fluidPage(
        titlePanel(
                h1(strong("Wang Peng Technology"),align="center",style="font-family: 'STHupo';font-size: 44pt")
            ),
        navbarPage(
            title = strong("WP Tech"),
            tabPanel(
                    strong("About Us"),
                     h1(strong("Bridge Today & Tomorrow"),align="center",style="font-family: 'STLiti';font-size: 36pt"),
                    sidebarLayout(
                        sidebarPanel(
                            h1(strong("Introduction"),align="center",style="font-family: 'Arial';font-size: 24pt"),
                            wellPanel(
                                h2(strong("Vanguard in Science and Technology"),style="font-family: 'Times';font-size: 16pt"),
                            
                            tags$ul(
                                    tags$li("Greatest scientists from all areas.",style="font-family: 'Times';font-size: 12pt"),
                                    tags$li("Greatest laboratories and equipments."),style="font-family: 'Times';font-size: 12pt"),
                                    br(),
                                    actionButton("info1","More Information",align="left"),
                                    textOutput("info11")
                            ),
                            wellPanel(
                                h2(strong("Shaper of Future World"),style="font-family: 'Times';font-size: 16pt"),
                                tags$ul(
                                    tags$li("Turn Cutting-edge Theory into Practice.",style="font-family: 'Times';font-size: 12pt"),
                                    tags$li("Turn Scientific Fiction into Reality.",style="font-family: 'Times';font-size: 12pt"),
                                    br(),
                                    actionButton("info2","More Information",algin="left"),
                                    textOutput("info22")
                                )
                            )
                        ),
                        mainPanel(
                            img(src = "futurecity.png",width=800, height=400,Position="right"),
                            p("Wang Peng Technology was founded by Mr.Wang Peng in 2029. The purpose of our company is to expediate the exploration and application
                              of frontier theories. With best laboratories and treatment, our company attracts 
                              top scientists and engineers all over the world. Our greatest minds are making breakthroughs 
                              almost everyday and some profound achivements have been aquired. We, are on our way to change the world. ")
                        )
                    )
            ),
            tabPanel(strong("What We Do"),
                     h1(strong("Change Our World with Advanced Technology"),align="center",style="font-family: 'STLiti';font-size: 36pt"),
                     h2(strong("We have successfully realized blueprints of considerable unparalleled technologies, and some
                       of them are commercialized and open to limited customers only. "),style="font-family: 'Times';font-size: 16pt"),
                      navlistPanel(
                          "Our Business",
                     tabPanel(
                         "World Line Observation",
                         h1(strong("What is  World Line?"),align="center",style="font-family: 'Arial';font-size: 16pt "),
                         p("In physics, a world line of an object (approximated as a point in space, e.g., a particle or observer)
                           is the sequence of spacetime events corresponding to the history of the object. A world line is 
                           a special type of curve in spacetime. Below an equivalent definition will be explained: A world line
                           is a time-like curve in spacetime. Each point of a world line is an event that can be labeled with the time
                           and the spatial position of the object at that time."),
                         img(src = "worldline1.png",width=800, height=300,Position="right"),
                         h2(strong("More details about world line:"),style="font-family: 'Arial';font-size: 12pt "),
                         a("A brief introduction to world line", href = "https://en.wikipedia.org/wiki/World_line"),
                         br(),
                         a("A video about world line",href="https://www.youtube.com/watch?v=7Zutjpu6Tv4&t=1589s"),
                         h1(strong("How We Make Use of World Line?"),align="center",style="font-family: 'Arial';font-size: 16pt "),
                         p("World line is the trajectory of an object in four-dimensional spacetime. As a individual, our world lines
                           always entangle with others' in our life. As shown in the picture below, Einstein's world line connects with
                           the student's even if they have not ever met each other."),
                         img(src = "worldline2.png",width=800, height=300,Position="right"),
                         p("An interesting property of world lines is that : even if some events on them have been changed,i.e., their paths have been altered,
                           as a whole, still, they may form the same space-time knot from the perspective of topology, namely, they would converge to the same end."),
                         img(src = "worldline3.png",width=800, height=300,Position="right"),
                         br(),
                         p("We apply",strong("Kauffman Knot Invariant Algorithm"),"to make clear whether those space-time knots formed by different world lines are the same or not. 
                        However, in practice, traditional computers are not able to solve such problems, because the complexity of computation increases exponentially and normal computers may take
                           several years or even decades to finish the computation. Our company by now is the only one who can solve it within seconds with 
                           our newly developed ",a(strong("Topological Quantum Computer"),href="https://en.wikipedia.org/wiki/Topological_quantum_computer"),". If you want to know whether your choice
                           would make a difference, whether your effort would lead you to the end you want, just come to us. We would observe the space-time knot made up of your and relevant world lines
                           , compare it with the world line you are aspiring for, and give you the answer as well as some advice."),
                         a(strong("To know more about topological quantum computer, Kauffman knot invariant algorithm, and world line."),href="https://www.youtube.com/watch?v=smX2lSyi2js&list=LLl0iGgbaPvfc8Xg5AlLEoig"),
                         p(" ")
                     ),
                     tabPanel(
                         "Time Travel (Forward)",
                         h1(strong("Theoretical Feasibility of Time Travel"),align="center",style="font-family: 'Arial';font-size: 16pt "),
                          p("As per general reletivity, gravitational field will distort time and space. This would give rise to a phenomenon
                            called",a(strong("Gravitational Time Dilation"),href="https://en.wikipedia.org/wiki/Gravitational_time_dilation"),". Put it in a simple way,
                            Clocks that are far from massive bodies (or at higher gravitational potentials) run more quickly,
                            and clocks close to massive bodies (or at lower gravitational potentials) run more slowly. As the most massive celestial
                            body in the universe, black holes can warp time and space so greatly that if people stay close with it even for 1 hour, hundreds of years may 
                            have passed in the earth."),
                         h1(strong("Our Time Travel"),align="center",style="font-family: 'Arial';font-size: 16pt "),
                         p("For customers enrolled in this business, our company would send them to the orbit of the black hole with our
                           latest developed spaceship. Those customers would stay at the orbit for 1 year, and when they come back, they will
                           arrive at the 100-year ahead future."),
                         img(src="blackhole.jpg",width=800,height=300),
                         p(" ")
                )
            )
        ),  
                navbarMenu(
                title = strong("Join Us"),
                tabPanel( "NTU MFE Short Cut",
                         fluidRow(
                             column(6,
                                    h1(strong("Collaboration with NTU MFE Program"),align="center",style="font-family: 'Arial';font-size: 16pt "),
                                    p("Mr. Wang Peng believes that graduates from NTU MFE program possess qualities our company is seeking for.
                                      If you are an participant in this program and looking for a position in our company, please e-mail your CV 
                                      to Mr. Wang Peng directly at", a("WangPeng@wptech.com"), " and he will hold a interview for you all in person.")
                             ),
                             column(6,
                                    img(src="NBS.png",width=600,height=300)
                                    )
                                )
                        ),
                tabPanel("General Recruitment",
                         fluidRow(
                             column(6,
                                    h1(strong("Recruitment Process"),align="center",style="font-family: 'Arial';font-size: 16pt "),
                                    p("Thanks for your interest in our company. Please send your CV and position to our HR department
                                      at", a("Recruitment@wptech.com"), " and we will reply you within 15 work days. In general,
                                      you may need to attend 5 round interviews before our final decision made. Good luck.")
                                    ),
                             column(6,
                                    img(src="tunnel.png",width=600,height=300)
                                    )
                                 )
                            )
                         ) 
                        )
                    )
            )

# Define the server
server <- function(input, output,session) {
    observeEvent(input$info1,{
        output$info11<-renderText("Headquartered in Shenzhen, China, we have more than 200
                                branches and 30000 scientists / engineers all over the world.")
         })
    observeEvent(input$info2,{
        output$info22<-renderText("We are carrying out researches in all popular fields, including
                                  space technology, bioscience, quantum computation, controllable 
                                  nuclear fusion, et cetera.")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
