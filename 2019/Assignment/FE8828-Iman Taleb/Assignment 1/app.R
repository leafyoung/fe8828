library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  fluidPage(
    navbarPage(title="Arabian Nights",
               
                      tabPanel("Home",
                               img(src = "palace.jpg",width="100%"),
                                   fluidRow(
                                     column(4,
                                            wellPanel(
                                              h1("Dubai's Best Perfumes"),
                                     tags$head(tags$style('h1 {color:maroon;}'))
                                     )),
                                     column(4,
                                            wellPanel(
                                              h1("Top Quality Oud Aroma")
                                              )),
                                     column(4,
                                            wellPanel(
                                              h1("All Natural Ingredients")
                                            ))
                                   )),
                      tabPanel("Product",
                               navlistPanel(
                                 tabPanel("Product Information",
                               h1("Product Information"),
                               p("These are our newest range of finest perfumes from Dubai, UAE. Each product paired with a unique fragrance
                                 to perfectly match all moods and personalities. All ingredients used are natural.")),
                              "Product Range",
                              tabPanel("For Men",
                                tags$ul("For Men",
                                       tags$li("1001 Nights"),
                                       tags$li("Al Fares"),
                                       tags$li("Arabian Knight"),
                                       tags$li("Black"))),
                              tabPanel("For Women",
                                       tags$ul("For Women",
                                       tags$li("Desert Rose"),
                                       tags$li("Almas"),
                                       tags$li("Arabesque"),
                                       tags$li("Jewel"))
                                       ))), 
                      
                      tabPanel("About Us",
                               h1("About Us"),
                               p("As young NTU entrepreneurs born and raised in Dubai, UAE, we have 
                               decided to bring the art and culture of dubai perfumes to Singapore to spread 
                                 the traditions to a new world."),
                               h2("History"),
                               tags$head(tags$style('h2 {color:purple;}')),
                              p("Established in 2007, we started in Arab Street of the Little Red Dot, to break into the market of Arabian
                      fragrances that are rarely found in this town. We have grown exponentially since then to offer the 
                        best range of products and always tapping on quality and variety. As we continue to grow
                        and look forward to a brighter future, we wish to connect with our customers to find out
                        what they appreciate the most."),
                                h2("Our Mission"),
                              p("At Arabian Nights we understand that achieving greatness doesn’t come easily, you have to 
                        prove to the world that you are worth it and you have to keep in mind that every single 
                        detail counts. We thrive for perfection, diversity, sophistication and excellence  in all our products."),
                                h2("Our Vision"),
                               p("At Arabian Nights we proudly admire our Arabian Heritage and our one and only goal is to represent it to 
                        the world in the best way it should be. For us we do that through our products; every scent carries 
                        a piece of heritage, culture and traditions of the Middle East in general and the Arab World in particular.")),
                      
                      tabPanel("Contact Us",
                               h1("Contact Details"),
                               img(src = "perfume.jpg",width="70%"),
                      sidebarLayout(position="right",
                                    sidebarPanel(
                                      p(tags$b("Phone Number:")), 
                                      p("+65 1234 5678"),
                                      p(tags$b("Email:")), p("imantaleb@arabiannights.sg"),
                                      p(tags$b("Address:")), p("53 Arab Street"),
                                      p("         Singapore 127801")),
                                    
                                    mainPanel()))
                      )
                  )
)
                  

        


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
