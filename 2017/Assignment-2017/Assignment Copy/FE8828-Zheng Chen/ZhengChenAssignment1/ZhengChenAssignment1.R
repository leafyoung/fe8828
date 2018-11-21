library(shiny)
ui <- fluidPage(
  fluidPage(
    navbarPage(title = "The Best Catering Company",
               tabPanel("HomePage",
                        
                sidebarPanel(
                 h4("Our Catering Company"),
                 a("A link to calculate your food energy!", href="https://www.verywell.com/calorie-counts-and-nutrition-facts-4118141"),
                 tags$ul("About us",
                         tags$li("Who are we"),
                         tags$li("What we do")
                 )
               ),
               titlePanel("Hello!"), titlePanel("Come To Enjoy the BEST Foooooood!"),
               tags$li("We--The Best Catering Company is a composite food company offering the food from allover the world."),
               tags$li("We offer delicious and health food!."),
               tags$li("Whether you want to loose or enjoy the delicious food, we are your best choice!."),
               
                 img(src = "HealthyFoodGeneric2013_large.jpg"),
                 ("_________________________________________________________________________________________________________")),
              
               tabPanel("Our Food",
                        h1("Best Food~"),
                        h3("ALL THE FOOOOOD IS DELICIOUS!!!"),
                        
                        
                        navlistPanel(
                          "Chinese Food",
                          tabPanel("Kung Pao Chicken",
                                   img(src = "gongbaojiding.jpg")),
                          tabPanel("Fish Filets in Hot Chili Oil",
                                   img(src = "shuizhuyu.jpg")
                                   ),
                          
                          tabPanel("Xiao Long Bao",
                                   img(src = "xiaolongbao.jpg")),
                          "Salad",
                          tabPanel("Fruit Salad",
                                   img(src = "Salad.jpg")),
                          tabPanel("Vegetable Salad",
                                   img(src = "veg.jpg"))
                         
                        )),
               tabPanel(title = "Contact Us",
                        
                        fluidRow(
                          titlePanel("Feel Free to Contact Us!"),
                          column(6,
                                 h3("Address"),
                                 wellPanel(
                                 tags$li("50,Nanyang Crescent."),
                                 tags$li("Nanyang Technological University."),
                                 tags$li("Code:1357246."),
                                 tags$li("In the future, there may be a lot of subbranch."),
                                 a("A link to Google Map!", href="https://www.google.com.sg"))
                                 
                          ),
                          column(6, h3("Contact Us"),
                                 wellPanel(
                                tags$li("Phone:+65-98888888."),
                                tags$li("Email:zc@gmail.com")
                                 ),
                                img(src = "good.jpg")
                          )
               ))
    )
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
}
# Run the application
shinyApp(ui = ui, server = server)