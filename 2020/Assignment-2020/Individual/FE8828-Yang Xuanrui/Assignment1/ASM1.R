library(shiny)

ui <- fluidPage(
    fluidPage(
        
        titlePanel("ABC Life Insurance,Create a Better Life for You"),
        navbarPage(title = "ABC Life Insurance",
                   tabPanel("About Us", 
                            titlePanel("Our Vision: to be the world pre-eminent life insurance provider"),
                            img(src = "insurance.png", width = "100%"),
                            fixedRow(
                                column(8,
                                       wellPanel(h3("We can help you plan and take the step needed to"),
                                                 h1("ACHIEVE YOU FINANCIAL GOALS!"),
                                                 #style = "padding: 50px;"
                                        ))
                                                     
                            ),
                            
                            fixedRow(
                            column(8,
                                   wellPanel(h2("100% FOCUSED ON CHINA MARKET"),
                                             h2("IN CHINA, FOR CHINA"),
                                             #style = "padding: 50px;"
                                   ),
                                   offset=1)  ),
                            
                            
                            fixedRow(
                                column(8,
                                       wellPanel(h2("SOLUTIONS TO MEET YOUR NEEDS"),
                                                 a("click here", href="http://baoxian.pingan.com/?WT.mc_id=T00-BD-HYDT-xz2019-gw&WT.srch=1")
                                       ),
                                       offset=2) 
                            ),
                            
                            
                            fixedRow(
                                column(8,
                                       wellPanel(h1("Special care for Covid 19")
                                       ),
                                       offset=3)
                            )
                   ),
                   
                   tabPanel(title = "Products",
                              fluidRow(
                                  column(3,
                                         h4("Products Customization"),
                                         sliderInput('Sum insured', 'Sum insured', 
                                                     min=1000, max=10000, value=min(1000, 10000), 
                                                     step=100, round=0),
                                         br(),
                                         checkboxInput('Medical', 'Medical products'),
                                         checkboxInput('Life', 'Life products')
                                  ),
                                  column(4, offset = 1,
                                         selectInput('Gender', 'Gender', c("Male","Female")),
                                         selectInput('Age', 'Age', 0:100),
                                         selectInput('Industry', 'Industry', c('Financial', 'education','government','others'))
                                  ),
                                  column(4,
                                         selectInput('Annual Salary', 'Annual Salary', c('1000-10000','10000-50000','50000-100000','>100000')),
                                         checkboxGroupInput('Benefit','Benefit',c("Death Benefit","Accident","Critical illnesses"))
                                  )
                              ),
                            hr(),
                            p("Click here to customize your insurance plan"),
                            actionButton("Customize", "Customize!"))
                            ,
                   
                   navbarMenu(title = "Contact Us",
                              tabPanel("Address", 
                                       sidebarLayout(
                                           sidebarPanel(
                                               h1("Shanghai"),
                                               wellPanel(
                                                   h2("Shanghai Central,Lujiazui")
                                               ),
                                               h1("Beijing"),
                                               wellPanel(
                                                   h2("Yintai Central, Chaoyang district")
                                               )
                                           ),
                                           mainPanel(
                                           )
                                       )),
                              tabPanel("Phone", "+123.456")),
                tabPanel("Careers",
                         titlePanel("Hello!"),
                         fluidPage(navlistPanel(
                             "Actuary",
                             tabPanel("Actuary 1", 
                                      h1("Description"),
                                      p("This is discription for Actuary 1"),
                                      actionButton("Apply1", "Apply!")),
                             tabPanel("Actuary 2",
                                      h1("Description"),
                                      p("This is discription for Actuary 2"),
                                      actionButton("Apply1", "Apply!")),
                             "Agent",
                             tabPanel("Agent 1",
                                      h1("Description"),
                                      p("This is discription for Agent 1"),
                                      actionButton("Apply1", "Apply!"))

                         ))
                    
                   )
        ),
        hr(),
        h4("Copyright 2020, ABC Group All rights reserved.")
    ))


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


