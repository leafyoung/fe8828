#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidPage(
        titlePanel("Crypto Frenzy"),
        navlistPanel(
            "Introduction",
            tabPanel("Who are we",
                     h1("What is crypto currencies?"),
                     tags$img(src = "image2.jpeg", width = "100%"),
                     p("A cryptocurrency (or crypto currency) is a digital asset designed to work as a medium of exchange wherein individual coin ownership records are stored in a ledger existing in a form of computerized database using strong cryptography to secure transaction records, to control the creation of additional coins, and to verify the transfer of coin ownership.")
                     ),
            tabPanel("What do we do",
                     h1("We provide the best price to insitutional client on buying or selling cryptocurrencies"),
                     br(),
                     p("Please contact us for more details"),
                     tags$img(src = "image1.jpg", width = "100%"),
                     
            ),
            "Product",
            tabPanel("Bitcoin", 
                     h1("XBTUSD"),
                     br(),
                     a("XBTUSD Contract Specification", href="https://www.bitmex.com/app/contract/XBTUSD"),
                     p("XBTUSD is a XBT/USD perpetual contract priced on the Bitcoin Index. Each contract is worth 1 USD of Bitcoin.")
                     ),
            tabPanel("Etherum", 
                     h1("ETHUSD"),
                     br(),
                     a("ETHUSD Contract Specification", href="https://www.bitmex.com/app/contract/ETHUSD"),
                     p("ETHUSD is a ETH/USD perpetual contract priced on the Etherum Index. Each contract is worth 0.001 mXBT per $1 price, currently 0.00033945 XBT.")
                     ),
            "About Us",
            tabPanel("Phone Number",
                     h1("+65 12345678")),
            tabPanel("Address",
                     h1("Nanyang Business School, Nanyang Technological University, Singapore"))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


