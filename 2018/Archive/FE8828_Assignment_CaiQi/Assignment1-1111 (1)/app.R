library(shiny)

tour=function() div(
  h3("Guangzhou Foodie Tour"),tags$hr(),
  tags$h5("Is our flagship Guangzhou Foodie Tour about food?"),
  tags$li("Yes. Of course. But we also want to tell the stories behind it. Stories about our childhood, our lives in our city, our customs, our present and our past. We want to explain the Cantonese to you. Oh yeah, and enjoy great food and drinks in the process."),
  tags$br(),
  tags$h5("Sure, we know you came to Guangzhou to see the sights. But we offer a different angle."),
  tags$li("An opportunity to stop in the tracks for a few hours, get off the beaten path, and just be."),
  tags$li("Be among the locals. Get a better understanding of who the people in Guangzhou are. What they believe in. Where are the differences, and what we have in common."),
  tags$li("Of course, we serve what we think is some of the best Cantonese food and drinks. But that's just the start to understand the wider context. To understand how we live."),
  tags$hr(),
  h3("BASICS",align="center",style="font-family:'time'"),
  
  fluidPage(flowLayout(
    h5("Price per guest:",tags$br(),em("CNY 800")),
    h5("Duration:",tags$br(),em("4 hours")),
    h5("Number of stops:",tags$br(),em("10 guests")),
    h5("Price per guest:",tags$br(),em("5 to 7")),
    h5("Walking involved:",tags$br(),em("1.2 miles")),
    h5("Run between:",tags$br(),em("11am-5pm"))
  )),
  submitButton(strong("BOOK NOW !")),
  
  tags$hr(),
  fluidPage(splitLayout(fluidRow(column(4,
    fluidPage(p(h3("FINE PRINT",style="font-family:'time'"),tags$br(),
     fluidRow(tags$li(strong("Group size: "),"Sure, 10 tops, but that's negotiable."),tags$br(),
     tags$li(strong("Start times: "),"anywhere between 11am and 5pm depending on"),p("the day."),
     tags$li("Walking involved may vary as we change the eateries. But we"),p("run food tours, not death marches.") ,
     tags$li("Tours are run rain or shine. In your face, climate change!"),tags$br()),
     tags$img(src="foodtour1.jpeg",width=400)
     )))),
      column(4,p(h3("WHAT IS INCLUDED?",style="font-family:'time'"),tags$br(),
      tags$li("Lots of delicious traditional and modern Cantonese food. Arrive"),p("hungry! You look skinny, and should eat more."),
      tags$li("The company of a well-travelled local Cantonese foodie with a"),p("personality and opinion."),
      tags$li("Personalised email consultancy of your Prague trip before and"),p("after the tour. "),
      tags$li("Our super popular",strong("Prague Foodie Map,"),"with personal tips added"),p("through the tour based on your questions and the discussion."),
      tags$li("Our",em("lifetime coverage."),"Once you take our tour, you will be treated"),p(" to updated tips whenever you decide to visit Guangzhou again."),
      tags$li("Some cool perks along the way."),tags$br(),
      tags$li("Our undivided",em("call-at-4am-to-bail-you-out-of-jail loyalty"), "and"),p("unconditional love.")      
      ))
  )),
  tabsetPanel(
    tabPanel("Zhi You Ji",img(src="6.jpg",width=800)),
    tabPanel("Dim Sum",img(src="0.jpeg",width=800)),
    tabPanel("Pen Cai",img(src="1.jpg",width=800)),
    tabPanel("Mei Cai Kou Rou",img(src="2.jpg",width=800)),
    tabPanel("Bo Luo Gu Luo Rou",img(src="3.jpg",width=800)),
    tabPanel("Xiang Yu Kou Rou",img(src="4.jpg",width=800)),
    tabPanel("Chi Zhi ZHeng Pai Gu",img(src="5.jpg",width=800))
  ))

map=function() div(
  h3("Guangzhou Foodie Map"),
  tags$h4(em("The best restaurants in Guangzhou. In your pocket. Or your phone.")),
  tags$hr(),
  h3("Best Restaurants in Guangzhou. And so much more.",align="center",style="font-family:'time'"),
  p(strong("Price:"),"CNY 20 /",strong("Format: "),"Digital or Print."),
  p(strong("Why should you have it? "),"Because we wrote it and everybody says it's awesome."),
  submitButton(strong("DOWNLOAD IT NOW !")),
  tags$hr(),
  
  p("We all get far less vacation time than we really deserve. Why waste it on mediocre food? You deserve the best. The best restaurants in GZ. The best bars and coffee shops. The best things to do in GZ. And the best shopping.",em("(The girls insisted on the last one.)"),align="center"),
  p("When we don't run our Taste of Guangzhou food tours, we travel, and our bellies and bank accounts know it's only to eat. And we'd love to have a travel guide that by local foodies who know and love their food.",align="center"),
  p("So we've made a Guangzhou travel map like that for our city. What are the best restaurants in GZ? Where do the local foodies eat and drink? What do they order? Where do they sit?",align="center"),
  h4("You have questions. We have the answers!",align="center"),
  tags$hr(),
  fluidPage(sidebarLayout(
   sidebarPanel(tags$img(src="map1.jpg",width=220),tags$img(src="map2.jpg",width=220),tags$img(src="map3.jpg",width=220),tags$img(src="map4.jpg",width=220),width=4),
   mainPanel(h3("WHAT'S INCLUDED IN GZ FOODIE MAP?",align="center"),br(),
             tags$li("Our curated selection of Guangzhou's best restaurants, coffee shops, bars, pubs, bistros and shops."),br(),
             tags$li("Vital info about Guangzhou: Tipping, public transport, etiquette, and super nerdy statistics."),br(),
             tags$li("Basic Guangzhou's glossary. You'll blend in in no time. Not guaranteed."),br(),
             tags$li("Dirty secrets spilled by local experts on food, beer, wine, cocktails and shopping."),br(),
             tags$li("Checklist of Guangzhou???s must-eats. Don't leave without tasting them!"),br(),
             tags$li("Checklist of the most authentic GZ people bites. Hope you've brought your Lipitor pills."),br(),
             tags$li("Tips for cool local spots below the radar. Hang out at the cool table."),br(),
             tags$li("Two one-day itineraries for a weekend in Guangzhou, and suggested things to do in Guangzhou."),br(),
             tags$li("Our guides to Guangzhou???s more residential districts. (You should go there.)"),br(),
             tags$li("And so much more...")
             ) 
  )))

blog=function() div(
  h3("Guangzhou Food Blog"),
  tags$h4(em("Check the latest news about delicious food in Guangzhou.")),
  tags$hr(),
  sidebarLayout(position = "right",
    sidebarPanel(
      h4("WHO ARE WE?"),
      p("We are",strong("Taste of Guangzhou Food Tours."),"Local foodies who love to eat, drink and talk and are happy to share our love with the guests of our wonderful Guangzhou."),
      tags$hr(),
      h4("CATEGORIES:"),
      tags$li("Meet a Guangzhou locol"),
      tags$li("Where to eat"),
      tags$li("Where to Drink"),
      tags$li("Where to Shop"),
      tags$li("Things to do"),
      tags$li("local favorites"),
      tags$li("Trips out of GZ"),
      tags$li("Ten top restaurants"),
      tags$li("Ten top Tea Shops"),
      tags$li("Ten top Bars")
    ),
    mainPanel(
      h3("HEYTEA in Guangzhou"),
      em("Nov 01, 2018____local favorites"),
      hr(),
      p("HEYTEA came into being in a lane named Jiangbianli, formerly known as ROYALTEA. Due to the failure to register the trademark, it is upgraded and registered as HEYTEA."),
      tags$img(src="blog1.png",width=600),
      p("HEYTEA is the first maker of cheese tea. Different from other traditional cream-covered tea with coarse making and cheap tea, HEYTEA provides high-quality tea from all over the world, trying to renew the traditional tea culture."),
      tags$img(src="ht.jpg",width=600),
      tabsetPanel(
        tabPanel(h5("1"),h5("ORIGINAL CHEESE TEA"),
                 p("Combining salt cheese with fresh tea in an ingenious way, HEYTEA original cheese tea is very popular among the customers."),
                 p("The cheese is imported from New Zealand, the creamy taste matching up with the fragrance of selected tea, which creates a wondeful feeling."),
                 flowLayout(img(src="ht3.jpg",width=300),img(src="ht4.jpg",width=300),img(src="ht5.jpg",width=300),img(src="ht6.jpg",width=300),img(src="ht7.jpg",width=300),img(src="ht8.jpg",width=300))
                 ),
      tabPanel(h5("2"),
      h5("FRESH FRUIT TEA"),
      p("Introducing the fresh fruit tea which brings a refreshing taste of the mix between tea and fruits."),
      p("Selected high-quality tea is milden with natural sugar the delicious result is a finish that's both refreshing and rich."),
      img(src="ht1.jpg",width=600),img(src="ht2.jpg",width=600)
      ))
      
    )
  ),
  hr(),
  p("Read More")
)


  
# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$img(src="title.jpeg"),
  fluidPage(titlePanel("TASTE OF GUANGZHOU")
    ),

fluidPage(navbarPage(p(em("The best food in Guangzhou and the stories behind it.   ")),
  tabPanel(strong("FOOD TOUR"),tour()),
  tabPanel(strong("FOODIE MAP"),map()),
  tabPanel(strong("FOOD BLOG"),blog())
  ))
)



# Define server logic required to draw a histogram
server <- function(input, output) {
   
}
# Run the application 
shinyApp(ui = ui, server = server)

