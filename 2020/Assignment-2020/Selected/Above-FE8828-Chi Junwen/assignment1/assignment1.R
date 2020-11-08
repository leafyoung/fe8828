

library(shiny)

ui <- fluidPage(
    navbarPage(title = "Baoleme Technology",
               tabPanel("About us", 
                        
                        fluidPage(titlePanel("Hello, here is Baoleme, your private insurance steward!"),
                                  navlistPanel(
                                      "Brief Introduction",
                                      tabPanel("Logo", 
                                               div(img(src = "logo.png",width="60%",align = "center"),style="text-align: center;")),
                                      tabPanel("Cofounders",
                                              tags$ul("Cofounders",tags$li("xxx"),tags$li("yyy"),tags$li("zzz"),style = "font-size:40px;",align="left")
                                              ),
                                      tabPanel("Date of Establishment", 
                                               p("2020-9-20",style = "font-size:40px;",align="center"),
                                               p("The company has established for",strong(Sys.Date()-as.Date("2020-9-20")),"days",style = "font-size:20px;",align="center")),
                                      "Enterprise Culture",
                                      tabPanel("Slogan",
                                               h1("Your private insurance steward!")),
                                      
                                      tabPanel("Service Principle",
                                               p("Peace and love.",style = "font-size:40px;",align="center"))
                                  ),
                                  
                                  )),
               tabPanel("Main Services",
                        fluidPage(titlePanel("Baoleme mainly provides three services."),
                                  div(img(src = "insurance.jpg",width="40%",align = "center"),style="text-align: center;"),
                                  fluidRow(
                                    column(4,
                                           wellPanel(h3("Personnal Insurance Enquiry"),
                                                     tags$p("Baolema mainly create an insurance enquiry platform for those who need to quickly get information about their insurance policies. All you need is to provide some basic personnal information like name, gender, ID card number so that we can get access to data platform of insurance company through our search engine like Baidu or Google. The result will be compiled and shown in our applet of wechat. This is an easier and more convenient way for you to manage your insurance policies. ")
                                           )),
                                    column(4,
                                           wellPanel(h3("Insurance knowledge share"),
                                                     tags$p("We will periodically share some insurance knowledge popularization articles to help our customers know more about complicated insurance knowledge in a way that's easy to understand like comics.")
                                           )),
                                    column(4,
                                           wellPanel(h3("Dianping for insurance product"),
                                                     tags$p("We also initiate a kind of service like Dianping in insurance product to provide a platform for our customers to comment on some certains insurance. In this way, customers can get some objective views for them to judge a insurance product.")
                                           ))                          
                                  ) ))
               ,
               navbarMenu(title = "Contact Us",
                          tabPanel("Address", 
                                    sidebarLayout(
                                      mainPanel(h1("Headquarter",align="center"),
                                                   p("Nanyang technological university",style = "font-size:20px;",align="center"),
                                                   div(actionButton("goButton", "Google Map",align="center"),style="text-align: center;"),
                                                    p("  "),
                                                   div(img(src = "NTU.jpg",width="60%",align = "center"),style="text-align: center;")),
                                      sidebarPanel(h1("Branch",align="center"),
                                                p("UIBE",style = "font-size:20px;",align="center"),
                                                div(actionButton("goButton", "Google Map"),style="text-align: center;"),
                                                p("  "),
                                                div(img(src = "UIBE.jpg",width="60%",align = "center"),style="text-align: center;")),
                                      
                                    )
                                   ),
                          tabPanel("Phone", p("Contact us:","15611505766",style = "font-size:40px;",align="center"))
               )
    )
)


server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
