#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI 
ui <- fluidPage(
   
   #Nav Bar Layout
  navbarPage(title = "InVictus",
             tabPanel("Product",
                      tags$img(src = "Img1.jpg", width = "100%", height = "50%"),
                      hr(),
                      fluidRow(
                        column(12,h2(tags$b("Powerful Design and Prototyping Tools")),
                               fluidRow(
                                 column(6,tags$br(),
                                        wellPanel(
                                 h4("Get high-fidelity in under 5 minutes. Upload your design files and add animations, gestures, and transitions to transform your static screens into clickable, interactive prototypes."),
                                 tags$br(),
                                 tags$br()
                                 )
                                 ),
                                 column(6,
                                 tags$img(src = "Img2.JPG",width = "100%")                                      
                                 )
                               )
                                 ),
                        hr(),
                        column(12,h2(tags$b("Reimagined Design Ideation and Presentation")),
                               fluidRow(
                                 column(6,
                                        tags$img(src = "Img3.JPG",width = "100%")                                      
                                 ),
                                 column(6,tags$br(), 
                                        wellPanel(
                                          h4("Create context around your projects with Boards-flexible spaces to store, share, and talk about design ideas. Built-in layout options allow you to create visual hierarchy for your ideas."),
                                          tags$br(),
                                          tags$br()
                                          )
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("Seamless Design Communication")),
                               fluidRow(
                                 column(6,tags$br(),
                                        wellPanel(
                                          h4("Simplify your feedback process by having clients, team members, and stakeholders comment directly on your designs. See new feedback for all your projects in one convenient place, or drill down by active project, specific people, or your own name."),
                                          tags$br(),
                                          tags$br()  
                                        )
                                 ),
                                 column(6,
                                        tags$img(src = "Img4.JPG",width = "100%")                                      
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("A Magical New Design To Development Workflow")),
                               fluidRow(
                                 column(6,
                                        tags$img(src = "Img5.JPG",width = "100%")                                      
                                 ),
                                 column(6, tags$br(),
                                        wellPanel(
                                          h4("Create stylesheets, get pixel-perfect comps, discuss design challenges, export adaptively, and generate real code for any design element."),
                                          tags$br(),
                                          tags$br() 
                                        )
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("Creative Collaboration For Your Entire Team")),
                               fluidRow(
                                 column(6,tags$br(),
                                        wellPanel(
                                        h4("When you need to bring your team together to collaborate on a project, turn to Freehand to sketch, draw, wireframe, share feedback, present designs, and so much more-all in real time."),
                                        tags$br(),
                                        tags$br()
                                        )
                                 ),
                                 column(6,
                                        tags$img(src = "Img6.JPG",width = "100%")                                      
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("Design-driven Project Management")),
                               fluidRow(
                                 column(6,
                                        tags$img(src = "Img7.JPG",width = "100%")                                      
                                 ),
                                 column(6,tags$br(), 
                                        wellPanel(
                                          h4("Manage your project screens and statuses from one single location, quickly see unread comments, preview screens, and notify team members when changes to screen status are made."),
                                          tags$br(),
                                          tags$br()
                                        )
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("Real-time Design Collaboration and Tours")),
                               fluidRow(
                                 column(6,tags$br(),
                                        wellPanel(
                                          h4("Design better, faster, and more collaboratively with real-time, in-browser design collaboration and presentation tools. Seamlessly launch meetings, create guided tours, and present designs to stakeholders."),
                                          tags$br(),
                                          tags$br()
                                        )
                                 ),
                                 column(6,
                                        tags$img(src = "Img8.JPG",width = "100%")                                      
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("Free, Unlimited Feedback on Prototypes")),
                               fluidRow(
                                 column(6,
                                        tags$img(src = "Img9.JPG",width = "100%")                                      
                                 ),
                                 column(6, tags$br(),
                                        wellPanel(
                                          h4("Test your web and mobile product designs, and quickly incorporate user feedback. Hear what real users have to say-and see them interact with your prototype-with live video and audio recordings."),
                                          tags$br(),
                                          tags$br()
                                        )
                                 )
                               )
                        ),
                        hr(),
                        column(12,h2(tags$b("Connected where the Action is")),
                               fluidRow(
                                 column(6,tags$br(),
                                        wellPanel(
                                          h4("Your team is most productive when your entire design workflow is in one place from start to finish. Our integrations automatically push and pull activity from your favorite systems straight into InVictus."),
                                          tags$br(),
                                          tags$br()
                                        )
                                 ),
                                 column(6,
                                        tags$img(src = "Img10.JPG",width = "100%")                                      
                                 )
                               )
                        )
                      )
                    ),
             
             tabPanel("About Us", 
                      tags$img(src = "Img1_2.jpg",width = "100%"),
                      hr(),
                        navlistPanel("About Us",
                                     tabPanel("Who We Are",
                                              tags$ul(h3(align = "center",tags$b("Who We Are")),
                                             "InVictus was founded in 2017, with the goal to help advance this trend and to give product designers and their teams everything they need to create incredible customer experiences. We've dedicated ourselves to closing the gap between the tools available to designers and the work they are tasked with doing."
                                             )
                                     ),
                                  tabPanel("Our Mission",
                                           h3(align="center",tags$b("Our Mission")),h3(align = "center",em("The Digital Product design platform powering the world's best user experiences")),
                                  "We believe the screen is the most important place in the world. That's why we are dedicated to helping you deliver the best possible digital product experience, with our platform and best practices from your peers.
                                  With intuitive tools for ideation, design, prototyping, and design management, the InVictus platform will give you everything you need for digital product design, all in one place. We aim to provide you with a suite of
                                  services that will help boost your user experiences."
                                  ),
                                  tabPanel("Our Core Values",
                                           h3(align = "center",tags$b("Our Core Values")),
                                          tags$li(em("Question Assumptions:"), "True innovation and problem solving call us to question everything, even our own bias."),
                                          tags$li(em("Think Deeply:"), "Good design thinking considers the task at hand as well as all the surrounding systems."),
                                          tags$li(em("Iterate as a Lifestyle:"), "We push for perfection, but never at the expense of progress."),
                                          tags$li(em("Details, Details:"), "Whether you're working with pixels or code, details will make the difference."),
                                          tags$li(em("Design is Everywhere:"), "Everything in our life is designed and is the driving force behind business and culture."),
                                          tags$li(em("Integrity:"), "Say what you mean, mean what you say. Work hard regardless of who is or isn't watching.")
                                  )
                      )
             ),
             navbarMenu(title = "Contact Us",
                        tabPanel("Address",
                                 tags$img(src = "Img1_3.jpg",width = "100%"),
                                 hr(),
                                 align = "center",h3("We are located at:"), h4(p("InVictus"), p("BLOCK71"), p("71 Ayer Rajah Crescent #02-01"), p("Singapore 139 951")),
                                 tags$img(src = "Map.jpg",width = "100%")),
                        tabPanel("Phone",
                                 tags$img(src = "Img1_3.jpg",width = "100%"),
                                 hr(),
                                 align = "center",h3("Contact Number"),h4("If you are interested in our services, you may contact us at: +123 456 789."),
                                 h4("Alternatively, you may leave us a message below."),
                                 wellPanel(h4("Get In Touch"),h5("We're here for you, and we're wearing our thinking caps. Feel free to reach out to us for all your InVictus product and technical needs!"),
                                           textInput("name","Name:"),textInput("email","Email Address:"),textInput("msg","Message:"),actionButton("sendButton","SEND IT!")))
                        )
    
  )
)

# Define server logic 
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

