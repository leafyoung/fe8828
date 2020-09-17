library(shiny)

ui <- fluidPage(
    navbarPage(
            title = "Jay's Auto",
            tabPanel("Supercars",
                     fluidPage(
                     titlePanel("Welcome to Jay's Auto"),
                     p("Jay's auto is an international car dealer focusing mainly on supercars and hypercars."),
                     p("If you have bought totally 6 cars, you will be upgraded as our VIP and you will be the first to be noticed if new cars arrive."),
                     h4("Enjoy your time here and customize the best car of your own!"),
                     sidebarLayout(
                         sidebarPanel(
                             h1("Cars Available"),
                             h2("Lamborghini--Hurrican"),
                             h2("Porsche--GT2_RS")
                         ),
                         mainPanel(
                             h2("Offering Price: "),
                             h3("$738,800"),
                             img(src = "Lamborghini_Hurrican.jpg", width = "760px", height = "440px"),
                             h2("Offering Price: "),
                             h3("$663,800"),
                             img(src = "Porsche_GT3_RS.jpg", width = "760px", height = "440px"))))),
            tabPanel("Hypercars",
                     fluidPage(
                         titlePanel("Cars Avaiable"),
                         fluidRow(
                            column(3,
                                   h2("Ford--GT"),
                                   img(src = "Ford_GT.jpg", width = "285px", height = "165px"),
                                   h2("Sold Out!")
                            ),
                            column(6,
                                   h2("Bugatti--Chiron"),
                                   img(src = "Bugatti_Chiron.jpg", width = "570px", height = "330px"),
                                   h3("Customize your Bugatti here"),
                                   a("Fastest car in the world", href = "https://www.bugatti.com/")
                            ),
                            column(3,
                                   h2("Mclaren--P1"),
                                   img(src = "Mclaren_P1.jpg", width = "285px", height = "165px")),
                                   h3("Open for reserve"),
                                   a("Maybe second fatest in the world", href = "https://www.mclaren.com/")))),
            navbarMenu(title = "Make Payment",
                       tabPanel("Credit card", 
                                fluidPage(
                                    navlistPanel("Credit card",
                                                tabPanel("Visa",
                                                        h1("Payment with Visa"),
                                                        p("Please scan the following QR code"),
                                                        img(src = "Payment.jpg", width = "350px", height = "350px")),
                                                tabPanel("Master Card",
                                                        h1("Payment with Master Card"),
                                                        p("Please scan the following QR code"),
                                                        img(src = "Payment.jpg", width = "350px", height = "350px"))))),
                       tabPanel("Cryptocurrency", 
                                fluidPage(
                                    navlistPanel("Cryptocurrency",
                                                 tabPanel("Bitcoin",
                                                          h1("Payment with Bitcoin"),
                                                          p("Please make direct payment on the following link"),
                                                          a("Link for payment", href = "https://www.linkedin.com/in/bingyan-ji-a787a5148"),
                                                          p("\n"),
                                                          img(src = "Payment2.jpg", width = "400px", height = "200px")),
                                                 tabPanel("Ripple",
                                                          h1("Payment with Ripple"),
                                                          p("Please make direct payment on the following link"),
                                                          a("Link for payment", href = "https://www.linkedin.com/in/bingyan-ji-a787a5148"),
                                                          p("\n"),
                                                          img(src = "Payment2.jpg", width = "400px", height = "200px"))))))))

# Define server logic required to draw a histogram
server <- function(input, output) {
   

}

# Run the application 
shinyApp(ui = ui, server = server)

