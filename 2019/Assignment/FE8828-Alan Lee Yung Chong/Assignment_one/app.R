library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage(title = "PerfFit",
             # first panel tab.
             tabPanel("Home",
                      # Hero area
                      fluidRow(column(10, align="center", offset = 1,
                                      column( 12, img(src = "https://studybreaks.com/wp-content/uploads/2018/04/Stitch-Fix-feature-image.jpg",
                                                      width = "100%")
                                      )
                      )
                      ),
                      # This will be product
                      column(10, align="center", offset =1, 
                             h1("PerfFit surprises you with clothes that you never thought would fit you."),
                             column (10, align = "center", offset = 1, br(), h3("Enpowered by the cutting edge machine-learning agorithms, 
                                                                                we help you choose clothes that fits you to your preference, location and taste.
                                                                                We are here to help if you are looking for wardrobe revamp or simply like surpises.")
                                     , br(), br())
                             ),
                      fluidRow(
                        column(12, align="center", style = "background-color:#45454d;",
                               div(br(), h1("How It Works?"), style = "color:#FFFFFF; ,border_right: 1px solid red")
                        )
                      ),# How does it works?
                      fluidRow(
                        column(4, align="center", style = "background-color:#45454d;",  
                               div(h1("Step 1"), style="color:#FFF"),
                               div(h3("FILL OUT YOUR STYLE PROFILE", style="color:#FFF")),
                               column(8, align="center", offset=2,
                                      div(h4("Share your fit and style preferences and set the price range that suits your lifestyle."),br(), br())),
                               style="color:#FFF"),
                        column(4, align="center", style = "background-color:#45454d;",  
                               div(h1("Step 2"), style="color:#FFF"),
                               div(h3("REQUEST A FIX DELIVERY", style="color:#FFF")),
                               column(8, align="center", offset=2,
                                      div(h4("You pay a $20 styling fee for each shipment, which is credited toward anything you keep."),br(), br())),
                               style="color:#FFF"),
                        column(4, align="center", style = "background-color:#45454d;",  
                               div(h1("Step 3"), style="color:#FFF"),
                               div(h3("TRY BEFORE YOU BUY", style="color:#FFF")),
                               column(8, align="center", offset=2,
                                      div(h4("Buy what you like, send back the rest. Shipping and returns are free and easy."), br(), br())),
                               style="color:#FFF")
                      ), # end of the how it work section
                      fluidRow(column(12, align="center",
                                      div(h2("Follow Us On Social Media!"), br(),br() )
                      ), # paste all social media icon.
                      column(3, align="center",
                             img(src="https://image.flaticon.com/icons/svg/1051/1051258.svg", height="20%", width="20%")
                      ),
                      column(3, align="center",
                             img(src="https://image.flaticon.com/icons/svg/1051/1051262.svg", height="20%", width="20%")
                      ),
                      column(3, align="center",
                             img(src="https://image.flaticon.com/icons/svg/1051/1051280.svg", height="20%", width="20%")
                      ),
                      column(3, align="center",
                             img(src="https://image.flaticon.com/icons/svg/1051/1051282.svg", height="20%", width="20%")
                      ),
                      column(12, align="left")
                      ,
                      column(12, align="left", div(br(), br(),h5("Copyright @ PerfFit 2019"))
                      )
                      ) # end of bottom section.
                             ), # end of first page
             tabPanel("About Us",
                      #person 1
                      fluidRow(
                        column(12, align="center", titlePanel("Meet The Extraordinary People"),  br(), br()),
                        column(4, offset=2, img(src="https://image.freepik.com/free-photo/blond-man-happy-expression_1194-2873.jpg", height="100%", width = "100%")),
                        column(4, offset=0, div(h3("Joe Willi, Chief Executive Officer, Co-founder"), br(), br(), h4("Joe holds a B.A. in Business Administration and an M.A. in Finance from Wollongong University. 
                                                                                                                     He is passionate in dressing people in the right clothes and empowering people to feel good. Lorem ipsum dolor sit amet, 
                                                                                                                     consectetur adipiscing elit. Vestibulum eget ex non libero vehicula vehicula non vel tortor. In dignissim.
                                                                                                                     He has vast experience in start-up management and marketing.")))
                        ),
                      #person 2
                      fluidRow(
                        br(), br(),
                        column(4, offset=2, align="center", img(src="https://image.freepik.com/free-photo/travel-concept-close-up-portrait-young-beautiful-attractive-redhair-girl-wtih-trendy-hat-sunglass-smiling-blue-pastel-background-copy-space_1258-852.jpg", height="100%", width = "100%")),
                        column(4, offset=0, div(h3("Orel Har Zahav, Chief Marketing Officer, Co-founder"), br(), br(), h4("Orel holds a B.A. in Marketing and an M.A. in Business from Tel Aviv University. 
                                                                                                                          . She likes to explore the city in search of good food.Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                                                                                                                          Vestibulum eget ex non libero vehicula vehicula non vel tortor. In dignissim.
                                                                                                                          She has vast experience in conducting marketing campaigns.")))
                        ),
                      #thrid person
                      fluidRow(
                        br(), br(),
                        column(4, offset=2, align="center", img(src="https://image.freepik.com/free-photo/portrait-beautiful-young-woman-against-blurred-plants_23-2148049574.jpg", height="100%", width = "100%")),
                        column(4, offset=0, div(h3("Christina Bale, Chief Operating Officer"), br(), br(), h4("Christina holds a B.A. in Fashion Design and an M.A. in Business from Tel Aviv University. 
                                                                                                              . She likes to explore the city of Vatican in search of good food.Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                                                                                                              Vestibulum eget ex non libero vehicula vehicula non vel tortor. In dignissim.Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                                                                                                              Vestibulum eget ex non libero vehicula vehicula non vel tortor
                                                                                                              .")))
                        ),
                      #fourth person https://image.freepik.com/free-photo/positive-asian-man-pointing-finger-aside_1262-18275.jpg
                      fluidRow(
                        br(), br(),
                        column(4, offset=2, align="center", img(src="https://image.freepik.com/free-photo/positive-asian-man-pointing-finger-aside_1262-18275.jpg", height="100%", width = "100%")),
                        column(4, offset=0, div(h3("Li Ying Nan, Chief Intelligence Officer"), br(), br(), h4("Ying Nan holds a B.A. in Electrical Engineering and an PhD in Electrical Engineering from National University of Singapore. 
                                                                                                                . He codes for a living and love the models, machine-learning ones.Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                                                                                                                Vestibulum eget ex non libero vehicula vehicula non vel tortor. In dignissim.Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                                                                                                                Vestibulum eget ex non libero vehicula vehicula non vel tortor
                                                                                                                .")))
                      ),
                      column(12, align="left", div(br(), br(),h5("Copyright @ PerfFit 2019")))
                        ), #end of second page
                      tabPanel("Contact Us",
                              column(12, align="center", titlePanel("Contact Us And Leave Us Any Questions You Have!"),  br(), br()),
                              column(4,offset=2,align="center",
                                     img(src="https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_825,c_limit/GoogleMapTA.jpg", size="100%", width="100%")),
                              column(4, align = "left",
                                     div(h3("Find Us Here!"), br(),  h4("295 Madison Avenue, 12th Floor, New York, NY 10017   |   212.972.6990 "),
                                     br(), h4("Hamenofim 2, Seaview Building B, Floor 5, Herzliya, Israel 4672553  |  +972.9779.2500"), br(), br(),
                                        # input text box
                                     h4("Have a question?"),
                                     textInput(inputId="hello", label=NULL, value = "", width = "100%",
                                               placeholder = "Type something! we will get back to you real soon!"), actionButton("button", "Send")
                                         )
                              ), 
                              column(12, align="left", div(br(), br(),h5("Copyright @ PerfFit 2019")))
                          )
                        )
                      )# close everything

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

