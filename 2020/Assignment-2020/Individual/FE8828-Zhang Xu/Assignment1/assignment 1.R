library(shiny)

ui <- fluidPage(
    navbarPage(title = "Pet Your Pet Inc.",
               tabPanel("Business Scope", 
                        titlePanel("Welcome to Pet Your Pet!"),
                        navlistPanel( "FOR DOGS", tabPanel("Shower",  h1("SG$25/time  (25% discount for VIP!!)"),img(src = "dogshower.jpg")), tabPanel("Sculpt",h1("SG$35/time  (25% discount for VIP!!)"),img(src = "dogsculpt.jpg")),tabPanel("Foster", h1("SG$25 per day (25% discount for VIP!!)"),img(src = "dogfoster.jpg")), 
                                      "FOR CATS", tabPanel("Forster", h1("SG$25 per day"),img(src = "catsfoster.jpg")), "-----", tabPanel("Pet medical",img(src = "medical.jpg")) )),
               tabPanel("About us",
                        titlePanel("About Pet Your Pet Inc"),
                        fluidRow(column(6,
                                        h3("Our Group"),p("All of up numbers graduate from NTU"),p("We will do our best to pet your pet")),
                                 column(6,
                                        h3("Our Honor"),p("Best Pet Company of 2019 in SG"),p("Best Pet Company of 2018 in SG"),p("Best Pet Company of 2017 in SG"))))
               ,
               tabPanel("Contect Us",fluidPage(sidebarLayout(
                 sidebarPanel("Email"),
                 mainPanel("Peturpet@pet.sg")
               )),
               
               fluidPage(sidebarLayout(
                 sidebarPanel("Phone Number"),
                 mainPanel("110110110")
               ))
               )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
