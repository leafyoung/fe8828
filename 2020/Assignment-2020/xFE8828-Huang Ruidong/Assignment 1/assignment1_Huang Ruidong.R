library(shiny)

ui <- fluidPage(
  fluidPage(
    navbarPage(title = "Lakers",
               tabPanel("News", 
                        titlePanel("2020-09-21"),
                        h1("Mamba moment!"),
                        tags$img(src = "C:/Users/Administrator/Desktop/news.jpg", width = "100%"),
                        
                        navlistPanel(
                          
                          tabPanel("Mamba shot", 
                                   h1("Mamba shot"),
                                   p("Davis: 'We'll celebrate it for a couple hours. The job is not over until we're able to win the ring.'")),
                          
                          tabPanel("Game 2 Victory",
                                   h1("Game 2 Victory"),
                                   p("Lakers Nation, give it up for Anthony Marshon Davis Jr.31 pts, 9 reb and the big fella¡¯s game-winning three to give the Lakers a 105-103 victory over Denver. The guys are now 3-0 in their Kobe City Edition Uniforms.")),
                         
                          tabPanel("All-NBA First Team",
                                   h1("All-NBA First Team"),
                                   p("Los Angeles Lakers forwards LeBron James and Anthony Davis have been named to the All-NBA First Team, it was announced today. It marks the 13th time the Lakers have had multiple First Team selections, a first since Kobe Bryant and Shaquille O¡¯Neal following the 2003-04 season.")
                        
                        )))
               ,
               tabPanel("Stats",
                        fluidPage(sidebarLayout(
                        sidebarPanel("Pts"),
                        mainPanel("Anthony-Davis 31Pts")
                        )),
                        fluidPage(sidebarLayout(
                          sidebarPanel("Reb"),
                          mainPanel("LeBron-James 11Reb")
                        )),
               
                        fluidPage(sidebarLayout(
                           sidebarPanel("Ast"),
                           mainPanel("Rajon-Rondo 9Ast")
                         )))
              ,
               tabPanel("Schedule",
                        navlistPanel(
                          
                          tabPanel("Upcoming Games", 
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Sep 22, 6PM"),
                                     mainPanel("Denver Nuggets")
                                   )),
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Sep 24, 6PM"),
                                     mainPanel("Denver Nuggets")
                                   ))),
                          
                          tabPanel("Past Games",
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Sep 18, 6PM"),
                                     mainPanel("Denver Nuggets","W126-114")
                                   )),
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Sep 20, 4:30PM"),
                                     mainPanel("Denver Nuggets","W 105-103")
                                   )))
                          
                          
                          )
                        
                        
                        
                        
                        ),
               navbarMenu(title = "Contact",
                          tabPanel("Mobile App", "The Lakers Mobile App, Powered by Wish. Real-time stats, in-depth articles, highlights and more.",a("Download", href="https://play.google.com/store/apps/details?id=com.lucidappeal.appmold&feature=search_result#?t=W251bGwsMSwxLDEsImNvbS5sdWNpZGFwcGVhbC5hcHBtb2xkIl0")),
                          tabPanel("Phone", "(310) 426-6000"),
                          tabPanel("Address", "1111 S. Figueroa St. Los Angeles, CA 90015")
               )
               )
    
  )
)
    




# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


