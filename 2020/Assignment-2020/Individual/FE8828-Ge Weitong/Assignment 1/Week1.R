library(shiny)

ui <- fluidPage(
  navbarPage(title = "New Digital Bank Technology",
             tabPanel("Product", 
                      #Sidebar Layout
                      titlePanel("Products Overview"),
                      sidebarLayout(
                        sidebarPanel("We are expanding our business globally!"),
                        mainPanel(        tags$ul("Product Categories:",
                                                  tags$li("Mortgages"),
                                                  tags$li("Credit Cards"),
                                                  tags$li("Insurances"),
                                                  tags$li("Investments")
                        )),
                      )),
             
             tabPanel("About us",
                      fluidPage(titlePanel("Welcome to New Digital Bank Technology!"),
 
                       #Column-Based layout
                       fluidRow(
                         column(10,
                                h3("History"),
                                wellPanel(
                                  "We are founded in year 2018. Staring with 5 students, we have growed into a meduim enterprise with 100 employees")
                                )
                         ),
                         column(6,
                                h3("Introduction"),
                                wellPanel("we are one of the few banks that can comprehensively meet your requirements.")
                         ),
                         column(6,
                              h3("Mission"),
                              wellPanel("We devote our personal attention to deliver the best financial solutions for your business.")
                       )
          
                       ) ),
             #Navlist
             navbarMenu(title = "Contact Us",
                        tabPanel("Address",titlePanel("Office Address"), "50 Nanyang Ave, Singapore 639798"),
                        tabPanel("Phone", titlePanel("Contact Number"),"+65 62345678")
             )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


