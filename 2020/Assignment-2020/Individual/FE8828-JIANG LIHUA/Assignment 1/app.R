library(shiny)

ui <- fluidPage(
    titlePanel("Tennis Gardon"),
    navbarPage(title = "Welcome to Tennis World",
               tabPanel("About us", #sidebar layout
                        fluidPage(sidebarLayout(
                            sidebarPanel(h4("Why we are found")),
                            mainPanel(
                              p("This is a website designed for all tennis-lovers. The reason why we build this company is that we want to provide more convenient website for tennis-lovers to learn about tennis and buy relative products.")
                              )
                        ))),
               tabPanel("Product",#navlist
                        fluidPage(
                            titlePanel("What we provide"),
                            navlistPanel(
                                "Balls",
                                tabPanel("Wilson", 
                                         h1("Wilson"),
                                         p("While they may look similar, it’s important to note: not all tennis balls are created equal! Wilson tennis balls are designed, engineered, and produced with the player in mind, utilizing premium materials and hours upon hours of development and testing to make sure that each tennis ball performs just right."),
                                         p("Wilson tennis balls can be found on tennis courts all over the world, ranging from the hardcourts of the US Open, to the red clay of Roland Garros, to club and junior courts everywhere. No matter what kind of tennis ball you are after, Wilson has the right one for you.")),
                                tabPanel("Teloon",
                                         h1("Teloon"),
                                         p("Tennis balls from Teloon are designed for people in different ages and different levels"),
                                         a("Please refer to website of Teloon",href="https://www.teloon.com.sg/"),
                                ),
                                "Rackets",
                                tabPanel("Yonex",
                                         h1("Yonex"),
                                         p("The newest one is Yonex REGNA Racquet: Launched exclusively in Japan in 2014, the Yonex REGNA series is now available at Tennis Warehouse (in very limited quantities). In addition to their sweetspot expanding ISOMETRIC head shapes, REGNA racquets have been meticulously engineered to flex optimally at impact.")),
                                tabPanel("Wilson",
                                         h1("Wilson"),
                                         tags$ol("Wilson's rackets",
                                                 tags$li("Wilson Pro Staff Tennis Racquets"),
                                                 tags$li("Wilson Blade Tennis Racquets"))
                                         )
                            )
                        ))
               ,
               tabPanel("Spokesperson",#coloumn
                        fluidPage(
                            titlePanel("Who are speaking for us?"),
                            fluidRow(
                                column(4,
                                       h2("Petra Kvitova"),
                                       p("She has single titles in Wimbledon Championships in 2011 and in 2014.")
                                ),
                                column(4,
                                       h2("Stan Wawrinka"),
                                       p("He reached a career-high Association of Tennis Professionals (ATP) world No. 3 singles ranking for the first time on 27 January 2014.[3] His career highlights include three Grand Slam titles at the 2014 Australian Open, 2015 French Open and 2016 US Open.")
                                ),
                                column(4, 
                                       h2("Angelique Kerber"),
                                       p("A continually high-ranking left-handed female tennis player, Kerber has won 12 career singles titles across all surfaces on the WTA Tour, including multiple Grand Slam titles: the 2016 Australian Open, the 2016 US Open and the 2018 Wimbledon Championships.")
                                )
                            )
                        ) 
               ),
               navbarMenu(title = "Contact Us",
                          tabPanel("Address", "No.233, Tennis Road, Singapore"),
                          tabPanel("Phone", "+65 88762344")
               )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

