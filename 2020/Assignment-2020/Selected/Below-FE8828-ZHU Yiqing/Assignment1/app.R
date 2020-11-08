#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram

h1_style <-"font-family: 'times'; font-size: 32pt "
p_style <- "font-family: 'arial'; font-size: 14pt "
ui <- fluidPage(
    fluidPage(
        titlePanel("Welcome to CareerForYOU!"),
        navlistPanel(
            "Who we are",
            tabPanel("Professional Consultants",
                     h1("We Have Professional Consultants", align = 'center', style =h1_style),
                     p("We have professional consultants with of great insight into your career,
                       giving you detailed tutorship on career development", 
                       style = p_style)),
            tabPanel("Your Alumni",
                     h1("We Have Alumni Knowing Much About the University", align = 'center', style =h1_style),
                     p("We invite alumni graduating from NTU, NUS and other world-known universities, 
                       giving you most accurate information about your university.", 
                       style = p_style)),
            
            "What do we provide?",
            tabPanel("Our Mission",
                     h1("Our Mission", align = 'center', style = h1_style),
                     p("We give guidance to undergraduate students, 
                     teaching them what they should prepare for finding an ideal job. ",
                     style = p_style),
                     p("We enlight students on career choice suitable for their ability.",
                       style = p_style)),
            tabPanel("Our Service",
                     h1("Our Service", align = 'center', style ="font-family: 'times'; font-size: 32pt "),
                     p("Job Counselling for Students",
                       style = p_style),
                     p("University Preparation",
                       style = p_style),
                     p("Internship and Job Oppotunities Posting",
                       style = p_style),
                     p("Interview Experience Sharing",
                       style = p_style),
                     p("Career Path Design and Guidance",
                       style = p_style),),
            "Why our guidance is beneficial?",
            tabPanel("Know about Yourself",
                     h1("Know about Yourself", align = "center", style=h1_style),
                     p("As a newcomer to university life, do you know much about your own strength?",
                       style = p_style),
                     p("We can test your strength, your interest and your personality.
                       We can let you know yourself better and choose career more sensibily.",
                       style=p_style)),
            tabPanel("Know about Career",
                     h1("Know about Career", align = "center", style=h1_style),
                     p("As a newcomer to society, do you know the outlook of your dreaming jobs?",
                       style = p_style),
                     p("We can guide you the salary, working load and development path of your dreaming job.
                       We can let you be well prepared for future!",
                       style=p_style))
        )
    ),
    fluidPage(
        titlePanel("Our Story Sharing"),
        img(src="Sharing.jpg", align = "right",height='400px',width='400px'),
        hr(),
        sidebarLayout(position = "left",
            sidebarPanel(
                h1("Story From Alice"),
                wellPanel(
                    h2("Alice-a graduate from NTU", align = "center", style=h1_style),
                    p("Here is the story from Alice.
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX", style = p_style)
                ),
                h1("Story From Ben"),
                wellPanel(
                    h2("Ben-a 10-year experience Software Development Engineering", align = "center", style=h1_style),
                    p("Here is the story from Ben.
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXX", style = p_style))
            ),
            mainPanel(
            )
        )
    ),
    fluidPage(
        titlePanel("Contact us!"),
        navbarPage(title = "CareerForYou",
                   tabPanel("Address",
                            titlePanel("Address"),
                            "XXXXXXXXXX",
                            p("Singapore, Singapore", style =p_style)),
                   tabPanel("Join us!",
                            fluidPage(titlePanel("Join us!"),
                                      "career@careerforyou.com"))
                   ,
                   navbarMenu(title = "Contact Us",
                              tabPanel("Email for Service", "service@careerforyou.com"),
                              tabPanel("Phone", "+XXXXXXX")
                   )
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
