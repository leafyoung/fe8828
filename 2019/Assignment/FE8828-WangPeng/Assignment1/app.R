#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
#Author: Wang Peng
#Matriculation number: G1900398B
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Intro:This webpage is coded R Shiny, for a virtual company named "Fitness Now".
# The overall website is designed in "navBar" layout
# 1st tab: "Our Service", column-based layout
# 2nd tab: "About us", Navlist layout
# 3rd tab: "Contact us", Sidebar and Navilsit layout

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("yeti"),
  fluidPage(
    navbarPage(title = "Fitness Now",
               #1st tab
               tabPanel("Our Services",
                        titlePanel(h1("WE HAVE WHAT YOU NEED",style="color:red;font-family:Rockwell",align="center")),
                        titlePanel(h3("Make your first move!",style="color:red;font-family:'Lucida Calligraphy'",align="center")),
                        fluidPage(
                          fluidPage(
                            fluidRow(
                              column(12,
                                     img(src = "fitness.jpg", height="400",width = "100%",align="center")
                              )
                            ),
                            h3("You can find everything you need here for your fitness journey.",style="color:navy;font-family:Elephant",align="center"),
                            fluidRow(
                              column(4,
                                     wellPanel(h3("Classes",style="color:navy;font-family:Rockwell",align="center"),style = "padding: 1px", align="center"),
                                    wellPanel(p("If you love the energy of group workouts, we have class that will fit you.",style="font-family:Rockwell")),
                                     wellPanel(img(src = "classes.jpg", height="100%",width = "100%",align="center"))
                                     
                              ),
                              column(4,
                                     wellPanel(h3("Clubs" ,style="color:navy;font-family:Rockwell",align="center"),style = "padding: 1px", align="center"),
                                     wellPanel(p("Our clubs have cutting-edge equipment to take your workout to the next level.",style="font-family:Rockwell")),
                                     wellPanel(img(src = "clubs.jpg", height="100%",width = "100%",align="center"))
                              ),
                              column(4,
                                     wellPanel(h3("Timetable",style="color:navy;font-family:Rockwell",align="center"),style = "padding: 1px", align="center"),
                                     wellPanel(p("Looking for a class to fit your schedule? Our comprehensive timetable is perfect for you",style="font-family:Rockwell")),
                                     wellPanel(img(src = "timetable.jpg", height="100%",width = "100%",align="center"))
                              )
                            )
                        
                        )
                        )
                        ),
               #2nd tab
               tabPanel("About us",
                        titlePanel(h1("WHAT'S HAPPENING",style="color:Navy;font-family:Rockwell")),
                        h3("Catch up with what's going on at Fitness Now.",style="color:navy;font-family:Rockwell"),
                        fluidPage(
                          titlePanel(h3("ALL ANOUNCEMENTS",style="font-family:Rockwell",align="left")),
                          navlistPanel(
                        
                            tabPanel("EVENTS",
                                     h4("Intermediate Handstand Workshop-31 Aug",style="font-family:Rockwell"),
                                     p("Take your handstand practice to the next level at Fitness First One Raffles Quay! Join us and master the art of handstands in our 2-hour workshop designed for people with handstand practice experience. Defy gravity with us and see the full schedule.",style="font-family:'Copper Black'"),
                                     h4("New Series of Pro Cycling",style="font-family:Rockwell"),
                                     p("Be the first to ride with us on the brand new Pro Cycling 2.0! Hop on and ride with the pack in the brand new series of Pro Cycling, where high energy music will take you places you've never been. Coming to you in September - check out the full schedule", tags$u("here",style="font-family:'Elephant'"),". See you on the bikes!",style="font-family:'Copper Black'"),
                                     p("More", style="font-family:Elephant")                               ),
                            tabPanel("HIGHLIGHTS",
                                     h4("DNA TESTING FOR OPTIMAL PERFORMANCE, WEIGHT LOSS & NUTRITION",style="font-family:Rockwell"),
                                     p("Knowing your unique genetic details empowers you to make informed decisions, and take out the guesswork of how you should pursue fitness. Discover even more about  what your genes say about appetite, behaviour, stress and more. With a simple cheek swab, discover the following key factors from the test. ",style="font-family:'Copper Black'"),
                                     h4("What is AIA Vitality?",style="font-family:Rockwell"),
                                     p("AIA Vitality encourages and rewards you for living well. The programme takes a comprehensive approach to provide you with the tools and support to understand your health, how to improve it and offer great incentives to motivate you along the way.",style="font-family:'Copper Black'"),
                                     p("More", style="font-family:Elephant")
                                     )
                          )
                        )
                   ),
               navbarMenu(title = "Contact Us",
                          tabPanel("Address",
                                   fluidPage(sidebarLayout(
                                     sidebarPanel(
                                       h3("Our location",style="font-family:Elephant"),
                                       
                                       wellPanel(
                                         h4("Nanyang Technological University",style="font-family:'Rockwell'",align="center"),
                                         h4("Nanyang Crescent 64",style="font-family:'Rockwell'",align="center"),
                                         h4("Singapore",style="font-family:'Rockwell'",align="center"),
                                         h4("Postal code: 636959",style="font-family:'Rockwell'",align="center")
                                       ),
                                                width = 4
                                     
                                                ),
                                     
                                     
                                     mainPanel(img(src = "map.jpg", height="100%",width = "100%"))
                                   ))
                                   
                          
                                   ),
                          tabPanel("Talk to us",
                                   
                                   fluidPage(
                                     titlePanel(h1("Send us a message",style="font-family:'Rockwell'")),
                                     navlistPanel(
                                       
                                       tabPanel("Qustionnaire",
                                                
                                                textInput("newQuestion","First Name*", "e.g. Pierre"),
                                                textInput("newQuestion","Last Name*",  "e.g. Wang"),                               
                                                textInput("newQuestion","Mobile Number*", "e.g. +65 8888 8888"),
                                                textInput("newQuestion","Email*", "e.g. wangpengmfe@gmail.com"),
                                                textInput("newQuestion","Membership Number*"),
                                                textInput("newQuestion","I would like to talk about*"),
                                                textInput("newQuestion","Comment"),
                                                p("Please note that your personal information will only be shared with our marketing department",style="color:red;font-family:'Rockwell'",align="center"),
                                                actionButton("goButton", "Submit")
                                       ),
                                       tabPanel("Find Us",
                                                h4("Wechat",style="font-family:'Rockwell'"),
                                                
                                                a("Find Fitness Now on Wechat ", href="https://mp.weixin.qq.com/cgi-bin/loginpage"),
                                                img(src = "wechat.jpg", height="40",width = "40"),
                                                h4("Facebook",style="font-family:'Rockwell'"),
                                                a("Find Fitness Now on Facebook",href="https://www.facebook.com"),
                                                img(src = "facebook.jpg", height="40",width = "40"),
                                                h4("Instagram",style="font-family:'Rockwell'"),
                                                a("Find Fitness Now on Instagram",href="https://www.instagram.com"),
                                                img(src = "ins.jpg", height="40",width = "40")
                                                
                                                )
                                     )
                                   ))
               )
    )
  
)
)



    


# Define server logic required to draw a histogram
server <- function(input, output) {

   
}

# Run the application 
shinyApp(ui = ui, server = server)
