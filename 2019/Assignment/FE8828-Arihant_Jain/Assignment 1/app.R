library(shiny)
# install.packages("shinythemes")
library(shinythemes)


companyName<-"Roam With ReOm"
selectedTheme<-shinytheme("cerulean")
headerPanel<-titlePanel(tags$a(h1(companyName), style = "font-size:50px;text-align:center;",href="javascript:history.go(0)"))

#page1
page1pic<-HTML('<center><img src="pic_1.jpg" width="500"></center>')
page1section<-"About Roam with ReOm"
para_1 <- "We are Reema and Om and we are travelholics! We are working professionals and we understand the significance of trips in our lives. We welcome you to explore the world with us."
para_2 <- "We have travelled to 3 continents and 7 countries. Being explorer, we believe in enjoying the locations than making a remarkable country count. One target is to explore all the continents before our last breath."
para_3 <- "Roam with ReOm is here to share the travel experience and ideas for your next vacations or weekend getaways."
para_4 <- "Let's explore the world with us!"
page1content<-wellPanel(para_1,HTML('<br></br>'),para_2,HTML('<br></br>'),para_3,HTML('<br></br><b>'),para_4,HTML('</b'))
page1<-mainPanel(page1pic,h1(page1section),h3(page1content), width=12)
navPage1<-tabPanel("Home", page1)

#page2
page2pic<-HTML('<center><img src="pic_4.jpg" width="800"></center>')
para_1 <- "Roam with ReOm is all about living life to the fullest and not just travel to check off the bucket list."
para_2 <- "We are a power couple travelling to distinct destinations and living our dreams together. We have been exploring places for over 2 years now! It has been a wonderful journey together after our marriage."
para_2_2 <- "We have already explored 7 countries in these 2 years and many more are waiting ahead. Since we both are working in Singapore, it becomes a little difficult to take out time from the work life to visit our dream destinations."
para_2_3 <- "So, here we are trying to help people by providing plans on how to travel while working."
para_2_4 <- "It really needs a passion to travel if you are a working professional. Here is a bit more about us:"
para_2_Reema <- "I am an Engineer and MBA (marketing) I am living my life to fullest as I am doing what I love to do. I am a digital marketer who loves the online world. It's my passion to travel across the world and make people aware about unexplored beauty of nature. Expect all kind of childish behaviour and a love for photography from me."
para_2_Om <- "I am a typical finance geek who loves his work a lot. Since the day I got engaged to Reema, explored a travel freak in me. I just love booking tickets and never think twice even when it's a plan to go abroad. I know it's weird but that's how I am. I love to investigate nature's grace and can spend a day with this."
page_2_conclusion <- fluidRow(column(6,HTML('<center>'),h1("REema (Kratika)"),HTML('</center>'),HTML('<center><img src="pic_5.jpg" width="300"></center>'),h3(para_2_Reema)),column(6,HTML('<center>'),h1("OM (Arihant)"),HTML('</center>'),HTML('<center><img src="pic_6.jpg" width="300"></center>'),h3(para_2_Om)))
page2content<-wellPanel(para_1,HTML('<br></br>'),para_2,para_2_2,HTML('<b>'),para_2_3,HTML('</b>'),para_2_4)
page2<-mainPanel(page2pic,h3(page2content),page_2_conclusion, width=12)
navPage2<-tabPanel("Who are we?", page2)

#page3
page3<-fluidPage(
    fluidRow(
        column(4,
               HTML('<center><img src="pic_7.jpg" width="300"></center>'),
               HTML('<center>'),h2("Hawaii"),HTML('</center>')
        ),
        column(4,
               HTML('<center><img src="pic_8.jpg" width="300"></center>'),
               HTML('<center>'),h2("Finland"),HTML('</center>')
        ),
        column(4,
               HTML('<center><img src="pic_10.jpg" width="300"></center>'),
               HTML('<center>'),h2("Hong Kong"),HTML('</center>')
        )
    ),
    HTML('<br></br>'),
    fluidRow(
        column(4,
               HTML('<center><img src="pic_9.jpg" width="300"></center>'),
               HTML('<center>'),h2("Indonesia"),HTML('</center>')
        ),
        column(4,
               HTML('<center><img src="pic_12.jpg" width="300"></center>'),
               HTML('<center>'),h2("Singapore"),HTML('</center>')
        ),
        column(4,
               HTML('<center><img src="pic_11.jpg" width="300"></center>'),
               HTML('<center>'),h2("Thailand"),HTML('</center>')
        )
    ),
    HTML('<br></br>'),
    fluidRow(
        column(4,""
        ),
        column(4,
               HTML('<center><img src="pic_13.jpg" width="300"></center>'),
               HTML('<center>'),h2("India"),HTML('</center>')
        ),
        column(4,""
        )
    )
)

page3_final<-mainPanel(page3,width=12)
navPage3<-tabPanel("Gallery", page3_final)

#page4
page_4_para_1 <- "Whether you'd like to ask us a question about your upcoming travels or get in touch with us regarding a work collaboration, we're always happy to hear from you. If you catch us at a time when we are prancing around in some remote corner of the world, it might take us a bit longer to get back to you, but you'll surely hear from us. Just pick your favourite medium of getting in touch with us :)"
page4_contact<-fluidPage(
    fluidRow(
        column(6,
               tags$a(HTML('<center><img src="message.png" width="100"></center>'),href="mailto:aihant001@e.ntu.edu.sg"),
               HTML('<center>'),h2("Email"),HTML('</center>'),
               p("The best way to reach us via email. We promise to get back to you ASAP!")
        ),
        column(6,
               tags$a(HTML('<center><img src="instagram.jpg" width="100"></center>'),href="https://www.instagram.com/j_kratika/"),
               HTML('<center>'),h2("Instagram"),HTML('</center>'),
               p("Why not check out Instagram gallery and drop us a message there?")
        )
    )
)
page4<-mainPanel(h1("Thanks for dropping by"),h3(page_4_para_1),page4_contact, width=12)
navPage4<-tabPanel(title = "Contact Us", page4 )

navBar<-navbarPage("",navPage1,navPage2,navPage3,navPage4)
ui <- fluidPage(fluidPage(theme=selectedTheme,headerPanel,navBar))

server <- function(input, output,session){}

shinyApp(ui = ui, server = server)
