#
# Welcome to "M Sunshine Vacation" company. This page is coded with R Shiny.
# 
# The three pages are consolidated via "navBar" layout
# 1st tab: "About Us", 2-column layout with wellPanel
# 2nd tab: "Our Solutions", Navlist layout with list tags
# 3rd tab: "Get Started", Sidebar layout
#
# Fu Zhuxuan (G1800418B)
#

library(shiny)

ui <- fluidPage(
  fluidPage(
    navbarPage(
      title = "M Sunshine Vacation",
      # The First Page
      tabPanel("About Us",
               fluidRow(
                 column(5, 
                        tags$img(src = "logo.png", width = "100%")
                 ),
                 column(7,
                        wellPanel(h4("Welcome to M Sunshine Vacation!"), style = "background: lemonchiffon"),
                        wellPanel(h4("Get a personal travel designer to custom-build your dream trip — everything 
                                      you need to take off worry free."), style = "background: lemonchiffon"),
                        wellPanel(h4("Your trip is unique. We find restaurant according to your taste. We find activities according to your interest."), style = "background: lemonchiffon"),
                        wellPanel(h4("Affordable and one flat daily fee: 25SGD per day."), style = "background: lemonchiffon")
                 )
               )
               
      ),
      # The Second Page
      tabPanel("Our Solutions",
               fluidRow(
                 navlistPanel(
                   tabPanel("Relax Trip with in Japan", 
                            h2("Hokkaido Trip in Flower Fields"),
                            p("Middle area of Hokkaido gets popular in summer. 
                              Especially the lavender farm. Farm Tomita is known as the largest lavender field in Japan. 
                              Many people come in the summer from Japan and outside of Japan. 
                              Here, they have many flower field and many kinds of flowers are being grown. 
                              This field of colorful flowers, including purple lavenders is very Instagram worthy. 
                              From the middle to toward the end of July is the best season to see them."),
                            tags$ul(h3("Sample Itinerary"),
                                    tags$li(a("Day 1 - City tour in Sapporo", href = "https://www.japan-guide.com/e/e2163.html", target="_blank")),
                                    tags$li(a("Day 2 - Sapporo to Toya Lake and enjoy the traditional onsen", href = "https://www.japan-guide.com/e/e6725.html", target="_blank")),
                                    tags$li(a("Day 3 - Visit the colorful fields in Biei ", href = "https://www.japan-guide.com/e/e6828.html", target="_blank")),
                                    tags$li(a("Day 4 - Best lavendar field in Furano", href = "https://www.japan-guide.com/e/e6825.html", target="_blank")),
                                    tags$li(a("Day 5 - Back to Sapporo", href = "https://www.japan-guide.com/e/e2163.html", target="_blank"))
                            ),
                            tags$i("*This is only a sample. We will design the details based on your request."),
                            tags$img(src = "japan_summer.jpg", width = "100%")
                            ),
                   tabPanel("Adventurous trip in Trukey", 
                            h2("Walking in Cappadocia"),
                            p("Lying in south central Turkey, the moonscaped region of Cappadocia, southeast of Ankara, is most famous for unique geological features called fairy chimneys. 
                              The large, cone-like formations were created over time by erosion of the relatively soft volcanic ash around them. Past cultures have dug into them to create dwellings, 
                              castles (like Uchisar) and even entire underground cities like Kaymakli and Derinkuyu, used as hiding places by early Christians. Nearby Kayseri is the gateway to the area."),
                            tags$ul(h3("Sample Itinerary"),
                                    tags$li(a("Day 1 - Start from Goreme", href = "https://www.tripadvisor.com.sg/Tourism-g297983-Goreme_Cappadocia-Vacations.html", target="_blank")),
                                    tags$li(a("Day 2 - Trek through White Valley and visit Uchisar Citadel", href = "https://www.goreme.com/uchisar.php", target="_blank")),
                                    tags$li(a("Day 3 - Walk to Zemi Valley and through Gemede Valley", href = "https://www.tripadvisor.com.sg/Attraction_Review-g297983-d2049524-Reviews-Zemi_Valley-Goreme_Cappadocia.html", target="_blank")),
                                    tags$li(a("Day 4 - Explore Pancarilik and Kizilcukur Valley.", href = "http://www.cappadociaturkey.net/kizilcukur-valley-in-cappadocia-turkey.htm", target="_blank")),
                                    tags$li(a("Day 5 - Walk through Monks Valley", href = "https://www.goreme.com/pasabag.php", target="_blank")),
                                    tags$li(a("Day 6 - Visit Kaymakli", href = "https://www.goreme.com/kaymakli-underground-city.php", target="_blank")),
                                    tags$li(a("Day 7 - Walk along Zindanonu Valley", href = "https://www.turkeycentral.com/gallery/image/11356-zindanonu-valley-cappadocia/", target="_blank")),
                                    tags$li(a("Day 8 - Return to Goreme", href = "https://www.tripadvisor.com.sg/Tourism-g297983-Goreme_Cappadocia-Vacations.html", target="_blank"))
                            ),
                            tags$i("*This is only a sample. We will design the details based on your request."),
                            tags$img(src = "turkey_trekking.jpg", width = "100%")
                            )
                   )
                 )
      ),
      #  The Third Page
      tabPanel("Get Started",
               sidebarLayout(
                 sidebarPanel(
                   h4("Planning a trip soon?"),
                   h4("Send us your request to get your own itinerary."),
                   width = 4
                 ),
                 mainPanel(
                   h2("Contact Us"),
                   h4(a("Email to zfu005@e.ntu.edu.sg", href = "mailto:zfu005@e.ntu.edu.sg")),
                   tags$img(src = "logo.png", width = "100%")
                 )
               )
      )
    )
  )
)



server <- function(input, output) {
   
}

# Run the application 
shinyApp(ui = ui, server = server)

