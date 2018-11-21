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
    navbarPage(title = "NBS Travel Agency",
               tabPanel("Product",
                        titlePanel("Welcome to NBS travel agency!"),
                        fluidPage(
                          fluidRow(
                            column(3,
                                   wellPanel(
                                     dateInput("date","What's the date")
                                   )
                            ),
                            column(8, h3("Daocheng"),
                                   wellPanel(img(src='pic1.jpg'), height=20, width=35)
                            ),
                            column(10, h3("Introduction"),
                                   wellPanel("We are a travel agency that specializes in providing customized tours to Sichuan, China.")
                            )
                          )
                        )
               ),
                        
               tabPanel("About us",
                        titlePanel("Hello!"),
                        fluidPage(
                          fluidRow(
                            column(8, h3("Outer Space"),
                                   wellPanel(img(src='pic2.jpg'), height=20, width=35)
                            ),
                            column(10, h3("Experience"),
                                   wellPanel("For 30 years, we have been providing the best travel services on the planet. 
                                             Our core members have many years of experience in outer space travel, 
                                             proficient in the M48 nebula, Mars, the moon and other different areas of tourism."))))),
               navbarMenu(title = "Contact Us",
                          tabPanel("Address", "Nanyang Technological Uiversity Graduate Hall 2"),
                          tabPanel("Phone", "+65 88888888(Singapore)/ +86 88888888888(China)")
               )
    )
  )
)


  


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

