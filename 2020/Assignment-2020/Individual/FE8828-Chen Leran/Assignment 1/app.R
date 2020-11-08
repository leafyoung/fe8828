library(shiny)
# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Avengers Tuition Institute Pte Ltd"),
    sidebarLayout(
        sidebarPanel(
            tags$ul(tags$li(h4("Best Tuition Service")),
                    tags$li(h4("Expericed teachers")),
                    tags$li(h4("1 to 1 classes")))
        ),
        mainPanel(
            img(src = "p1.jpg",height="90%", width="100%", align="right")
        )
    ),
    
    navlistPanel(
        "Professional Teachers",
        tabPanel("Tony Stark",
                 sidebarLayout(
                     
                     sidebarPanel(
                         h2("Tony Stark AKA Iron Man"),
                         tags$ul(tags$li(h4("Entered MIT at the age of 15")),
                                 tags$li(h4("Master in Engineering and Physics")),
                                 tags$li(h4("Physics, Mathematics"))
                         )
                     ),
                     
                     mainPanel(
                         img(src = 'tonystark.jpg',height="50%", width="50%", align="centre")
                     )
                 )),
        
        tabPanel("Steven Rogers",
                 sidebarLayout(
                     
                     sidebarPanel(
                         h2("Steven Rogers AKA Captain America"),
                         tags$ul(tags$li(h4("Born in 1922")),
                                 tags$li(h4("Super Soldier")),
                                 tags$li(h4("History, Fistfight"))
                         )
                     ),
                     
                     mainPanel(
                         img(src = 'stevenrogers.jpg',height="50%", width="50%", align="centre")
                     )
                 )),
        
        tabPanel("Natalia Romanova",
                 sidebarLayout(
                     
                     sidebarPanel(
                         h2("Natalia Romanova AKA Blackwidow"),
                         tags$ul(tags$li(h4("Best Secret Agent in Russia")),
                                 tags$li(h4("Information Science, Languages"))
                         )
                     ),
                     
                     mainPanel(
                         img(src = 'blackwidow.jpg',height="50%", width="50%", align="centre")
                     )
                 ))
        
        
    ),
    
    
    
    
    fluidPage(
        fluidPage(
            fluidRow(
                column(3,
                       h3("Schedule Appointment"),
                       selectInput("location", "Location", c("East","West","South","North")),
                       selectInput("teacher","Teacher",c("Tony Stark", "Steven Rogers","Natalia Romanova")),
                       submitButton("Submit")
                ),
                column(6,
                       h3("Agency Rating"),
                       plotOutput("distPlot")
                ),
                column(3,
                       h3("Address"),
                       "New York - Marvel Avenue, Avengers Tower",
                       h3("Contact Number"),
                       "86978451"
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- runif(200,min=85,max=100)
        bins <- seq(min(x), max(x), length.out = 50 + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}
# Run the application
shinyApp(ui = ui, server = server)