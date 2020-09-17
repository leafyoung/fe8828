#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# Author: Bai Haoyu
# Matric Number: G1900411H
# Date: 22 Sept 2019

# Company Background: 
# This is a virtual boxing match organizer called "Everyone Likes Boxing!"

# The Website:
# The website is designed using the "navBar" layout
# First tab: "Our Business" using "Sidebar" Layout
# Second tab: "Ranking" using "Column-based" Layout
# Third tab: "Become a Fighter" using "Navlist panel" Layout

# used a cool theme to make this website looks cool

library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("cyborg"),
  fluidPage(
    navbarPage(
      # first tab
      title = "Everyone Likes Boxing!",
      tabPanel("OUR BUSINESS",
               titlePanel(h1("We Organize Boxing Matches", style="color:red;font-family:Rockwell")),
               titlePanel(h2("...that you will surely enjoy!", style="color:red;font-family:Rockwell")),
               hr(),
               sidebarLayout(
                 sidebarPanel(
                   h3("Up Next",style="font-family:Rockwell"),
                   wellPanel(
                     h5("“Hollywood” Mike vs “Ice Cold” Igor",style="color: yellow;font-family:'Lucida Calligraphy'",align="center"),
                     h5("“Jacaré” Souza vs “Joker” Steve",style="color:yellow;font-family:'Lucida Calligraphy'",align="center"),
                     h5("“Ninja” Murilo vs “Savage” Chad",style="color:yellow;font-family:'Lucida Calligraphy'",align="center")
                   ),
                   h3("Just Happened",style="font-family:Rockwell"),
                   wellPanel(
                     h5("“Ace” Rich vs “Big Dog” Ricardo",style="color:yellow;font-family:'Lucida Calligraphy'",align="center"),
                     h5("“C-4” Jamie vs “Cyborg” Cristiane",style="color:yellow;font-family:'Lucida Calligraphy'",align="center"),
                     h5("‘“Drago” Pete vs “Ely” Paulo",style="color:yellow;font-family:'Lucida Calligraphy'",align="center")
                   ),
                   width = 4
                 ),
                 mainPanel(
                   h2("Boxing Is A Gentleman's Sport.", style="font-family:Rockwell"),
                   h2("It is both", tags$em("Classy and Entertaining"),style="font-family:Rockwell"),
                   tags$img (src = "boxing_photo.jpg", align = "center", width = 500, height = 200),
                   h3("Call" , tags$em("(+65) 9888 9888", style="color:red"), " to buy tickets!",style="Rockwell"),
                   a("Or, you can click here to buy online", href = "https://www.ufc.com")
                 )
               )
      ),
      
      # second tab
      tabPanel("RANKINGS",
               titlePanel(h2("ATHLETE RANKINGS", style="color:red;font-family:Rockwell", align="center")),
               fluidRow(
                 column(3, 
                        wellPanel(h6("FEATHERWEIGHT", style="font-family:Rockwell;color:red"),style = "padding: 1px", align="left"),
                        wellPanel(h6("Champion “Filthy” Tom Lawlor", style="font-family:Rockwell"),style = "padding: 1px",tags$img (src = "FEATHERWEIGHT.jpg", align = "center", width = 300, height = 100)),
                        wellPanel(h6("2 “Magrino” Cole Miller", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("3 “The Answer” Frankie Edgar", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("4 “Viking” Dan Evensen", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("5 “Uno Shoten” Caol Uno", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("6 “The Robot” Steve Cantwell", style="font-family:Rockwell"),style = "padding: 1px")
                 ),
                 column(3, 
                        wellPanel(h6("LIGHTWEIGHT", style="font-family:Rockwell;color:red"),style = "padding: 1px", align="left"),
                        wellPanel(h6("Champion “Batman” Kurt Pellegrino", style="font-family:Rockwell"),style = "padding: 1px",tags$img (src = "LIGHTWEIGHT.jpg", align = "center", width = 300, height = 100)),
                        wellPanel(h6("2 “Crazy” Tim Credeur", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("3 “Da Grim” Brett Rogers", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("4 “El Conquistador” Jorge Rivera", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("5 “H2Oman” Ron Waterman", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("6 “K-Taro”Keita Nakamura", style="font-family:Rockwell"),style = "padding: 1px")
                 ),
                 column(3, 
                        wellPanel(h6("MIDDLEWEIGHT", style="font-family:Rockwell;color:red"),style = "padding: 1px", align="left"),
                        wellPanel(h6("Champion “Jucao” Roan Carneiro", style="font-family:Rockwell"),style = "padding: 1px",tags$img (src = "MIDDLEWEIGHT.jpg", align = "center", width = 300, height = 100)),
                        wellPanel(h6("2 “Kadillac” Lloyd Marshbanks", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("3 “Lil’ Evil” Jens Pulver", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("4 “Ruthless” Robbie Lawler", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("5 “The Dominator” Dominick Cruz", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("6 “War Machine” Jon Koppenhaver", style="font-family:Rockwell"),style = "padding: 1px")
                 ),
                 column(3, 
                        wellPanel(h6("HEAVYWEIGHT", style="font-family:Rockwell;color:red"),style = "padding: 1px", align="left"),
                        wellPanel(h6("Champion “G1900411H” Bai Haoyu", style="font-family:Rockwell"),style = "padding: 1px",tags$img (src = "HEAVYWEIGHT.jpeg", align = "center", width = 300, height = 100)),
                        wellPanel(h6("2 “Lights Out” Chris Lytle", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("3 “Maverick” Zack Mick", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("4 “Meathead” Matt Mitrione", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("5 “Showtime” Anthony Pettis", style="font-family:Rockwell"),style = "padding: 1px"),
                        wellPanel(h6("6 “The A-Train” Aaron Simpson", style="font-family:Rockwell"),style = "padding: 1px")
                 )
               )),
      
      # below is 3rd tab
      tabPanel("BECOME A FIGHTER",
               titlePanel(h1("You Think You Got What It Takes?", style="color:red;font-family:Rockwell")),
               titlePanel(h3("Come And TALK THE FIGHT", style="color:red;font-family:Rockwell")),
               hr(),
               navlistPanel(
                 "TRAINING",
                 tabPanel("Training Facility",
                          h4("Gym and Boxing Ring", style="font-family:Rockwell;color:white"),
                          tags$img (src = "gym.jpg", align = "center", width = 800, height = 350)
                 ),
                 tabPanel("Coaching Team",
                          h4("Top-Class Coaches", style="font-family:Rockwell;color:white"),
                          tags$img (src = "coaches.jpg", align = "center", width = 800, height = 350)
                 ),
                 tabPanel("Nutritionist",
                          h4("Diets", style="font-family:Rockwell;color:white"),
                          tags$img (src = "food.png", align = "center", width = 800, height = 350)
                 ),
                 "MANAGEMENT TEAM",
                 tabPanel("Chief Executive Officer",
                          h3("Mr.Bai Haoyu", style="font-family:Rockwell;color:white"),
                          h4("MSc Financial Engineering Participant 2019-2020", style="font-family:Rockwell;color:white"),
                          h4("College of Business(Nanyang Business School)", style="font-family:Rockwell;color:white")
                 ),
                 tabPanel("Chief Marketing Officer",
                          h3("Mr.Bai Haoyu", style="font-family:Rockwell;color:white"),
                          h4("MSc Financial Engineering Participant 2019-2020", style="font-family:Rockwell;color:white"),
                          h4("College of Business(Nanyang Business School)", style="font-family:Rockwell;color:white")
                 ),
                 "SIGN UP",
                 tabPanel("Fill In Your Details",
                          h3("Please fill in your details below: ",style="color:whilte;font-family:'Rockwell'"),
                          textInput("newQuestion","Name", "e.g. Bai Haoyu"),
                          textInput("newQuestion","Phone", "e.g. +65 9888 9888"),
                          textInput("newQuestion","Email", "e.g. baihaoyu@everyonelikesboxing.com"),
                          actionButton("do","Submit"),
                          hr(),
                          a("Unable to Submit? Click here to submit", href = "https://forms.gle/ZWDrDTuRuVp2RXAE9"),
                          h6("Still Cannot? Contact our admin at admin@everyonelikesboxing.com",style="color:white;font-family:'Lucida Calligraphy'")
                 )
               )
      )
    )
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output){
  
}

# Run the application
shinyApp(ui = ui, server = server)