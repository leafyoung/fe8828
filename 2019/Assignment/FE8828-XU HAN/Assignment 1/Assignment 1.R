library(shiny)

ui <- fluidPage(
  fluidPage(
    navbarPage(title = "Cargill", 
               tabPanel("About Cargill",
                        titlePanel("About Cargill"),
                        tags$img(src = "Cargill_logo.png", width = "100%"),
                        p("Call us optimistic. We believe the world eats better when we eat together. Starting from a single grain elevator in Iowa, our passion has always been to bring producers and consumers of food closer to one another."),
                        titlePanel("Nourishing the world"),
                        "Our team of 160,000 professionals in 70 countries draws together the worlds of food, agriculture, nutrition and risk management. For more than 150 years, we have helped farmers grow more, connecting them to broader markets. We are continuously developing products that give consumers just what they’re seeking, advancing nutrition, food safety and sustainability. And we help all of our partners innovate and manage risk, so they can nourish the world again tomorrow.",
                        titlePanel("How we work"),
                        "We work alongside farmers, producers, manufacturers, retailers, governments, and other organizations to fulfill our purpose to nourish the world in a safe, responsible and sustainable way, Together, we create efficiencies, develop innovations, and help communities thrive.",
                        tags$ol("about",
                               tags$li("We offer inputs, expertise and risk management tools to farmers small and large, helping them boost their productivity and incomes. We buy their crops and animals and bring them to markets around the globe."),
                               tags$li("We process a wide range of agricultural commodities into the food, feed and fuel the world needs, transporting them to the places they will be consumed."),
                               tags$li("We partner with the world’s leading consumer goods, restaurant and retail brands to create innovative products that serve the changing values of consumers everywhere."),
                               tags$li("We nourish animals with pioneering feed products and work with farmers and scientists to ensure animals' well-being, in order to sustainably meet growing demand for animal protein worldwide."),
                               tags$li("We join with community leaders, non-profits and others to enrich the places where we live and work, building a strong, sustainable future for agriculture.")
                               ),
                        titlePanel("Know more about us"),
                        a("A link to our website", href="https://www.cargill.com/home")
                        ),
               tabPanel("Product",
                        titlePanel("All Products"),
                        navlistPanel(
                          "Animal Nutrition",
                          tabPanel("Our species",
                                   tags$ul("",
                                  tags$li("Beef"),
                                  p(" "),
                                  tags$li("Swin"),
                                  p(" "),
                                  tags$li("Aquaculture"),
                                  p(" "),
                                  tags$li("Dairy"),
                                  p(" "),
                                  tags$li("Poultry"),
                                  p(" "),
                                  tags$li("Additives"))
                                  ),
                          tabPanel("Our difference",
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Sustainability"),
                                     mainPanel("The core of our business is delivering solutions more efficiently, both today and tomorrow.")
                                     )),
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Innovation"),
                                     mainPanel("Your insights and our expertise: a powerful combination for creating breakthrough solutions.")
                                     )),
                                   fluidPage(sidebarLayout(
                                     sidebarPanel("Feed4Thought"),
                                     mainPanel("News, trends and perspectives on developments in animal nutrition.")
                                     ))
                                   ),
                          "Agricultural Trading and Processing",
                          tabPanel("Grains & oilseeds",
                                   p("We operate on an integrated global basis to source, store, trade, process and distribute grains and oilseeds including wheat, corn, oilseeds, barley and sorghum, as well as vegetable oils and meals. We have a broad global presence in grain origination, shipping and processing and we have developed significant expertise in handling identity preserved and differentiated products."),
                                   p("Our supply chain efficiency combined with origin and logistical flexibility enables us to deliver significant value to our customers around the world. We also work closely with Cargill's finance and risk management businesses to offer a range of financial and hedging products.")
                                  ),
                          tabPanel("Our difference",
                                   tags$ul("",
                                  tags$li("Biofuels"),
                                  p("We offer customers in Europe, Latin America, and North America a reliable source of high-quality biodiesel and ethanol products that meet a range of specifications and compliance requirements."),
                                  tags$li("Cotton"),
                                  p("Customers on six continents trust Cargill to provide reliable supply and delivery of their quality requirements in a sustainable way. We apply our global expertise, proven reliability and comprehensive risk management solutions in support of growers, ginners, buyers and textile mills worldwide."),
                                  tags$li("Palm Oil"),
                                  p("We own and operate palm plantations in Indonesia, operate palm oil refineries in Asia, Europe and the U.S. and are active in palm oil trading markets. We are working towards a traceable, transparent and sustainable palm oil supply chain by 2020."),
                                  tags$li("North America Farmer Services"),
                                  p("We offer U.S. and Canadian farmers a range of grain contracting and consulting solutions, crop inputs, and agronomic services designed to increase growers’ yields and maximize profitability. We also offer a high oleic specialty canola growing program for farmers interested in top performing, high yield crops with superior per acre returns.")
                                  )
                                   ),
                          "Transportantion and Logistics",
                          tabPanel("Transportation",
                                  tags$ul("",
                                 tags$li("Cargill Ocean Transportation"),
                                  p("Cargill Ocean Transportation is a leading freight-trading organization and charterer of over 600 vessels. Our vessels call on more than 4,500 ports per year and move over 200 million tons of 50 different dry bulk commodities."),
                                  tags$li("Refrigerated Trucking"),
                                  p("Cargill Meat Logistics Solutions provides transportation, logistics, and supply chain services to its customers, and specializes in moving refrigerated, temperature-controlled freight such as meat and produce. CMLS operates throughout the U.S. and into Canada and Mexico. ")
                                  )
                                  )
                          )),
               navbarMenu(title = "Contact Us",
                          tabPanel(
                            "Address",
                            fluidRow(
                            column(6,
                                   h3("Address in Singapore"),
                                   wellPanel("38 Market Street, #17-01 CapitaGreen, Singapore 048946")
                                   ),
                            column(6,
                                   h3("Address in Malysia"),
                                   wellPanel("No. 10, Jalan Lada Hitam, Taman Sri Tengah, 86000 Kluang, Johor, Taman Kasih, 86000 Kluang, Johor")
                                   )
                      
                            )), 
                          tabPanel("Phone", 
                                   fluidRow(
                                     column(6,
                                            h3("Phone number in Singapore"),
                                            wellPanel("+65 6295 1112")
                                   ),
                                     column(6,
                                            h3("Phone number in Malysia"),
                                            wellPanel("+60 12-768 3893")
                                   )
                                   ))
    )
  ) 
)
)

# Define server logic required to draw a histogram 
server <- function(input, output) {
}

# Run the application
shinyApp(ui = ui, server = server)