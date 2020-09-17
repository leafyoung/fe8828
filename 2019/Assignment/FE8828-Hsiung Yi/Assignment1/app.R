#Sources of words information are mainly from Bridgewater and Point72
#Sources of pictures are mainly from Google

library(shiny)
ui <- fluidPage(
    fluidPage(
        navbarPage(title = "HWCapital",
                   tabPanel("Our Story",
                            h1("Our Mission"),
                            "To be the industry's premier asset management firm through delivering
                            superior risk-adjusted returns, adhering to the highest ethical standards 
                            and offering the greatest opportunities to the industry's brightest talent.",
                   img(src = "Mission.jpg", width = "720px"),
                   
                   sidebarLayout(
                       position = "left",
                       sidebarPanel(h1("Culture")),
                       mainPanel("Our unique success is the direct result of our unique way of being.
                                 We want an idea meritocracy in which meaningful work and meaningful
                                 relationships are pursued through radical truth and radical transparency.
                                 We require people to be extremely open, air disagreements, test each other's
                                 logic, and view discovering mistakes and weaknesses as a good thing that 
                                 leads to improvement and innovation.")),
                   sidebarLayout(
                       position = "left",
                       sidebarPanel(h1("Principles")),
                       mainPanel("We are both idealistic and practical. We believe that creating excellent
                                 outcomes requires setting ambitious goals and applying our understanding
                                 of how the world works, as reflected in principles, to achieve them.
                                 Our Principles are ways of dealing with situations. They are not just read and 
                                 followed, but stress-tested on an individual and collective level as our shared
                                 approach to working together."))
                   ),
                   
                   tabPanel("Technology & Innovation",
                            navlistPanel(
                                "Technology",
                                tabPanel("Understand The World",
                                         h1("Using Systems To Understand The World"),
                                         p("Our philosophy is that the world can be understood.
                                           We strive to build a fundamental, cause-and-effect understanding
                                           in everything we do - be it how global economies and markets work or
                                           how people think and make decisions differently."),
                                         p("Technologists advance this mission, collaborating with our 
                                           researchers and managers to conceive, design, and run platforms
                                           that enable sysyemization and scale in all our domains."),
                                         img(src = "System.jpg", width = "480px")),
                                
                                
                                tabPanel("Work We Do",
                                         h1("The Work We Do"),
                                         p("We create platforms that let us develop a fundamental cause-and-effect
                                           understanding, test it, and apply that understanding systematically. 
                                           This requires unique approaches to data aggregation, ultra-fast execution of
                                           complex analytics, insightful visualizations, and innovative platforms to
                                           represent and manipulate logic."),
                                          p("As technologists, we make it all real. We are full-stack engineers, reponsible 
                                           from the problem-solving phase all the way to the shipping of solutions. 
                                           Together with HWCapital's managers and investment professionals, 
                                           we push the boundaries of what's possible."),
                                          img(src = "Work.jpg", width = "480px")),
                            
                                "How We Work Together",
                                tabPanel("Software Engineering",
                                         h1("Software Engineering"),
                                         p("Design and engineer the softeare that runs our company.
                                           Implement full-stack solutions that advance our core goal of 
                                           understanding how the worlds works."),
                                         img(src = "Software-engineering.jpg", width = "480px")),
                                
                                tabPanel("Product Management",
                                         h1("Product Management"),
                                         p("Shape business needs and opportunities into technology products.
                                           Envision what the technology should be, construct the roadmap, and 
                                           enable our users."),
                                         img(src = "Product-management.jpg", width = "480px")),
                                
                                tabPanel("Systems",
                                         h1("Systems"),
                                         p("Desgin, buildm and improve the platforms that are the bedrock of our software."),
                                         img(src = "Systems.jpg", width = "480px")),
                                
                                tabPanel("Infrastructure",
                                         h1("Infrastructure"),
                                         p("Design, engineer, and run our physical and virtual infrastructure.
                                           Be responsible for platforms that manage petabytes of data and run petaflops of operations."),
                                         img(src = "Infrastructure.jpg", width = "480px")),
                                
                                tabPanel("Data Science",
                                         h1("Data Science"),
                                         p("Extract knowledge and insights from big sata sets. Develop analytics to
                                           make meaning from our data."),
                                         img(src = "data-science.jpeg", width = "480px"))
                                ),
                                navbarMenu(title = "2019 HWCapital Associates. All Rights Reserved")
                            ),
                   
                   tabPanel("Careers & Community",
                            fluidRow(
                                column(4,
                                       h3("Careers"),
                                       p("It takes all types to make HWCapital great. If you're someone who enjoys
                                         creating innovative ways to reach ambitious goals, who is open to and 
                                         energized by receiving honest feedback, and who likes asking and being 
                                         asked 'why?'-- then we should talk."),
                                       p("We don't just look for people who can 
                                         do a particular job. We look for people we want to share our lives with.")),
                            
                                column(8,
                                       wellPanel(
                                       h3("Learn what it's like to work here"),
                                       fluidRow(
                                         column(6,
                                         wellPanel(
                                             h4("What is HWCapital?"),
                                             p("HWCapital is a community of people who are driven to achieve excellence on their
                                               work and their relationships through radical truth and radical transparency."),
                                             p("For these years, we have produced a unique track record of performance that is the
                                               result of having great people operating in our unique culture. Since our future
                                               depends on continuing to attract great people, we have created this experience to 
                                               introduce you to our approach."))),
                                         
                                         column(6,
                                                wellPanel(
                                                    h4("Contact us"),
                                                    p("Address : Nanyang Technological University Graduate Hall 1"),
                                                    p("Phone : +65 0000 0000"),
                                                    p("Email : yhsiung001@e.ntu.edu.sg"),
                                                    p("Other : You can find me in the library everyday!"),
                                                    img(src = "Contact.jpg", width = "240px")))

                                       )))                                       

)))))
# Define server logic required to draw a histogram
server <- function(input, output) {
}
# Run the application
shinyApp(ui = ui, server = server)