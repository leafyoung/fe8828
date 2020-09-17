library(shiny)
library(shinythemes)

ui <- fluidPage(
    fluidPage(theme = shinytheme("superhero"),
        navbarPage(title = "Ultron+ Investment",
                   tabPanel("About Us",
                            h1("The Management Team",align="center"),
                            column(6,img(style="max-width:30%",height="150px",src="twq.jpg"),br(),strong("Tan Wang Quan"),br(),"CEO of Ultron+ Investment and a current student of NTU Masters in Financial Engineering."),
                            column(6,img(style="max-width:30%",height="150px",src="tony.jpg"),br(),strong("Tony Stark"),br(),"Stark is an industrialist, genius inventor, hero and former playboy who is CEO of Stark Industries"),
                           
                            column(6,img(style="max-width:30%",height="150px",src="BruceBanner.png"),br(),strong("Bruce Banner"),br(),"Dr. Banner is a renowned physicist who subjected himself to a gamma radiation experiment designed to replicate a World War II-era super soldier program.")
                            
                   ),
                   tabPanel("Product",
                            img(style="max-width:100%",src="jarvis.jpg"),
                            titlePanel(h1(strong(style="color:red","Grow Money Through Data, Not Emotions"))),
                                sidebarLayout(
                                    sidebarPanel(width=4,
                                          h2(style="font-size:25px","Introducing Ultron+"),
                                          "Ultron+ is an AI created by Tony Stark & Bruce Banner, and has recently learnt how to trade from Tan Wang Quan"
                                           
                                    ),
                                    mainPanel(width = 8,
                                              
                                              wellPanel(h3(tags$b("A focus on what matters")),
                                                        "Ultron+ monitors economic trends and valuations to make informed, intelligent management decisions for your investment portfolios. Focusing on solid economic fundamentals, Ultron+ don't bother reacting to short-sighted, sporadic market activity.
                                                         That, with an easy-to-use, flexible platform, you can finally have the investment experience you deserve."
                                                        ),
                                              wellPanel(h3(tags$b("More data, less guessing")),
                                                        "Our system determines the best asset allocation for your personal portfolios based on economic conditions, not on how the market is doing that day. When economic conditions change to a recession, for example, your portfolio's asset allocation automatically changes to maximize your returns and keep your risk level constant."
                                                        ),
                                              wellPanel(h3(tags$b("More diversification, less risk")),
                                                        "The portfolios we build have up to 32 differentiated and global asset classes, such as stocks from a variety of sectors from around the world, bonds issued by governments and corporations, and gold. This level of diversification protects you from sudden drops in any given asset class and prepares your investments for any economic environment."
                                                        )
                                              )
                                )
                            ),
                   
                   navbarMenu(title = "Contact Us",
                              tabPanel("Email us",h1(tags$b("Email Us"),style="color:lightblue"),
                                                  h2("wtan126@e.ntu.edu.sg"),
                                                  "Our goal is to reply within the same day. Sometimes, it may take us until the following business day to get back"),
                              tabPanel("Find us", 
                                         sidebarLayout(
                                           sidebarPanel = (img(style="max-width:60%",src="starktower.jpg")),
                                           mainPanel(
                                             h1("Stark Tower"),h2("Manhattan New York City")
                                           )
                                         )
                                       ),
                              tabPanel("Call us", h1(tags$b("Call Us"),style="color:lightblue"),
                                                  h2("+65 6889 8178"),
                                                  "Mon-Fri 9:00 AM-6:00 PM (excluding public holidays)"
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