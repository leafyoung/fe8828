library(shiny)

ui <- fluidPage(
    
    fluidPage(
        navbarPage(title = "Disney",
                   tabPanel("DISNEY+", 
                            titlePanel("MARVEL STUDIOS"),
                            tags$img(src = "disney_logo.png", width = "10%"),
                            h1("Wanda Vision"),
                            h2("Welcome to WandaVision.Coming soon to Disney+."),
                            img(src="wanda.png",width="100%"),

                            fluidRow(
                                column(3,
                                       wellPanel(h3("Magic is here"),
                                                 tags$p("All 4 Walt Disney World theme parks and Disney Springs are now open"),
                                                 tags$img(src="magic.png",width="100%")

                                       )),

                                column(3,
                                       wellPanel(h3("The Mandalorian"),
                                                 tags$p("New Season Streaming October 30"),
                                                 tags$img(src="mandalorian.png",width="100%")
                                       )),
                                column(3,
                                       wellPanel(h3("shopDisney"),
                                                 tags$p("30% Off Costumes and Costume Accessories"),
                                                 tags$img(src="shopDisney.png",width="100%")
                                       )),
                                column(3,
                                       wellPanel(h3("Mulan"),
                                                 tags$p("Stream Disney's Mulan Exclusively on Disney+ with Premier Access"),
                                                 tags$img(src="Mulan.png",width="100%")
                                       ))  
                            )
                   ),
                   tabPanel("SHOP",
                            titlePanel("ShopDisney"),
                            "Sign In|Sign Up",
                            navbarPage(
                                tabPanel("HALLOWEEN"),
                                tabPanel("GIFTS"),
                                tabPanel("TOYS"),
                                tabPanel("CLOTHING"),
                                tabPanel("ACCESSORIES"),
                                tabPanel("HOME"),
                                tabPanel("PARKS"),
                                textInput("Search", "SEARCH")
                            ),
                            img(src = "shop.png", width = "100%")
                            ),
                   tabPanel("PARKS&TRAVEL",
                            titlePanel("DisneyParks"),
                            textInput("Search", "SEARCH"),
                            img(src="DisneyParksLogo.png",width="10%"),
                            navbarPage(
                                tabPanel("Parks&Destinations"),
                                tabPanel("What's New"),
                                tabPanel("Special Offers"),
                                tabPanel("Vacation Planning")
                                
                            ),
                            img(src = "parks.png", width = "100%")
                   ),
                   tabPanel("MOVIES",
                            img(src="movies.png",width="100%"),
                            fluidRow(
                                column(6,
                                       wellPanel(h3("The Mandalorian"),
                                                 tags$img(src="movie1.png",width="100%"),
                                                 tags$p("The new season of the Emmy?? Award-nominated Disney+ Original is almost here. Watch the explosive trailer now and get ready to return to a galaxy far, far away. Streaming from 30 October.")
                                                 
                                                 
                                       )),
                                
                                column(6,
                                       wellPanel(h3("Everything coming to Disney+ in October"),
                                                 tags$img(src="movie2.png",width="100%"),
                                                 tags$p("A new month means new content on Disney+. Here are our top picks for October.")
                                                 
                                       )),
                            )
                            
                            ),
                   navbarMenu(title = "PARKS",
                              tabPanel("Disneyland@Paris", dateInput("date","Pick your date"),sliderInput("Adult","number of adults",0,10,1),
                                       sliderInput("children","number of children",0,10,1),selectInput("Hotel","Hotel","Disneyland hotel","Partner hotels")
                                       ),
                              tabPanel("Walt Disney World in Florida", submitButton("Get details"),submitButton("Theme park reservations")),
                              tabPanel("Disney Cruise Line", "Discover Disney Cruise Line",img(src="cruise.png",width="100%"))
                   )
        ),
        a("website for reference",href="https://www.disney.com/")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
