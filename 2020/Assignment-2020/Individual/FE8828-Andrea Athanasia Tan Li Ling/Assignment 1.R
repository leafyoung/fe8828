library(shiny)
# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidPage(
        titlePanel(strong("h e l l o - c u p p a")),
                   
        tabsetPanel(
            tabPanel("welcome", h1("about us",style="font-family: 'Georgia'; text-align: center; font-size: 20pt; font-style:italic;"),
                     img(src="https://images.unsplash.com/photo-1526823127573-0fda76b6c24f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80", width = "833px", style="display: block; margin-left: auto; margin-right: auto;"),
                     hr(),
                     fluidRow(
                         column(4,strong("Our Story"),
                                wellPanel(p("Back in 1998, we decided that there simply wasn't enough good, high quality chocolate around.  We believe that great chocolates can only be made from fine cacao that has been treated with care and skill. Thus, our products are all handmade daily from scratch and by hand to ensure that only premium quality chocolate goods are shared with our customers."))),
                         column(4,strong("Our Mission"),
                                wellPanel(p("We are in pursuit of making delicious chocolate that have greater depth, flavour clarity and intensity.  Our approach is to select only high quality, purposefully grown and prepared ingredients at their peak, then process them using a variety of traditional and modern techniques and equipment to express their flavour in chocolate."))),
                         column(4,strong("Locate Us"),
                                wellPanel(p("Square 2"),
                                          p("10 Sinaran Drive #01-14"),
                                          p("Singapore 307506"),
                                          p("T: (+65) 6255 5555"),
                                          p("Mon - Sun: 10am - 8pm"),
                                          br(),
                                          p("Come on down, we'd love to meet you!"))))
                ),
            tabPanel("menu", h1("products",style="font-family: 'Georgia'; text-align: center; font-size: 20pt; font-style:italic;"),
            navlistPanel(
                "F O O D",
                tabPanel("Cake menu",
                        h3("C a k e"),
                        h5(em("Heritage chocolate")),
                        img(src = "https://images.unsplash.com/photo-1586985289906-406988974504?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80", height="300px", width="400px"),
                        h5(em("Gooey caramel")),
                        img(src = "https://images.unsplash.com/photo-1542826438-bd32f43d626f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1712&q=80", height="300px", width="400px"),
                        h5(em("Cherry bang")),
                        img(src = "https://images.unsplash.com/photo-1593630818497-46185b710b20?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1476&q=80", height="300px", width="400px")),

                tabPanel("Chocolate menu",
                        h3("C h o c o l a t e"),
                        h5(em("Basic")),
                        img(src = "https://images.unsplash.com/photo-1511381939415-e44015466834?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1676&q=80", height="300px", width="400px"),
                        h5(em("Nutty")),
                        img(src = "https://images.unsplash.com/photo-1542843137-8791a6904d14?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80", height="300px", width="400px"),
                        h5(em("Raspberry")),
                        img(src = "https://images.unsplash.com/photo-1565071559227-20ab25b7685e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80", height="300px", width="400px")),
                "*******************************",
                "D R I N K S",
                tabPanel("Beverage menu",
                        h3("B e v e r a g e s"),
                        tags$ul("",
                                tags$li(em("Hot chocolate")),
                                tags$li(em("Cappucino")),
                                tags$li(em("Latte")),
                                tags$li(em("Americano")),
                                tags$li(em("Tea"))))),
                ),
            tabPanel("help", h1("contact us",style="font-family: 'Georgia'; text-align: center; font-size: 20pt; font-style:italic;"),
                     sidebarLayout(position="right",
                         sidebarPanel(width="7",
                             navbarPage("",
                                        tabPanel("Telephone",
                                                 p("T: (+65) 6255 5555")),
                                        tabPanel("Email",
                                                 p("hello-cuppa@gmail.com")),
                                        tabPanel("Social media",
                                                 p("Facebook: hello-cuppa"),
                                                 p("Instagram: hello-cuppa")),
                                        tabPanel("Feedback",
                                                 dateInput("date","When did you visit us?"),
                                                 selectInput("activity","What did you do at our store?",c("Had cake","Had drinks","Purchased chocolate","Just browsed")),
                                                 sliderInput("rate1","Did you like our products? 1 = Not at all; 10 = Very much",min=1,max=10,value=1,step=1),
                                                 sliderInput("rate2","How was the service? 1 = Very bad; 10 = Very good",min=1,max=10,value=1,step=1),
                                                 checkboxGroupInput("y/n","Would you recommend us to friends and family?",c("Yes","No")),
                                                 p("Thank you for your feedback. We hope to see you again! :-)"))
                             )
                         ),
                         mainPanel(width="5",
                             img(src= "https://images.unsplash.com/photo-1576741047587-d72d82caaef8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80",height="500px")
                         )
                     ),
            )
        )
    )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
}
# Run the application
shinyApp(ui = ui, server = server)