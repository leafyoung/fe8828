#
# Created by Yuan Yuxuan
#


library(shiny)
library(shinythemes)
library(leaflet)
library(shinyalert)

ui <- fluidPage(

    useShinyalert(), 
    navbarPage(
        theme = shinytheme("flatly"),
        "Jady&Kun     ",
        tabPanel("About Us",
            sidebarLayout(position = "right",
                sidebarPanel(
                   h2("Make reservation"),
                   textInput("name", "Name:"),
                   textInput("contact", "Phone Number:"),
                   textInput("contact", "Email:"),
                   selectInput("guestnumber", "Number of guest:", "2", choices = c("2", "3", "4", "5", "6", "7", "8")),
                   dateInput("date", "Dining date:"),
                   selectInput("time", "Dining time:", "11:30am", choices = c("11:00am", "12:00pm", "1:00pm", "2:00pm", "3:00pm", "6:00pm", "7:00pm", "8:00pm", "9:00pm", "10:00pm")),
                   actionButton("submit", "Submit Reservation", class = "btn-primary")
                ),
       mainPanel(
           img(src = "AboutUs.jpg", width = "100%"),
           br(),
           br(),
           tabsetPanel(
               tabPanel("Culture",
                        h2("Communication is a must in order to establish trust among people, and Chines food is a perfect choice for social network at table. Jady&Kun is committed to encouraging more people to chat with each other and enjoy their food at table, and creatiing a kind of table culture favoured by the youth around the world so as to invite more people to", align="center"),
                        h1("\"Have Fun At Jady&Kun\"", align = "center")
               ),
               tabPanel("History", 
                        h5("Jady&Kun (Chinese: 玉锟) is a restaurant in Singapore specialising in Teochew Porridge, Qingdao Dumpling and homemade traditional Nanyang beverages. "),
                        h5("First opened in 2021 with an outlet at the Toa Payoh Centre, Jady&Kun plans to open additional five outlets in the city and in the suburban areas of Serangoon Gardens and the Singapore Indoor Stadium."),
                        h5("Jady&Kun works closely with the Singapore Tourism Board to promote Chinese food and local dishes such as Nanyang Kopi, Plain Porridge, Braised Pig Intestine, Cuttlefish Dumpling and Wonton.")
                        )
           )
       )
                       
                   )
                 ),
                 
                 

        tabPanel("Menu",
                 navlistPanel(
                     widths = c(2, 10),
                     tabPanel("Teochew Porridge", 
                              br(),
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Sweet Potato Porridge", align = "center"),
                                             img(src = "Sweet-Potato-Congee-1.jpg", width = "100%"),
                                             h4("$3", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Teochew Fishcake", align = "center"),
                                             img(src = "Teochew Fishcake.jpg", width = "100%"),
                                             h4("$6", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Teochew Braised Duck", align = "center"),
                                             img(src = "Teochew Braised Duck.jpg", width = "100%"),
                                             h4("$7", align = "center")
                                         ))
                              ),
                              
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Braised Pig Intestine", align = "center"),
                                             img(src = "Braised Pig Intestine.jpg", width = "100%"),
                                             h4("$12", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Plain Porridge", align = "center"),
                                             img(src = "Plain Porridge.jpg", width = "100%"),
                                             h4("$2", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Chap Chai", align = "center"),
                                             img(src = "Chap Chai.jpg", width = "100%"),
                                             h4("$7", align = "center")
                                         ))
                              ),
                              
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Salted Egg", align = "center"),
                                             img(src = "Salted Egg.jpg", width = "100%"),
                                             h4("$2", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Braised Beancurd", align = "center"),
                                             img(src = "Braised Beancurd.jpg", width = "100%"),
                                             h4("$4", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #deebfa",
                                             h4("Braised Chicken Feet", align = "center"),
                                             img(src = "Braised Chicken Feet.jpg", width = "100%"),
                                             h4("$8", align = "center")
                                         ))
                              )
                     ),
                     
                     tabPanel("Qingdao Dumpling",
                              br(),
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Wonton", align = "center"),
                                             img(src = "Wonton.jpg", width = "100%"),
                                             h4("$8", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Gyoza", align = "center"),
                                             img(src = "Gyoza.jpg", width = "100%"),
                                             h4("$8", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Xiao Long Bao", align = "center"),
                                             img(src = "Xiao Long Bao.jpg", width = "100%"),
                                             h4("$8", align = "center")
                                         ))
                              ),
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Oyster&Pork Dumpling", align = "center"),
                                             img(src = "IMG_7651.jpg", width = "100%"),
                                             h4("$10", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Batang Fish Dumpling", align = "center"),
                                             img(src = "IMG_7652.jpg", width = "100%"),
                                             h4("$10", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Prawn&Cucumber Dumpling", align = "center"),
                                             img(src = "IMG_7653.jpg", width = "100%"),
                                             h4("$9", align = "center")
                                         ))
                              ),
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Preserved Vegetable&Pork Dumpling", align = "center"),
                                             img(src = "IMG_7654.jpg", width = "100%"),
                                             h4("$7", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Chives & Port Dumpling", align = "center"),
                                             img(src = "IMG_7655.jpg", width = "100%"),
                                             h4("$7", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #faedde",
                                             h4("Cuttlefish Dumpling", align = "center"),
                                             img(src = "IMG_7656.jpg", width = "100%"),
                                             h4("$10", align = "center")
                                         ))
                              )
                     ),
                     
                     tabPanel("Homemade Beverages", 
                              br(),
                              fluidRow(
                                  column(12,
                                         wellPanel(
                                             style = "background: white",
                                             h4("Local Kopi", align = "center"),
                                             img(src = "Kopi.png", width = "100%"),
                                             h4("$2", align = "center")
                                         ))
                              ),
                              fluidRow(
                                  column(4,
                                         wellPanel(
                                             style = "background: #fadfde",
                                             h4("Barley Water", align = "center"),
                                             img(src = "Barley Water.jpg", width = "100%"),
                                             h4("$2", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #fadfde",
                                             h4("Lemonade", align = "center"),
                                             img(src = "Lemonade.jpg", width = "100%"),
                                             h4("$2", align = "center")
                                         )),
                                  
                                  column(4,
                                         wellPanel(
                                             style = "background: #fadfde",
                                             h4("Sour Plum Juice", align = "center"),
                                             img(src = "Sour Plum Juice.jpg", width = "100%"),
                                             h4("$3", align = "center")
                                         ))
                              ))
                 )),
        tabPanel("Find Us", 
                 fluidRow(
                     column(6,
                            wellPanel(
                                style = "background: white",
                                h4("Contact us"),
                                br(),
                                h5("Email us"),
                                h6("Customer Service: ", a(href="mailto:cs_jady_kun2019@gmail.com", "cs_jady_kun2019@gmail.com"), "(Click to write email)"),
                                h6("Business Collaboration: ", a(href="mailto:biz_jady_kun2019@gmail.com", "biz_jady_kun2019@gmail.com"), "(Click to write email)"),
                                br(),
                                h5("Call us"),
                                h6("+65 85225105")
                            )),
                     
                     
                     column(6,
                            wellPanel(
                                h4("Social Media"),
                                style = "background: white",
                                br(),
                                h6("Wechat: oyoyo19930814"),
                                br(),
                                h6("Facebook: ", a(href="https://www.facebook.com/people/Yuxuan-Yuan/100000835964722", "Yuan Yuxuan")),
                                br(),
                                h6("Instagram: ah_hehehe")
                            ))
                 ),
                 
                 
                 fluidRow(
                     column(4,
                            wellPanel(
                                h4("Visit us"),
                                style = "background: white",
                                h5("Jady&Kun Chinese Restaurant"),
                                h6("#01-35, 79D Toa Payoh Central"),
                                h6("Singapore 314079")
                            )),
                     
                     column(4,
                            wellPanel(
                                br(),
                                style = "background: white",
                                h5("How to get there"),
                                h6("Nearest MRT Station: NS19 Toa Payoh"),
                                h6("Bus Services: 56, 105, 153, 232 @ Opp Blk 177")
                            )),
                     
                     column(4,
                            wellPanel(
                                br(),
                                style = "background: white",
                                h5("Opening Hours"),
                                h6("Tuesday - Sunday : 11.00am to 4.00pm, 6.00pm to 11.00pm"),
                                h6("Closed on Monday, and Chinese New Year")
                            ))
                 ),
                 leafletOutput("mymap"))
        
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    points <- eventReactive(input$recalc, {
        cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    output$mymap <- renderLeaflet({
        leaflet() %>% addTiles() %>% setView(103.84895, 1.33487, zoom = 18) %>%
            addProviderTiles(providers$Esri.NatGeoWorldMap,
                             options = providerTileOptions(noWrap = TRUE)
            )%>%
            addMarkers(lng = 103.84895, lat = 1.33487)
    })
    
    observeEvent(input$submit, {
        # Show a modal when the button is pressed
        shinyalert("Reservation Success!", "See you on the day =D .", type = "success")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
