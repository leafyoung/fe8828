library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidPage(
        navbarPage(title = "Climax Music",
                   tabPanel("About us",
                            fluidPage(
                              fluidRow(column(12,img(src = "Live-Music.jpg", width = "100%"))),
                              hr(),
                              fluidRow(column(4,
                                              wellPanel(h2("What we do"),
                                                 p("Climax Music is a Global entertainment company established in 2019 by XXX. 
                                                 The company operates as a record label, talent agency, music production company, event management and concert production company, and music publishing house. 
                                                 In addition, the company operates a number of subsidiary ventures under a separate public traded company, which includes a clothing line, a golf management agency, and a cosmetics brand.
                                                 Current artists include..."))
                                      ),
                                       column(4, 
                                              wellPanel(h2("Leadership"),
                                                 p("Climax Music is a Global entertainment company established in 2019 by XXX. 
                                                 The company operates as a record label, talent agency, music production company, event management and concert production company, and music publishing house. 
                                                 In addition, the company operates a number of subsidiary ventures under a separate public traded company, which includes a clothing line, a golf management agency, and a cosmetics brand.
                                                 Current artists include..."))
                                      ),
                                      column(4, 
                                             wellPanel(h2("News"),
                                                       p("Climax Music is a Global entertainment company established in 2019 by XXX. 
                                                 The company operates as a record label, talent agency, music production company, event management and concert production company, and music publishing house. 
                                                 In addition, the company operates a number of subsidiary ventures under a separate public traded company, which includes a clothing line, a golf management agency, and a cosmetics brand.
                                                 Current artists include..."))
                                )
                              )
                            )
                   ),
                   navbarMenu(title = "Artists",
                              tabPanel("Singers", 
                                  fluidPage(
                                     titlePanel("Singers"),
                                     navlistPanel(
                                       "Solo",
                                       tabPanel("Female",
                                                fluidRow(
                                                  column(3,img(src = "female.jpg", width = "100%"),
                                                         a("Anna", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "female.jpg", width = "100%"),
                                                         a("Alice", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "female.jpg", width = "100%"),
                                                         a("Angela", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "female.jpg", width = "100%"),
                                                         a("Alexander", href="http://www.google.com")
                                                  )
                                                )),
                                       tabPanel("Male",
                                                fluidRow(
                                                  column(3,img(src = "male.jpg", width = "100%"),
                                                         a("Mark", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "male.jpg", width = "100%"),
                                                         a("Jack", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "male.jpg", width = "100%"),
                                                         a("Kris", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "male.jpg", width = "100%"),
                                                         a("Bill", href="http://www.google.com")
                                                  )
                                                )),
                                       "Band",
                                       tabPanel("Girl Groups",
                                                fluidRow(
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Rose", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Lavender", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Violet", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Lotus", href="http://www.google.com")
                                                  )
                                                )),
                                       tabPanel("Boy Groups",
                                                fluidRow(
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Gin", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Vodka", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Tequila", href="http://www.google.com")
                                                  ),
                                                  column(3,img(src = "band.png", width = "100%"),
                                                         a("Rum", href="http://www.google.com")
                                                  )
                                                ))
                                     )
                                  )  
                              ),
                              tabPanel("Actors",
                                       fluidPage(
                                         titlePanel("Actors"),
                                         navlistPanel(
                                           tabPanel("Actors",
                                                    h1("Actors"),
                                                    p("This is section 1. First lecture in FE8828.")),
                                           tabPanel("Actresses",
                                                    h1("Actresses"))
                                         )
                                       )  
                                       
                              )
                   ),
                   tabPanel("Contact Us",
                        fluidPage(
                            titlePanel("Contacts"),
                            sidebarLayout(
                                position = "right",
                                sidebarPanel(
                                    h3("Our Office"),
                                    p("Nanyang Business School"),
                                    p("Block S3, 50 Nanyang Avenue"),
                                    p("Nanyang Technological University"),
                                    p("Singapore 639798"),
                                    h3("TEL"),
                                    p("(65) 8888 8888"),
                                    h3("Email"),
                                    a("contacts@climaxmusic.com"),
                                    h3("Website"),
                                    a("http://www.climaxmusic.com"),
                                    h3("More info"),
                                    p("If you have more questions, please take a look at Q&A."),
                                    actionButton("q&a", "Q&A")
                                ),
                                mainPanel(
                                    img(src = "location.png", width = "90%")
                                )
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
