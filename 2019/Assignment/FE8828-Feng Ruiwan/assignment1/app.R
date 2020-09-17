library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   navbarPage(title = "Dream Factory",
              tabPanel("Product",
                       titlePanel("Welcome to dream factory!"),
                       "As below you can see the exsisting products!",
                       br(),
                       img(src = "dream.jpg", width = "100%"),
                       hr(),
                       fluidRow(
                         column(3,
                                wellPanel(
                                  h2("Huge Lollipop"),
                                  img(src = "lollipop.png", width = "80%"),
                                  p("The biggest lollipop in the world, with fantastic taste and the most beautiful color!")
                                  )
                                ),
                         column(3, offset = 1.5,
                                wellPanel(
                                  h2("Bubble Maker"),
                                  img(src = "bubble.png", width = "80%"),
                                  p("The machine can produce the big colorful bubble! And can contain tons of bubble water")
                                  )
                                ),
                         column(3, offset = 1.5,
                                wellPanel(
                                  h2("Digital notebook"),
                                  img(src = "notebook.png", width = "80%"),
                                  p("The electronic notebook with paper-like texture, children can write and draw on the page as they like, and the page can be clean with a click of button!")
                                  )
                                )
                       )
                       ),
              tabPanel("Design",
                       titlePanel("Design your own dream product here!"),
                       "Give us your creative ideas!",
                       textInput("input_1", "Your product name:", "name"),
                       textInput("input_2", "What is your product:", "describe it"),
                       actionButton("submit_btn", "Submit")
                       ),
              navbarMenu(title = "About us",
                         tabPanel("Our company",
                                  titlePanel("Our mission"),
                                  navlistPanel(
                                    tabPanel("For designers",
                                             p("Encourage their creativity, and help them to make their product into reality.")),
                                    tabPanel("For inverstors",
                                             p("Chose the product you like, and denote if you want. Get chance to get the product you vote for!"))
                                    
                                  )),
                         
                         tabPanel("Contact us",
                                  sidebarPanel(
                                    tags$ul("contact",
                                           tags$li("+65 423543534"),
                                           tags$li("alksdjf Road Singapore"))
                                  ),
                                  mainPanel(img(src ="dream.jpg", width = "80%"))
                                  )
                         )
              
              )
   
 
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

