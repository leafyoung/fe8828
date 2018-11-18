library(shiny)

ui <- fluidPage(
  fluidPage(
    navbarPage(title = "Song Destination Wedding", 
               tabPanel("About Us",
                        titlePanel("About Us"), 
                        navlistPanel(
                          "-----",
                          tabPanel("What We Do",
                                   h1("Where Romance Meets Travel"),
                                   tags$img(src="1.png", height="600px"),
                                   h2("Have you ever dreamt of a romantic wedding in an exotic location?"),
                                   p("We plan weddings that know no bounds." ),
                                   strong("A world of choices."),
                                   p("Explore over 1,200 properties in 42 countries to find the perfect fit for your style and budget."),
                                   strong("Personlaized celebrations."),
                                   p("Every romantic event and getaway we help plan is tailored to each of our couples' visions."),
                                   strong("Dedicated services."),
                                   p("We will coordinate food and beverage, photography, 
                                      flowers, wedding cakes, entertainment and any other little thing you may want."),
                                   h1("Start planning your destination wedding with us!")), 
                          tabPanel("Gallery",
                                   h1("Gallery"),
                                   tags$img(src="2.png", height="400px"),
                                   tags$img(src="3.png", height="400px"),
                                   tags$img(src="4.jpg", height="400px"),
                                   tags$img(src="5.png", height="400px"),
                                   tags$img(src="6.jpg", height="400px"),
                                   tags$img(src="7.jpg", height="400px"),
                                   tags$img(src="8.jpg", height="400px"),
                                   tags$img(src="9.jpg", height="400px"),
                                   tags$img(src="10.jpg", height="400px"),
                                   tags$img(src="11.jpg", height="400px")
                                   ),
                          "-----"
                          )
               ),
               tabPanel("Services",
                        sidebarPanel(
                          h1("Services"),
                          h4("Destination"),
                          tags$ul(
                                  tags$li("Location Inspiration"), 
                                  tags$li("Style Generation"),
                                  tags$li("Venue & Partners")
                          ),
                          h4("Agenda"),
                          tags$ul(
                                  tags$li("Producing a Wedding Summary"),
                                  tags$li("Accomodation & Transportation Coordination"),
                                  tags$li("Wedding Attire Consultation"),
                                  tags$li("Hair, Beauty & Treatment Arrangementy"),
                                  tags$li("Legalities & Official Requirements"),
                                  tags$li("Menu Consultation"),
                                  tags$li("Photography")
                          ),
                          h4("Honeymoon Planning")),
                        mainPanel(
                          img(src = "12.jpg")
                        )
               ),
               tabPanel("Contact Us",
                        titlePanel("Contact Us"), 
                        fluidRow(
                          column(6, h3("We'd love to hear from you"),
                                 wellPanel(
                            p("When planning a destination wedding, honeymoon or vow renewal, you're bound to have plenty of questions. 
                              And we're more than happy to help. Whether you’re curious about destination weddings in general, our company and services, 
                              or the planning process, we’d be delighted to answer any questions you might have along the way.")
                          )), 
                          column(3, h3("Phone"), 
                                 wellPanel(
                                   p("Please call 65-0520-1314 Monday to Friday from 9:00 am to 6:00 pm
                                     to speak with one of our friendly representatives.")
                          )),
                          column(3, h3("Email"),
                                 wellPanel(
                                   p("Please feel free to email us at enquiries@songdw.sg")  
                                 )
                        ))
               )
   
          )
    )
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)

