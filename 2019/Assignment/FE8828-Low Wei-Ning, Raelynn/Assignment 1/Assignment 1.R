#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
ui <- fluidPage(
  navbarPage(title = "Clim8te",
             mainPanel(
               img(src = "earth.jpg")),
             tabPanel("Our Purpose",
                      titlePanel("Save the Earth"),
                      "According to a recent think tank report, climate change could pose 
                      significant existential threat by 2050. If global temperatures rise 
                      3 degree Celcius, 55% of the world's population would experience heat 
                      beyond the threshold of human survivability.",
                      titlePanel("Take action now"),
                      "Our products are manufactured sustainably with 20% of the sales donated to
                      NPOs fighting climate change. Do your part by choosing sustainability.",
                      actionButton("yesButton","Yes!",icon("laugh")
                      )),
             tabPanel("Our Products",
                      titlePanel("Our Products"),
                      fluidRow(
                        column(4,
                               h1("Sustainable bottle",style = "font-size:25px"),
                               (img(src="bottle.jpg",width="25%")),
                               actionButton("buyButton1", "Buy now!",icon("shopping-cart"))),
                        column(4,
                               h2("Sustainable tshirt",style = "font-size:25px"),
                               (img(src="shirt.jpg",width="45%")),
                               actionButton("buyButton2", "Buy now!",icon("shopping-cart"))),
                        column(4,
                               h3("Sustainable bag",style = "font-size:25px"),
                               (img(src="bag.jpg",width="40%")),
                               actionButton("buyButton3", "Buy now!",icon("shopping-cart"))
                               )
                        )
                      ),
             tabPanel("Our People",
                      sidebarLayout(
                        sidebarPanel(
                          h1 ("Our People", style = "font-size:25px"),
                          "We are a team of youths passionate about living (on Earth).",
                          h2 ("Contact us", style = "font-size:25px"),
                          "Address: SomewhereOnEarth",
                          "Phone: +12345678"
                          ),
                        mainPanel(
                            img(src="people.jpg",width="153%")
                            ),
                        position = c("right")
                   )
                   )
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {
}
# Run the application
shinyApp(ui = ui, server = server)