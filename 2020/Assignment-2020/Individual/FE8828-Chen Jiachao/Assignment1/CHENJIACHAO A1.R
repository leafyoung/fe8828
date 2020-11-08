library(shiny)

ui <- fluidPage(
  fluidPage(
    navbarPage(title = "Chenken",
               tabPanel("About Us", 
                        titlePanel("About us"),
                        navlistPanel(
                          tabPanel("Our story", 
                                   h1("Our Story"),
                                   p("Chenken sprouted from a snack cart in Hangzhou. The cart was quite the success, with Chenken fans lined up daily for three summers. In 2020, Chenken opened their first store downtown in September and second chain store in October.")),
                          tabPanel("Our vision",
                                   h1("Our Vision")),
                          p("Chenken aims to make the best fried chicken in China. We select everyting best in everything we do. That means carefully sourced premium ingredients from like-minded purveyors; and amazing cooking by experienced cooking staff.")
                        )),
               tabPanel("Products",
                        sidebarLayout(
                          sidebarPanel(tags$ul("Chicken",
                                               tags$li("Chicken pack"),
                                               tags$li("Chicken tender"),
                                               tags$li("Wing meals"),
                                               tags$li("Chicken nuggets")
                          ),
                          tags$ul("Others",
                                  tags$li("Drinks"),
                                  tags$li("Ice cream"),
                                  tags$li("chips")
                          )),
                          mainPanel(img(src="FriedChicken.jpg")))),
               tabPanel("Social",
                        fluidRow(
                          column(4,
                                 h2("Wechat"),
                                 img(src = "social.jpg")
                          ),
                          column(4,
                                 h2("Weibo"),
                                 img(src = "social.jpg")
                          ),
                          column(4,
                                 h2("Insgram"),
                                 img(src = "social.jpg")
                          ))),
               navbarMenu(title = "Join our team",
                          tabPanel("Our values", p("HOSPITALITY"),p("COMMUNICATION"),p("TEAMSHIP")),
                          tabPanel("Join us", "Share with us your resume to careers@chenken.cn by email.")
               )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)




