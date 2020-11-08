library(shiny)

ui <- fluidPage(
  
  fixedRow(
    column(12,
           img(src = "https://cdn.pixabay.com/photo/2015/12/10/05/03/kitchen-1085990_960_720.png", width="100%", height = "100")
    )
  ),
  
  "~",
  
  navbarPage(title = "AutoKitchen",
             
             navbarMenu(title = "Product Offerings",
                        
                        tabPanel("Home",
                                 navlistPanel(
                                   
                                   "Kitchens",
                                   tabPanel("Room-Sized", 
                                            fluidRow(
                                              column(6,
                                                     wellPanel(
                                                       h3("Room-sized Kitchen"),
                                                       tags$li("Revamp your kitchen to an automated workhorse wonder."),
                                                       tags$li("Invite all your friends often for dinner and never dread the large family gatherings again.")
                                                     )
                                              ),
                                              column(6,
                                                     img(src = "https://images.pexels.com/photos/534151/pexels-photo-534151.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940", width="100%")
                                              )
                                            )),
                                   
                                   tabPanel("Corner-Sized",
                                            fluidRow(
                                              column(6,
                                                     wellPanel(
                                                       h3("Corner-sized Kitchen"),
                                                       tags$li("A small neat corner in your cosy nest."),
                                                       tags$li("Kickback after work every day and relax as your kitchen prepares your dinner for you.")
                                                     )
                                              ),
                                              column(6,
                                                     img(src = "https://images.pexels.com/photos/94865/pexels-photo-94865.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940", width="100%")
                                              )
                                            )),
                                   
                                   widths = c(2,10)
                                   
                                  )
                        ),
                        
                        tabPanel("Commercial",
                                 navlistPanel(
                                   
                                   "Shopfront",
                                   tabPanel("Restaurant", 
                                            fluidRow(
                                              column(6,
                                                     wellPanel(
                                                       h3("Restaurant"),
                                                       tags$li("Fulfill tight dinner orders while easily keeping the whole place in tip top cleanliness and compliance."),
                                                       tags$li("Let your dishes be consistent and impress customers with fast serve times.")
                                                     )
                                              ),
                                              column(6,
                                                     img(src = "https://images.unsplash.com/photo-1557955776-857434f1c951?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80", width="100%")
                                              )
                                            )),
                                   
                                   tabPanel("Bar",
                                            fluidRow(
                                              column(6,
                                                     wellPanel(
                                                       h3("Bar"),
                                                       tags$li("Wow patrons with the chic and flashy drink mixing."),
                                                       tags$li("Deliver precise mixing to perfection.")
                                                     )
                                              ),
                                              column(6,
                                                     img(src = "https://images.unsplash.com/photo-1553678324-f84674bd7b24?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1534&q=80", width="100%")
                                              )
                                            )),
                                   
                                   "Mobile",
                                   tabPanel("Mobile Van",
                                            fluidRow(
                                              column(6,
                                                     wellPanel(
                                                       h3("Mobile Van"),
                                                       tags$li("Increase your throughput in the hectic lunch hours."),
                                                       tags$li("Let the kitchen churn out the meals as you tend to your customers.")
                                                     )
                                              ),
                                              column(6,
                                                     img(src = "https://cdn.pixabay.com/photo/2017/06/23/21/37/oldtimer-2436018_960_720.jpg", width="100%")
                                              )
                                            )),
                                   
                                   widths = c(2,10)
                                 )
                        )
              ),
                        
             tabPanel("About Us",
                      
                      fluidRow(
                        
                        column(5,
                               img(src = "https://images.pexels.com/photos/1080721/pexels-photo-1080721.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940", width="100%")
                        ),
                        
                        column(7,
                               h2("Who are we?"),
                               p("We are a group of students from NTU who decided that cooking needs to be revolutionized."),
                               p("AutoKitchen was borned from the idea that making a meal should be efficient, mess-less and fuss-free."),
                               p("Leveraging on AI, we bring our industrial design to express the art of cooking."),
                               p("With our team, we will work with you closely to develope unique solutions for your cooking needs whether it's for home or commercial purpose."),
                               p("AutoKitchen makes sure that every dish that comes out is cooked to perfection.")
                        )
  
                      )
              ),
             
             tabPanel("Contact Us",
                      
                      navlistPanel(
                        
                        tabPanel("Location",
                                 fluidRow(
                                   column(6,
                                          wellPanel(
                                            h3("We are at:"),
                                            p("Nanyang Technological University"),
                                            p("Nanyang Business School"),
                                            p("Block S3, Level B3A"),
                                            p("52 Nanyang Ave"),
                                            p("Singapore 639798"),
                                            a("Website", href = "https://nbs.ntu.edu.sg/Pages/default.aspx")
                                          )
                                   ),
                                   column(6,
                                          img(src = "http://news.ntu.edu.sg/News/PublishingImages/The%20Arc.jpg", width="100%")
                                   )
                                 )
                        ),
                        
                        tabPanel("Contact",
                                 column(6,
                                   wellPanel(
                                     h3("Email"),
                                     p("zxiang002@e.ntu.edu.sg"),
                                     h3("Phone Number"),
                                     p("6790 4667")
                                   )
                                 )
                        ),

                        widths = c(2,10)
                        
                      )
             )
        )
  )


server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
