library(shiny)
library(ggplot2)
library(DT)

ui <- fluidPage(
      navbarPage("The Mesoya Group",
                 tabPanel("What we do",titlePanel("We produce research to help you with country allocation decisions"),
                plotOutput("mygraph")),
                tabPanel("Our analysis of various capital markets",DT::dataTableOutput("mytable")),
                tabPanel("Contact us", "Feel free to reach out to us at", tags$a(href="mailto:teoyaoyang@gmail.com", "teoyaoyang@gmail.com")),
                 inverse=TRUE
                )
                )


server <- function(input, output) {
  data<-read.csv("data.csv")
  output$mytable <- renderDataTable(data)
  output$mygraph <- renderPlot(ggplot(data, aes(x = Value.Rank, y=Momentum.Rank, size=Aggregate.Score)) + geom_point() +labs(title="Value(x), Momentum(y), and Aggregate score(size) of major markets", x = "Value - Lower is better", y = "Momentum - Lower is better") + geom_text(aes(label = Country), nudge_x = 1,nudge_y = 1, check_overlap = TRUE))
 
}

shinyApp(ui = ui, server = server)


