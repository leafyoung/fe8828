#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  
   # Application title
  titlePanel("CrystallBall Energy Trading and Risk Management Inc."),
  hr(),
  
   navbarPage(
     title="CrystallBall",
     
     tabPanel("About us", 
              hr(),
              titlePanel(h1("Founder")),
              sidebarLayout(position="left",
                sidebarPanel(
                  h3("Personal Statement"),
                  hr(),
                  h4("Proven FinTech professional with 13 years+ of experience in front 
                     office trading and risk management system implementation and support. 
                     Sound financial market knowledge and hands-on front office user facing experience 
                     especially in energy trading and risk management industry. Strong risk management and 
                     trading analysis modelling expertise (VBA & SQL) in leading commodity trading houses. 
                     Familiar with Java, C#, SQL, VBA, and energy trading and risk management systems (ETRM).")
                ),
                mainPanel(tags$img(src = "myPhoto.JPG",align="center"))
              ),
              
              hr(),
              titlePanel(h1("Company History")),
              wellPanel(h3("Comany established in 2018. To become a true market leader in CTRM system, and 
                            gain reputation in the market with capabilities and features other systems do not have. Through 
                            combining deep understanding of  commodity/energy trading with technology Innovation, be courageous 
                            in adopting new innovative approaches."))
     ),
     
     
     tabPanel("Services",
              hr(),
              tabsetPanel(
                tabPanel(h4("Risk Management"),
                wellPanel(
                    #point list
                    tags$ul(h1("Energy Risk Mangement"),
                        tags$li(h4("Forward curve management")),
                        tags$li(h4("Price risk management")),
                        tags$li(h4("Position management - Futures, Options, Physical Cargos")),
                        tags$li(h4("Logistic - Shipment & Inventory mangement"))
                    ),
                    #add link
                    a(h4("Check the latest Oil prices"), href="http://www.oil-price.net/")
                    ) 
                ),
                
                tabPanel(h4("Trading Analytics"),
                  fluidRow(
                    column(4, h3("Refinery Capacity"), tags$img(src = "Refinery.JPG", height = 450, width = 400,align="center")),
                    column(4, h3("Demand & Supply Forecast"), tags$img(src = "DemandSupply.JPG", height = 450, width = 400,align="center")),
                    column(4, h3("Ship Tracking"), tags$img(src = "Ship.JPG", height = 450, width = 400,align="center"))  
                    )  
                ),
                
                tabPanel(h4("Trading Optimization"), tags$img(src = "Optimization.JPG",align="center"))
              )),
     
     navbarMenu(title="Contact us", 
                hr(),
                tabPanel("Address",
                        titlePanel(h1("Address:\n\n")),
                        mainPanel(
                          h2("#50-01, Suntec City Tower 2, Singapore\n\n\n\n"),
                          tags$img(src = "AddressPic.JPG", height = 450, width = 600,align="center") 
                        )
                ), 
                tabPanel("Phone", 
                         navlistPanel(
                           "Contact us",
                           tabPanel(h4("Office"), h1("+65-6666 8888")),
                           tabPanel(h4("Mobile"), h1("+65-9070 9731"))
                         )
                ),
                tabPanel("Email", 
                         titlePanel(h1("Email address: liangxuesen0907@hotmail.com")),
                         a(h2("Email us now"), href="mailto:liangxuesen0907@hotmail.com"),
                         tags$img(src="Steve.PNG",align="center")
                )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

