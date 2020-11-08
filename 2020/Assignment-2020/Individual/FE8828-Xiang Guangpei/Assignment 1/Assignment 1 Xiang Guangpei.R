library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
        navbarPage(
          title = "FQJ Construction",
          
            tabPanel("Project",
              titlePanel("Wlecome to FQJ Construction!"),
              tags$img(src = "timg.jpg", width = "100%"),
              fluidRow(
                  column(4,
                         wellPanel(h1("Current Projects"),
                                   tags$p("Porject 1"),
                                   tags$p("Porject 2"),
                                   tags$p("Porject 3")
                         )),
                  column(4,
                         wellPanel(h1("Past Projects"),
                                   tags$p("Porject A"),
                                   tags$p("Porject B"),
                                   tags$p("Porject C")
                         )),
                  column(4,
                         wellPanel(h1("Awards"),
                                   tags$p("Award X"),
                                   tags$p("Award Y"),
                                   tags$p("Award Z")
                         ))
                       )
                    ),
              
            tabPanel("About Us",
              titlePanel("Chasing for Excellence!"),
              sidebarLayout(
                sidebarPanel(
                  h1("Activities"),
                  a("Link to BCA", href="http://www.bca.gov.sg"),
                          tags$ul("About",
                          tags$li("Who are we"),
                          tags$p("Singapore-based main-contractor"),
                          tags$li("What we do"),
                          tags$p("Build & Construct")
                  )),
                   mainPanel(
                       img(src = "timg1.jpg")
                            )
                          )
                     ),
          
          tabPanel("Contact Us",   
            titlePanel("Come and Join us!"),
             navlistPanel(
                     "Company Address",
                     tabPanel("Location", 
                              h1("Company Address"),
                              p("Nanyang Street 21. S123456. Singapore")),
                   
                     "Company Phone Line",
                     tabPanel("Phone Number",
                              h1("You can call:"),
                              p("+65 12345678"))
                   )   
                  )
   
))


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
