library(shiny)
library(shinydashboard)
library(leaflet)

##### Strings #####
home_subtitle <- "Churning Concise & Convenient News"
home_prob <- "Why was NewsBlender created?"
home_probdesc <- "In this information age, we are constantly bombarded by 
news from all angles - social media, newspapers, emails, mobile news apps. Yet, 
we are truly interested in just a small fraction of these information only. We find
ourselves going through pages after pages, headlines after headlines, switching from
one app to another to get our daily dose of information. And if we are short of time,
we might never finish reading the news that we shortlisted. These inefficiencies 
spawned the idea of NewsBlender."
home_sol <- "What can NewsBlender do for you?"
home_soldesc <- "NewsBlender is the one-stop platform for your information needs. 
NewsBlender funnels, filters and summarizes news from multiple sources, based on 
your own preferences. NewsBlender churns out relevant headlines for you to scroll through, 
as well as summarised news for you to read through efficiently."
about_team <- "Who are we?"
about_teamdesc <- "Actually, the question should be 'Who am I?'. Well, this is a one-man 
mission, and my name is Matthew Chan. I recently graduated from NUS Business School in May 
2019, and I am currently a candidate at NTU's MSc Financial Engineering Program. NewsBlender 
is an idea that I had in mind back when I was an undergraduate as I personally would have 
loved to have such an app."
product_feat1 <- "News Funnelling"
product_feat1desc <- "NewBlender retrieves news data from multiple sources, based on your
own preferences. Data sources include social media, news websites, mobile news apps, etc. 
Instead of having information segregated by different platforms, NewsBlender consolidates 
and brings them together for your convenience."
product_feat2 <- "Natural Language Processing"
product_feat2desc <- "Using Natural Language Processing (NLP), NewsBlender summarizes news 
and presents you with information that are concise and most pertinent. Furthermore, it 
classifies the news according to their topics and genres."
product_feat3 <- "Personalized Application"
product_feat3desc <- "NewsBlender matches your personal needs with its flexible and 
customizable features. You can choose the data sources from which NewsBlender retrieves 
information. Also, you can filter news based on what you are interested to read. Lastly, 
you can choose the conciseness of the summarized news."
product_feat4 <- "One-Stop Platform"
product_feat4desc <- "All in all, NewsBlender is the one-stop platform for your 
daily dose of news. NewBlender churns out concise and convenient information for you, 
eliminating the daily inefficiencies that we are forced to get used to - switching from 
app to app, reading through irrelevant information to get to the information we truly 
desire."
contact_addressname <- "Nanyang Technological University"
contact_address <- "50 Nanyang Ave, Singapore 639798"
contact_fakenum <- "+65 6123 9494"
contact_fakeemail <- "newsblender@gmail.com"

##### RShiny #####
ui <- dashboardPage(
   dashboardHeader(title = "NewsBlender"), 
   dashboardSidebar(
     sidebarMenu(
       menuItem("Home", tabName = "Home", icon = icon("home")),
       menuItem("About", tabName = "About", icon = icon("info")),
       menuItem("Product", tabName = "Product", icon = icon("mobile-alt")),
       menuItem("Contact", tabName = "Contact", icon = icon("address-card"))
     )
     
   ),
   dashboardBody(
     tabItems(
      tabItem(tabName = "Home",
              tags$img(
                src = "wallpaper_wood5.jpg",
                style = "position: absolute; opacity: 0.3; object-fit: contain; width: 100%; height:95%;"
              ),
              tags$br(),
              tags$br(),
              fluidRow(
                column(width = 12, align = "center", 
                       img(src = 'NewsBlender.png'),
                       tags$i(h5(home_subtitle))
                       )
                ),
              tags$br(),
              tags$br(),
              fluidRow(
                column(width = 8, offset = 2, align = "justify",
                       tags$i(h3(home_prob, align = "center")),
                       p(home_probdesc),
                       tags$br(),
                       tags$i(h3(home_sol, align = "center")),
                       p(home_soldesc)
                       )
                )
              ),
      tabItem(tabName = "About",
              tags$img(
                src = "wallpaper_wood3.jpg",
                style = "position: absolute; opacity: 0.2; object-fit: contain; width: 100%; height:95%;"
              ),
              tags$br(),
              tags$br(),
              fluidRow(
                column(width = 12, align = "center", 
                       img(src = 'NewsBlender.png')
                )
              ),
              tags$br(),
              tags$br(),
              fluidRow(
                column(width = 8, offset = 2, align = "justify",
                       tags$i(h3(about_team, align = "center")),
                       p(about_teamdesc)
                       )
                )
              ),
      tabItem(tabName = "Product",
              tags$img(
                src = "wallpaper_wood5.jpg",
                style = "position: absolute; opacity: 0.3; object-fit: contain; width: 100%; height:95%;"
              ),
              tags$br(),
              tags$br(),
              fluidRow(
                column(width = 12, align = "center",
                       img(src = 'NewsBlender.png'))
              ),
              tags$br(),
              tags$br(),
              fluidRow(
                column(width = 5, offset = 1, align = "justify",
                       tags$i(h3(product_feat1, align = "center")),
                       p(product_feat1desc)
                       ),
                column(width = 5, align = "justify",
                       tags$i(h3(product_feat2, align = "center")),
                       p(product_feat2desc)
                       )
              ),
              fluidRow(
                column(width = 5, offset = 1, align = "justify",
                       tags$i(h3(product_feat3, align = "center")),
                       p(product_feat3desc)
                       ),
                column(width = 5, align = "justify",
                       tags$i(h3(product_feat4, align = "center")),
                       p(product_feat4desc)
                       )
              )
              ),
      tabItem(tabName = "Contact",
              tags$img(
                src = "wallpaper_wood6.jpg",
                style = "position: absolute; opacity: 0.2; object-fit: contain; width: 100%; height:95%;"
              ),
              fluidRow(
                column(width = 4, offset = 1, align = "center",
                       tags$br(), tags$br(),
                       img(src = 'NewsBlender.png'),
                       tags$br(), tags$br(), tags$br(),
                       h5(contact_addressname),
                       h5(contact_address),
                       tags$br(), tags$br(),
                       h5(icon("envelope"), contact_fakeemail),
                       h5(icon("phone"), contact_fakenum)
                       ),
                column(width = 6, align = "center",
                       tags$br(),
                       leafletOutput("MyMap"))
              ))
     )
   )
)

server <- function(input, output) {
  output$MyMap <- renderLeaflet({
    leaflet() %>%
      setView(lng = 103.6831, lat = 1.3483, zoom = 12) %>%
      addTiles() %>% 
      addPopups(lng = 103.6831, lat = 1.3483,
                contact_addressname)
  })
}

shinyApp(ui = ui, server = server)


# Static website: A front page, an about page, some description pages
# add CSS and bg images, images
