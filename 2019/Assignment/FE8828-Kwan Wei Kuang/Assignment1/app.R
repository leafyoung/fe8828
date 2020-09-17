library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$img(src="hatobakes.jpg"),
  titlePanel("Welcome to HatoBakes!"),
  fluidPage(
    navbarPage(title = "Everything made in school or my humble kitchen",
               tabPanel("Product",
                        titlePanel("Food, deserts, pastry..."),
                        h4("Yum Yum!"),
                        br(),
                        sidebarLayout(
                          sidebarPanel(
                            titlePanel("My latest products!"),
                            width = 3,
                            wellPanel(
                              tabsetPanel(
                                tabPanel("Chocolate",
                                         br(),
                                         h4("No one will say 'no' to Cocoa..."),
                                         br(),
                                         h5("Item 1: Chocolate Bonbons..."),
                                         br(),
                                         h5("Item 2: Nougat..."),
                                         br(),
                                         h5("Item 3: Easter Egg..."),
                                         br(),
                                         h5("Item 4: Weetbix Slice..."),
                                         br(),
                                         h5("Item 5: Bomboniere....")
                                
                                ),
                                tabPanel("Sugar Showpiece",
                                         br(),
                                         h4("Sugar Sculpture? Interesting..."),
                                         br(),
                                         h5("Item 6: Sugar Showpiece...
                                            Probably my worst day in the kitchen, pretty sure I'm not gonna forget this day. Broke my piece and the roses which 
                                            we did from 2 days of mise en place.. Had to piece together whatever that was left, picked myself up to finish with this...")
                                ),
                                tabPanel("Cakes",
                                         br(),
                                         h4("What makes a good cake? You may ask..."),
                                         br(),
                                         h5("Item 7: Celebration Cake"),
                                         br(),
                                         h5("Item 8: Vacherin... Layers of vanilla ice cream and raspberry sorbet, sandwiched between meringue disks. 
                                            And to top it off, piped raspberry chantilly cream for a little more tartness."),
                                         br(),
                                         h5("Item 9: Bombe Alaska... Perfect dessert if I was back on my sunny island.")
                                )
                              )
                            )
                          ),
                          mainPanel(
                            tags$img(src="Product1.jpg", width = "33%"),
                            tags$img(src="Product2.jpg", width = "33%"),
                            tags$img(src="Product3.jpg", width = "33%"),
                            tags$img(src="Product4.jpg", width = "33%"),
                            tags$img(src="Product5.jpg", width = "33%"),
                            tags$img(src="Product6.jpg", width = "33%"),
                            tags$img(src="Product7.jpg", width = "33%"),
                            tags$img(src="Product8.jpg", width = "33%"),
                            tags$img(src="Product9.jpg", width = "33%"),
                            width = 9
                          )
                        )
               ),
               tabPanel("About Us",
                        fluidRow(
                          column(6, offset=0.5,
                                 titlePanel("About us"),
                                 tags$img(src="aboutus.jpg"),
                                 tags$img(src="aboutus2.jpg")
                          ),
                          column(6, 
                                 br(),
                                 br(),
                                 h3("Hi There!"),
                                 p("I am currently a Le Cordon Bleu NZ Patisserie."),
                                 p("From Singapore..."), 
                                 p("Currently located in  Wellington..."),
                                 p("Like the cookie monster, one of my fav food is cookies :)"),
                                 p("Baking is my passion and here is where i share my creations with you"),
                                 tags$ul(h3("So why baking?"),
                                         tags$li("Never say no to Great food!"),
                                         tags$li("Plus it's Fun!"),
                                         tags$li("And Enjoyable!")),
                                 p("You may follow me in my baking journey at:", a("Instagram: hato.bakes",href="https://www.instagram.com/hato.bakes/?hl=en"))
                          )
                        )
               ),
               tabPanel("Journey",
                        titlePanel("Our Progress"),
                        navlistPanel(
                          "When We First Started",
                          tabPanel("First Cake!",
                                   h3("Totoro Cake!~"),
                                   p("Chocolate Earl Grey Cake with Nutella Feuilletine base - dressed up as Totoro."),
                                   tags$img(src="Product10.jpg")
                          ),
                          tabPanel("First Jar of Cookie!",
                                   h3("Butter Cookie!~"),
                                   p("Speculoos butter cookies. Cookies are meant to be kept in glass jars. I can't agree more."),
                                   tags$img(src="Product11.jpg")
                          ),
                          "Le Cordon Bleu NZ @ Wellington",
                          tabPanel("Our Products",
                                   h4("It's ... Cookies Time!"),
                                   tags$img(src="Product12.jpg"),
                                   h4("Layers of hazelnut dacquiose sandwiched in between classic Italian Meringue Buttercream. The latter infused with hazelnut praline.
                                      Homemade praline paste isn't as difficult as you think. Trust me!"),
                                   tags$img(src="Product13.jpg"),
                                   h4("Pistachio Macaron with Lemon diplomat cream."),
                                   tags$img(src="Product14.jpg")
                          ), 
                          "-----"
                        )
               ),
               navbarMenu(title = "Contact Us",
                          tabPanel("Address", 
                                   h4("Our humble kitchen: 25 Jalan Kemuning, Singapore 769852."),
                                   tags$img(src="kitchen.jpg")
                          ),
                          tabPanel("Phone",
                                   h4("You may contact us at:"),
                                   tags$ol(
                                           tags$li("+65 9326 8965"),
                                           tags$li("+65 9115 5235")
                                   ),
                                   tags$img(src="contactus.jpg")
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

