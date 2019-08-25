## Fang You G1800202G
## FE8828 Assignment 1

#outstanding questions:

#1) how to break lines to continue onto second line? tags$br() or just br()

# titlePanel("Portfolio \n Optimization"),
# "Seamless portfolio", br(), "optimzation advisory available 24/7!",

#2) how to build a link?

# link to external website:
# tags$a(href = "shiny.rstudio.com/tutorial", "Click Here!")

# action link (works the same as action button)
# actionLink(inputId, label, icon = NULL, ...)

#3) how to insert images?

# create a directory with name www
# place image inside.
# reference image without www directory.
# already mentioned in the notes. :-)
# tags$img(src="foodtour1.jpeg",width=400)


library(shiny)

# Define UI for application
ui <- fluidPage(
  
  fluidPage(
    titlePanel("Optimal Solutions"),
    navbarPage(title = "Look around! -->",
               tabPanel("Product & Services",
                        titlePanel("Portfolio \n Optimization"),
                        "Seamless portfolio", br(), "optimzation advisory available 24/7!",
                        titlePanel("Wide coverage"),
                        "We cover all major stock exchanges in the world!",
                        titlePanel("USA"),
                        "New York Stock Exchange, NASDAQ",
                        titlePanel("Japan"),
                        "Tokyo Stock Exchange",
                        titlePanel("UK"),
                        "London Stock Exchange",
                        titlePanel("Hong Kong"),
                        "Hong Kong Stock Exchange",
                        titlePanel("China"),
                        "Shanghai Stock Exchange",
                        titlePanel("Mars (Coming soon!)"),
                        "Martian Exchange"),
               tabPanel("About us",
                        titlePanel("The Dream Team"),
                        "Just a regular part time MFE student",
                        titlePanel("What makes the dream team 'dreamy'"),
                        "I like coffee with milk"),
               tabPanel("Investor Relations",
                        titlePanel("Donations"),
                        "Currently all services are offered free of charge! We appreciate all donations to keep this service free for all users.",
                        titlePanel("To make a donation"),
                        "<link under construction>"),
               navbarMenu(title = "Contact us",
                          tabPanel("Address","We work from wherever we want"),
                          tabPanel("Email","contactus@optimalsolutions.com")
               )
    )
    
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
}

# Run the application 
shinyApp(ui = ui, server = server)

