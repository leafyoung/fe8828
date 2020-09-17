library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  fluidPage(
    titlePanel("British Pop Paradise"),
    "We offer the BEST british-pop live shows in the world!"
  ),
  navbarPage(title=" ",
             tabPanel("choose the band you like",
                      img(src="banner.jpg",height=200, width=600),
                      img(src="banner.jpg",height=200, width=600),
                      fluidRow(
               column(4,
                      wellPanel(titlePanel("1990s"),
                                "The 1990s was, in terms of British rock, chiefly remembered for being the decade that spawned Britpop. This, consequently, made it the most exciting era in British rock music since the punk explosion of the 1970s. However, the ’90s wasn’t just about Britpop, and, as can be seen in this list, British rock music was interesting on several fronts.")),
               column(4,
                      wellPanel(titlePanel("1980s"),
                                "The 1980s was a decade that was truly diverse, musically. From synth-influenced to indie music, rock bands had never been so eclectic, and here are 10 of the ’80s best."
                                )),
               column(4,
                      wellPanel(titlePanel("1970s"),
                                "From hard rock to punk, new wave, indie and Britpop, British bands have defined entire genres and influenced millions of rock fans over the years.The UK music scene has produced some of the world's most iconic bands and artists, whose work remains just as popular and revered to this day.From Joy Division to Radiohead, the Rolling Stones and the Beatles, these are the best British rock bands of all time."))
             )),
             tabPanel("1990s",
                      titlePanel("coldplay"),
                      img(src="coldplay-wembley-1.jpg",height=400, width=550),
                      a("live shows", href="https://www.youtube.com/watch?v=fRLcGUo-s6o")),
             tabPanel("1980s",
                      titlePanel("oasis"),
                      img(src="WechatIMG138.jpeg",height=400, width=600),
                      titlePanel("blur"),
                      img(src="blur.jpg",height=400,width=600),
                      titlePanel("suede"),
                      "every thing will flow."),
             tabPanel("1970s",
                      navlistPanel(
                        "QUEEN",
                        tabPanel("Singer",
                                 h1("Freddie Mercury"),
                                 p("Freddie Mercury was a British singer, songwriter, record producer, and lead vocalist of the rock band Queen. Regarded as one of the greatest lead singers in the history of rock music, he was known for his flamboyant stage persona and four-octave vocal range.")),
                        tabPanel("live shows",
                                 h1("1970-1971"),
                                 img(src="queen.jpg")),
                        "BEATLES",
                        tabPanel("Singer",
                                 h1("Lennon"),
                                 img(src="lennon.jpg"),
                                 h2("Paul"),
                                 img(src="paul.jpg",height=400, width=400))
                      )),
             navbarMenu(title="contact us",
                        tabPanel("Address","30 seconds to mars"),
                        tabPanel("Phone","+00000000")
             ))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

