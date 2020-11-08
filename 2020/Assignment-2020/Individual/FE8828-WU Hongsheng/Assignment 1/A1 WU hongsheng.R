# FE8828 Assignment 1 
# WU Hongsheng
library(shiny)

ui <- fluidPage(
    navbarPage(title = "Trip DIYer",
               tabPanel("Our Business",
                        fluidPage(titlePanel("Plan To Travel Wherever You Like!"),
                                  "Nowadays all parts of the world are more closely connected: 
                                  we have more opportunities to appreciate the beautiful scenery
                                  from all over the world; and explore the culture of different countries~~~"),
                        img(src = "A1.jpg"),
                        
                        sidebarLayout(
                            sidebarPanel(
                                h2("Our Mission"),
                                h4("Our business is to help customers who love self-guided travel 
                                   formulate corresponding travel plans and provide high-quality 
                                   travel supporting services at preferential prices, such as 
                                   transportation, hotel services, and catering. Our business 
                                   covers most of the popular tourist countries in the world. 
                                   Our biggest feature is that we are good at digging in-depth 
                                   tourist routes suitable for customers to explore, and provide
                                   various additional services according to customer needs.")
                            ),
                            mainPanel(h3("Key Statistics"),
                                      tags$ul("Our Partners",
                                              tags$li("We have high-quaility cooperaters (hotels,
                                                      travel agents...) from over 80 countries"),
                                              tags$li("The total market share of our partners
                                                      exceeds 80% in each industry related to tourism"),
                                              tags$li("For each of our partners, the revenue from
                                                      cooperation with us accounts for more 
                                                      than 20% of their annual revenue")
                                      ),
                                      tags$ul("Our Customers",
                                              tags$li("The number of our registered customers 
                                                      exceeded 10 million in 2019"),
                                              tags$li("Our customers come from more than 130 countries, 
                                                      and 80% of our customers are between 
                                                      21 and 65 years old."),
                                      ),
                                      tags$ul("Awards",
                                              tags$li("Awarded Singapore's fastest growing internet 
                                                      company from 2017 to 2019"),
                                              tags$li("Won the title of 2019 International 
                                                      Innovative Tourism Company"),
                                              tags$li("The customer satisfaction rate in 
                                                      2019 was 98.6%, setting a record for 
                                                      travel service companies in the past 10 years")
                                      )
                            )
                            )
                        ),
               
               navbarMenu(title = "Begin You DIY Journey",
                          tabPanel("Explore Your Target Place", 
                                   titlePanel("Explore Your Target Place!"),
                                   "Our service covers more than 80 countries and regions",
                                   p("Find the true dream places for you"),
                                   
                                   navlistPanel(
                                     "Classical European Tour",
                                     tabPanel("Traditional Western European Routes", 
                                              h3("Experience Dutch windmills and
                                                 rivers, French romance and food, 
                                                 and feel the urban charm of
                                                 London and Pairs..."),
                                              tags$ul("Country list",
                                                      tags$li("UK"),
                                                      tags$li("France"),
                                                      tags$li("Ireland"),
                                                      tags$li("Belgium"),
                                                      tags$li("Netherlands"),
                                                      tags$li("Luxembourg"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                                      )),
                                     tabPanel("Passionate Mediterranean Journey",
                                              h3("Experience the enthusiastic and 
                                                 vibrant Mediterranean countries 
                                                 in southern Europe, and experience 
                                                 the Roman and Greek civilizations 
                                                 that travel through ancient and 
                                                 modern times..."),
                                              tags$ul("Country list",
                                                      tags$li("Italy"),
                                                      tags$li("Spain"),
                                                      tags$li("Portugal"),
                                                      tags$li("Greece"),
                                                      tags$li("Croatia"),
                                                      tags$li("Montenegro"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     tabPanel("Fresh-mind Nordic Tour",
                                              h3("Feel the rustic and beautiful cities 
                                                 of the Nordic countries in Scandinavia, 
                                                 explore the charm of nature's ice and 
                                                 fire in the mysterious Iceland, and 
                                                 experience the gorgeous aurora..."),
                                              tags$ul("Country list",
                                                      tags$li("Sweden"),
                                                      tags$li("Denmark"),
                                                      tags$li("Norway"),
                                                      tags$li("Finland"),
                                                      tags$li("Iceland"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     tabPanel("Central European Scenery Tour",
                                              h3("Experience the city landscape of Prague from 
                                                 the Middle Ages, visit the majestic German 
                                                 castle, and enjoy the landscape of Switzerland..."),
                                              tags$ul("Country list",
                                                      tags$li("Germany"),
                                                      tags$li("Czech"),
                                                      tags$li("Hungary"),
                                                      tags$li("Austria"),
                                                      tags$li("Switzerland"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     
                                     "Asian Cultural Tour",
                                     tabPanel("Explore China", 
                                              h3("Explore China's unique culture, experience 
                                                 different customs in different regions of China, 
                                                 and experience China's beautiful architecture and 
                                                 delicious food..."),
                                              tags$ul("Chinese city list",
                                                      tags$li("Beijing"),
                                                      tags$li("Shanghai"),
                                                      tags$li("Guangzhou"),
                                                      tags$li("Suzhou"),
                                                      tags$li("Hangzhou"),
                                                      tags$li("Xiamen"),
                                                      tags$li("Chengdu"),
                                                      tags$li("Xi'an"),
                                                      tags$li("Nanjing"),
                                                      tags$li("Chongqing"),
                                                      tags$li("Kunming"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     tabPanel("Japanese Cultural Tour",
                                              h3("Experience Japan's unique culture and 
                                                 urban style, while experiencing the 
                                                 coexistence of Japanese modernity and tradition..."),
                                              tags$ul("Japanese city list",
                                                      tags$li("Tokyo"),
                                                      tags$li("Osaka"),
                                                      tags$li("Kyoto"),
                                                      tags$li("Sapporo"),
                                                      tags$li("Hakodate"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     tabPanel("Southeast Asia Tropical Tour",
                                              h3("Experience the authentic cuisine and passionate 
                                                 culture of Southeast Asian countries, and the 
                                                 tropical natural scenery..."),
                                              tags$ul("Country list",
                                                      tags$li("Singapore"),
                                                      tags$li("Malaysia"),
                                                      tags$li("Thailand"),
                                                      tags$li("Vietnam"),
                                                      tags$li("Philippines"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     
                                     "Other Popular Routes",
                                     tabPanel("North America Tour",
                                              h3("Experience the modern cities of the United 
                                                 States and Canada and the magnificent natural 
                                                 scenery of the west..."),
                                              tags$ul("City/Region/State list",
                                                      tags$li("Seattle & Vancouver"),
                                                      tags$li("California"),
                                                      tags$li("Yellowstone National Park"),
                                                      tags$li("Toronto"),
                                                      tags$li("Las Vegas"),
                                                      tags$li("New York, Philadelphia & Boston"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     tabPanel("Oceania Tour",
                                              h3("Feel the unique South Pacific style of 
                                                 Australia and New Zealand, and feel the 
                                                 beautiful natural environment and ecosystem..."),
                                              tags$ul("City/Region/State list",
                                                      tags$li("Sydney"),
                                                      tags$li("Great Barrier Reef"),
                                                      tags$li("Gold Coast"),
                                                      tags$li("Melbourne"),
                                                      tags$li("Wellington"),
                                                      tags$li("Auckland"),
                                                      tags$li("Queenstown"),
                                                      tags$img(src = "A1.jpg",width="70%")
                                              )),
                                     "----- MORE TO COME -----"
                                   )
                          ),
                          
                          tabPanel("Select the Service", 
                                   titlePanel("Select Our DIY Service~"),
                                   tags$img(src = "A1.jpg", width = "100%"),
                                   fluidRow(
                                     column(4,
                                            wellPanel(h2("Luxury In-depth Tour"),
                                                      tags$p("According to your travel itinerary and various needs, we provide high-quality transportation services (premium economy class on passenger planes and first-class seats on train cruise ships), hotel services (5 stars) and arranging best catering. At the same time, we will try our best to explore various in-depth tourist attractions in the tourist route to make your travel experience the best. The price is 20%-40% higher than the standard service.")
                                            )),
                                     column(4,
                                            wellPanel(h2("Classic DIY-Fun Tour"),
                                                      tags$p("This is our standard service. We will provide the most suitable route and schedule, classic attractions and food. At the same time, transportation and hotels will be of good quality (large airline companies' economy class and 4-star hotels). We will also adjust the travel itinerary and plan according to your other needs, and reserve a portion of your free time. The quotation we provide is on average 15% cheaper than the transportation and hotel costs you book separately.")
                                            )),
                                     column(4,
                                            wellPanel(h2("Rapid Convenient Tour"),
                                                      tags$p("In this plan, we will provide the same transportation and hotel services as standard services, but catering is not included. This plan will only provide a basic itinerary, or adjust the travel plan according to your needs. You can have flexible specific itinerary arrangements. The cost of this travel plan is only 60%-75% of the standard service, suitable for young travelers who are energetic and willing to explore.")
                                            ))                          
                                   )
                          )
               ),
               
               navbarMenu(title = "Contact Us",
                          tabPanel("Online Consultation", 
                                   h2("Share Us Your Trip Plan!"),
                                   h3(""),
                                   a("Click for Online Consultation"),
                                   tags$img(src = "A1.jpg", width = "100%"),
                                   ),
                          
                          tabPanel("Phone", 
                                   h4("+65 6666 8888"),
                                   tags$img(src = "A1.jpg", width = "100%")),
                          tabPanel("Address", 
                                   h4("NTUU Center F28, Singapore"),
                                   tags$img(src = "A1.jpg", width = "100%"))
                          )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
