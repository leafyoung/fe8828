

library(shiny)
library(readxl)
# Region <- read_excel("C:/Users/104550duya/Dropbox/master in finance/Course material/2nd Year/S8/fe 8828 web application/Assignment_1_Yang_Dun/www/Region.xlsx")
# Cargo <- read_excel("C:/Users/104550duya/Dropbox/master in finance/Course material/2nd Year/S8/fe 8828 web application/Assignment_1_Yang_Dun/www/Cargo.xlsx")

Region <- read_excel("Region.xlsx")
Cargo <- read_excel("Cargo.xlsx")

# Define UI for application
ui <- fluidPage(
    
    # Application title
    titlePanel("SunBulk Transportation"),
    
    # navlistPanel(
    #     "header A",
    #     tabPanel("section 1",
    #              tags$ol("about",
    #                      tags$li("who are we"),
    #                      tags$li("what we do")),
    #              h1("title of things of section 1"),
    #              p("this is things of section 1 udner h1"),
    #              
    #     ),
    #     tabPanel("section 2",
    #              h1("title of things of section 2"),
    #              p("this is things of section 1 udner h2")
    #     )
    #     
    # )
    
    navbarPage(title ="",
               
               tabPanel(strong("About US"),
                
                img(src = "vessel3.jpg", position = "center",height = 400, width = 1480),

                navlistPanel(
                    "Menu",
                    tabPanel("Who We Are",

                             h3("SunBulk Transportation is established in 2019 with the objective of becoming Asia's best marine transport
                             service provider by exploiting technology, analytics and risk management 
                             to succeed in a highly competitive and global shipping market."),
                              
                             h3("Our staff  and networks represent the key competence and mindset of SunBulk, 
                               and they are our most valuable asset.")
                               
                    ),
                    
                    tabPanel("What We Do",
                             h3("Our Business Model"),
                             img(src = "biz model.png", position = "center",height = 160, width = 950)
                    ),
                    
                    tabPanel(title = "Our Values",
                         
                         fluidRow(
                             column(3,
                                    h4("AGILE"), align = "center",
                                    img(src = "agile.jpg", height = 160, width = 190)
                                    ),
                            column(3,
                                   h4("RELIABLE"),align = "center",
                                   img(src = "reliable.jpg", height = 160, width = 190)
                                    ),
                            column(3,
                                   h4("RISK AWARE"),align = "center",
                                   img(src = "risk aware.jpg", height = 160, width = 190)
                            ),
                            column(3,
                                   h4("ENTREPRENEURIAL"),align = "center",
                                   img(src = "entre.jpg", height = 160, width = 190)
                            )


                             )
                
                    )
                    
                )
                        
               ),
               
               tabPanel(title = strong("Commercial Teams"),
                        
                    fluidRow(
                        column(4,
                               img(src = "Indian Ocean.jpg", height = 372, width = 472),
                               h1("Indian Ocean"),
                               p("The Indian Ocean team is based in the Singapore office and 
                      operated an average volume of about 30 vessels during 2019."),
                               p("The team also runs parceling operations within 
                                 Asia.")
                               
                        ),
                        
                        column(4,
                               img(src = "Far East.jpg", height = 372, width = 472),
                               h1("Far East"),
                               p("The Pacific / SE Asia team is run out of the Singapore 
                                 and operated a fleet of about 15 vessels on average during 2019."),
                               p("The team is continuously striving to develop new working relationships and expand 
                                 their business coverage.")
                        ),
                        
                        column(4,
                               img(src = "South East Asia.jpg", height = 372, width = 472),
                               h1("South East Asia"),
                               p("The South East Asia team is newly established in Singapore 
                                 and operated a fleet of about 5 vessels on average during 2019."), 
                               p("The team is rapidly
                                 expanding its relationship and business over the last year and strives to provide the best 
                                 services to the customers.")

                        )
                        
                    )
                       
               ),
               
               tabPanel(title = strong("Contact Us"),
                    sidebarLayout(position = "left",
                      sidebarPanel(
                          h3(strong("Address")),
                          wellPanel(
                              h4("10 Collyer Quay,#99-00, Ocean Financial Centre, Singapore 049315"),
                              h4("Phone: +65 xxxx xxxx"),
                              h4("Email: SunBulk@hotmail.com"),
                              
                              a("Click Here to See On Map",href = "http://goo.gl/maps/6arPuoC3nbkQEQHi8")
                          ),
                          
                     #    h3(strong("Or you may write to us:")),
                         h4(strong("Please select below for our fast response")),
                          
                          fluidRow(
                          column(6, offset = 1,
                                 selectInput('Region', 'Region', names(Region) ),
                                 selectInput('Cargo', 'Cargo', c("others", names(Cargo)) )
                                  )
                          # tags$ul("about",
                          #         tags$li("who are we"),
                          #         tags$li("what we do")),
                          # 
                          # tags$ol("about",
                          #         tags$li("who are we"),
                          #         tags$li("what we do"))
                        )
                      ),
                      
                      mainPanel(
                          h1(strong("Write To Us Below:", style = "color:Grey")),
                          textAreaInput("caption", " ", "500 words left",width = 800,height = 400)
    
                      )
                    ),
                        
                    img(src = "bottom.png", height = 120, width = 1480) 
                        
                          
               )
    )    
    
    
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$Region, {
        updateSelectInput(session, "Cargo", choices = c(1, input$Region))
        })
}

# Run the application 
shinyApp(ui = ui, server = server)