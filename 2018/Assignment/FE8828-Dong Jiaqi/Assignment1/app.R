#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyalert)

# Define UI for application that draws a histogram
ui <- fluidPage(
   fluidPage(
     navbarPage(title = "Red Panda Conservatory",
                tabPanel("About Us",
                         titlePanel("Welcome to Red Panda Conservatory"),
                         navlistPanel(
                           "About US",
                           tabPanel("Red Panda",
                                    style = "font-family: 'Times New Roman'",
                                    h3("WHO AM I?"),
                                    h4("The red panda (Ailurus fulgens) is a mammal native to the eastern Himalayas and southwestern China. It is listed as Endangered on the IUCN Red List, because the wild population is estimated at fewer than 10,000 mature individuals and continues to decline due to habitat loss and fragmentation, poaching, and inbreeding depression.
                                       The red panda has reddish-brown fur, a long, shaggy tail, and a waddling gait due to its shorter front legs; it is roughly the size of a domestic cat, though with a longer body and somewhat heavier. It is arboreal, feeds mainly on bamboo, but also eats eggs, birds, and insects. It is a solitary animal, mainly active from dusk to dawn, and is largely sedentary during the day. It is also called the lesser panda, the red bear-cat, and the red cat-bear."
                                        ),
                                    img(src = "1.jpg"),
                                    h3("WHY PROTECT ME?"),
                                    h4("The red panda is listed in CITES Appendix I.The species has been classified as endangered in the IUCN Red List since 2008 because the global population is estimated at about 10,000 individuals, with a decreasing population trend; only about half of the total area of potential habitat of 142,000 km2 (55,000 sq mi) is actually being used by the species. Due to their shy and secretive nature, and their largely nocturnal habits, observation of red pandas is difficult.")
                                    ),
                           tabPanel("Our Mission",
                                    style = "font-family: 'Times New Roman'",
                                    h4("We aim to protect this little and cute species from Research, Education, and Conservation."),
                                    img(src = "2.jpg",height = 225, width = 300,style="display: block; margin-left: auto; margin-right: auto;"),
                                    tags$ul(
                                            tags$li(h4(strong("Research"))),
                                            h4("We implemented the world first community-based red panda monitoring program and completed the first national red panda survey."),
                                            tags$li(h4(strong("Education"))),
                                            h4("Our education and outreach programs focus on increasing awareness among red panda range communities, as well as among the general public worldwide."),
                                            h4("Communities living in and around red panda habitat are often marginalized and have inadequate education opportunities. We provides this education through forest guardian workshops where participants receive educational training about the importance of red pandas to the eastern Himalayan ecosystem. Some workshop participants are hired as Forest Guardians who work within their communities to increase awareness of red pandas. "),
                                            tags$li(h4(strong("Conservation"))),
                                            h4("Approximately 38% of the total potential red panda habitat is in Nepal. We work with yak herders and other community groups to reduce human impact on the red pandas fragile habitat. Any person found guilty of killing, buying or selling red pandas faces a fine of up to $1,000 and/or up to 10 years in jail. Other community initiatives to stop the hunting and capture of red pandas for income include: making yak dung briquettes and creating tourism packages"))
                           ),
                           tabPanel("Relevant Website",
                                    navlistPanel(
                                    tabPanel(
                                      "Wikipedia",
                                       a(h3("The link to Wikipedia"), href="https://en.wikipedia.org/wiki/Red_panda"),
                                      br(),
                                      img(src = '9.png',height = 200, width = 160) 
                                      ),
                                    tabPanel(
                                      "World Wide Fund",
                                      a(h3("The link to WWF"), href="https://www.worldwildlife.org/species/red-panda"),
                                      img(src = '8.png',height = 200, width = 190)
                                      ),
                                    tabPanel(
                                      "National Geographic",
                                      a(h3("The link to National Geographic"), href ="https://www.nationalgeographic.com/animals/mammals/r/red-panda/"),
                                      img(src = '7.png',height = 120, width = 400)
                                      )
                                    )
                                    )
                         ),
                         hr(),
                         print("Created by Dong Jiaqi")
                         ),
                tabPanel("Join In Us",
                         titlePanel("What you can do here"),
                         fluidRow(
                           column(4,
                                  wellPanel(
                                    HTML(
                                      paste(
                                        h3("Exploratory Travel"),
                                        '<br/>',
                                        img(src="6.jpg",height = 150, width = 220,style="display: block; margin-right: auto; margin-left: auto"),
                                        '<br/>',
                                        "Join us for a journey-of-a-lifetime to visit red pandas in the wild. This trip will take you into the cloud forests and communities of the Himalayas. You will see breathtaking views of Mount Everest and will be exploring one of the most biologically diverse areas in the world. We will hike through some of the Eastern Himalayas most pristine forests in search of one of Asia  most elusive mammals: the red panda. We will also look out for bears, clouded leopards, monkeys, macaques, and other rare mammal and bird species.",
                                        '<br/>',
                                        '<br/>',
                                        "You will experience the gentle hospitality of family homestays and tea houses, which are far removed from mass tourism. You will see first hand our community-based conservation work, and how your stay benefits directly our most important conservation partners: the rural communities who need alternatives to forest exploitation.",
                                        '<br/>'
                                        )
                                    ),
                                    br(),
                                  dateInput("date", "Please input the date for checking the availability"),
                                  actionButton("OK", "OK")
                              
                                    )
                            ),
                           column(4,
                                  wellPanel(
                                    HTML(
                                      paste(
                                        h3("Adopt A Panda"),
                                        '<br/>',
                                        img(src="3.jpeg",height = 100, width = 150,style="display: block; margin-right: auto;"),
                                        h4("Adopted Tenzing"),
                                        "Tenzing comes from the famous Nepalese climber, Tenzing Norgay, who was the first to summit Mt. Everest. Red panda Tenzing lives in the mid-hills of the Kanchenjunga Mountains that also serves as home to villages that depend on his forest for survival.",
                                        '<br/>',
                                        "------------------------------------------",
                                        img(src="4.jpg",height = 100, width = 150,style="display: block; margin-right: auto;"),
                                        h4("Adopted Alice"),
                                        "Alice mother is Siya and her father is Bhim. She lives in the Surke forest of Ilam district in eastern Nepal. She has had to adapt to the increasing development of this region as tea production has become a major use of land in the area.",
                                        '<br/>',
                                        "------------------------------------------",
                                        img(src="5.jpeg",height = 100, width = 150,style="display: block; margin-right: auto;"),
                                        h4("Adopt Pinju"),
                                        "He lives in the proposed Panchthar-Ilam-Singhalila Red Panda Protected Forest in eastern Nepal. He is a young male. In addition to bamboo, he enjoys eating sorbus fruits from mountain ash trees.",
                                        '<br/>',
                                        "------------------------------------------",
                                        "For more information, please contact us"
                                      )
                                    )
                                  )
                            ),
                           column(4,
                                  wellPanel(
                                    HTML(
                                      paste(
                                        h3("Donation"),
                                        "Join the network committed to conserving red pandas and their habitat. Your gift will help secure a sustainable future for red pandas, and the people and wildlife who share their home."
                                      )
                                    ),
                                  h3("Make a Donation"),
                                  sliderInput("obs", "Choose the amount you want to donate", 0, 100, 50),
                                  useShinyalert(),
                                  actionButton("donate", "Donate!"),
                                  br(),
                                  verbatimTextOutput("print_action")
                                  )
                            )),
                           hr(),
                           print("Created by Dong Jiaqi")
                            ),
                navbarMenu(title = "Contact Us",
                           tabPanel("Address",
                                    titlePanel("Address"),
                                    sidebarLayout(
                                      sidebarPanel(
                                        width = 6,
                                        h3("Beijing Office:"),
                                        h5("DongCheng District, Beijing, China"),
                                        h3("Shanghai Office:"),
                                        h5("Xuhui District, Shanghai, China"),
                                        h3("Singapore Office:"),
                                        h5("38 Nanyang Crescent, Singapore")
                                        
                                      ),
                                    mainPanel(
                                      
                                    ))),
                           tabPanel("Phone", 
                                    titlePanel("Phone"),
                                    sidebarLayout(
                                      sidebarPanel(
                                        width =6,
                                        icon = "home",
                                        h3("Beijing Office:"),
                                        h5("+86-010-11111111"),
                                        h3("Shanghai Office:"),
                                        h5("+86-021-22222222"),
                                        h3("Singapore Office:"),
                                        h5("+65-88886666")
                                      ),
                                      mainPanel("Thank you for visiting us.")
                                    ))
                           )
   )
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observeEvent(input$donate, {
    # Show a modal when the button is pressed
    shinyalert("Thank You", "You are very nice guy. God bless you.", type = "")
  })
  observeEvent(input$OK, {
    # Show a modal when the button is pressed
    shinyalert("Thank You", "We have booked the trip for you!", type = "")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

