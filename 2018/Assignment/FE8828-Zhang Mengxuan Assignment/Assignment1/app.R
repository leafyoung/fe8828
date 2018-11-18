library(shiny)
library(shinythemes)
ui <- fluidPage(theme = shinytheme("flatly"),
  fluidPage(
    navbarPage(title = "Shiny Travel",
               tabPanel("Product",
                        titlePanel("Hello! Welcome to Shiny Travel!"),
                        
                       selectInput("country", "Select country", list(
                         "Asia Pacific" = c("Singapore", "China","Thailand")
                       ),uiOutput("img1")
                       ),
                       actionButton("goButton", "Go!"),
                       p(""),
                       mainPanel(
                         uiOutput("img1") ,width=28, align="center")
                       
                       ),
                        
               tabPanel("About us",
                        titlePanel("Who Are We?"),
                        
                        p("Shiny Travel aims to connect young people all over the world by providing an opportunity to widen their knowledge, immersing themselves in another culture."),
                        p("Our mission is to impact the lives of students and youth through travel experiences that change their lives. By engaging local families and students with a similar background, we promote a safe and professional work and travel style."), 
                        verbatimTextOutput("text"),
                        fluidRow(
                           column(12,
                                  img(src = "Youth-Blog.jpg", width = "100%", height="500")
                           )
                         )),
             navbarMenu(title = "Contact Us",
                          tabPanel("Address", 
                                   sidebarLayout(
                                     
                                     navlistPanel(
                                       tabPanel("Address", h2("Shiny Travel Building 04-110, 442 Orchard Rd, Singapore",align="center")),
                                       tabPanel("Phone",h2("+65 6731 3131",align="center")),widths=c(3,8)),
                                     mainPanel(
                                       img(src = "join.jpg",align="center",width=700,height=400)
                                   ))),
                          tabPanel("Phone", 
                                   sidebarLayout(
                                     navlistPanel(
                                       tabPanel("Address", h2("Shiny Travel Building 04-110, 442 Orchard Rd, Singapore",align="center")),
                                       tabPanel("Phone",h2("+65 6731 3131",align="center")),widths=c(3,8)),
                                     mainPanel(
                                       img(src = "join.jpg",align="center",width=700,height=400)
                                     )))
                          )
               )

  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$img1 <- renderUI({
    
    input$goButton
    isolate({
    if (is.null(input$country))
      return()
    if(input$country == "Singapore"){            
      img(height = 500, width = 800, src = "Singapore.png")
    }                                        
    else if(input$country== "China"){
      img(height = 500, width = 800, src = "China.jpg")
    }
    else if(input$country == "Thailand"){
      img(height = 500, width = 800, src = "Thailand.jpg")
    }
    })
  })
  
}
# Run the application
shinyApp(ui = ui, server = server)