library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidPage(
        titlePanel("Excellence Company Website"),
        tabsetPanel(
            tabPanel("About Us", 
                     h1("Introduction"),
                     p("We are an xxx company aiming at providing xxx service."),
                     p("Thank you for visiting."),
                     fluidRow(
                         column(3,
                                wellPanel(
                                    textInput("text", "Anything interested?")
                                )
                         ),
                         column(5,
                                h2("Stock Trend"),
                                wellPanel(plotOutput("Stock Trend"))
                         ),
                         column(3, h2("Summary"),
                                wellPanel(h5("Debt"),
                                          tags$p("This is the paragraph gives information about the company's Debt Summary"),
                                          h5("Equity"),
                                          tags$p("This is the paragraph gives information about the company's Equity summary")
                                          )
                         )
                     )), 
            tabPanel("Product", 
                     h1("Product Info"),
                     p("Our product ranges from xxx to xxx, aiming to give you a great level of satisfaction."),
                     p("Not sure what to buy? Use our product finder to explore!"),
                     img(src = "WebPhoto.jpg"),
                     img(src = "WebPhoto2.jpg"),
                     fluidRow(
                         column(3,
                                h4("Product Finder"),
                                sliderInput('price', 'Price', 
                                            min=500, max=50000, value=min(500, nrow(diamonds)), 
                                            step=500, round=0),
                                br(),
                                checkboxInput('packaged', 'Packaged'),
                                checkboxInput('freeDelivery', 'Free Delivery'),
                         ),

                         column(8,
                                h4("Filtered Result"),
                                p("This is the area displaying the desired product of the customers."),
                                "-------------------------------------------------------------------",
                                p("Feel free to approach us if you have special needs.")
                                
                         )
                     )), 
            
            navbarMenu(title = "Contact Us",
                       tabPanel("Location", "We are a global company located at xxxxxxx. Please find us at xxxxxxxxxxxxxxx"),
                       tabPanel("Email", "WeAreExcellent@Excellence.sg"),
                       tabPanel("Phone", "+65-8888")
            )
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


