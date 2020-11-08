library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    navbarPage(title = "Great Baker",
               tabPanel("Product",
               titlePanel("Welcome!"),
               p("Here is our delicious bread and cake!"),
               img(src = "cake1.png", width = "40%"),
               img(src = "cake2.png", width = "40%"),
               img(src = "cake3.png", width = "40%"),
               img(src = "bread1.png",width = "40%"),
               img(src = "bread2.png", width = "40%"),
               img(src = "bread3.png", width = "40%")
               ),
               
    
    tabPanel("About us",
             fluidPage(
                 navlistPanel(
                     "Brand Introduction",
                     tabPanel("Great Baker Company",
                              h1("Great Baker Company"),
                              p("The Great Baker Company was founded in 2020, located 
                                on Yummy Street.
                                We has established the operation and management idea of doing food is doing conscience,
                                and adopted the management method of combining humanized management with standardized management, 
                                which is complementary to each other, to regulate staff behaviors and ensure food safety.
                                The enterprise development concept of 'quality first, service first, integrity management, 
                                innovation and development' is branded on the heart of employees. Establish the corporate 
                                values of 'Food safety is the life of Jialihua, and excellent quality is the source of corporate benefits'.
                                Adhere to the enterprise spirit of 'food is the conscience, customers are the parents, 
                                the market is the competition, innovation is the power'. Adhering to the 'smile to customers, 
                                using quality to expand the market, management to benefit' business philosophy. Adhere to the 
                                'create value for customers, create opportunities for employees, create benefits for the enterprise'
                                corporate purpose, Develop the big market and innovate Great Baker! 
                                First-class quality, quality service, excellent brand, is our constant pursuit!"
                     )),
                     tabPanel("Brand characteristics",
                              h1("Brand characteristics"),
                              p("We offer delivery services and DIY activities. 
                                All stores provide leisure comfort zones for leisure, 
                                gathering and business negotiation, afternoon tea cakes, 
                                fruits, coffee drinks, etc., providing convenience to customers 
                                and a very warm and warm feeling, so that people can relax easily."))
             ))),
    navbarMenu(title = "Contact Us",
               tabPanel("Address", "3/4 platform, Yummy Street"),
               tabPanel("Phone", "The phone number is: +19730427",
                        "Feel free to contact us! We are pleased to offer any help!")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
