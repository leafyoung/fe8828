#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(
  h3("t1"),
  tableOutput("t1"),
  hr(),
  fluidRow(
    column(9, h3("dt1"),
           dataTableOutput("dt1")),
    column(3, h3("x4"),
           verbatimTextOutput("x4"))),
  hr(),
  fluidRow(
    column(8, h3("dt2"),
           dataTableOutput("dt2")),
    column(4, h3("p5"),
           selectInput("color", "Select the color you want to fill the dots", colors()),
           plotOutput("p5")))
)

options(error = function() traceback(2))

# Define server logic 
server <- function(input, output, session) {
   
   output$t1 <- renderTable(iris[1:10,], striped = TRUE, hover =TRUE)
   output$dt1 <- renderDataTable(iris, options = list(pageLength = 5))
   output$x4 <- renderPrint({
     s = input$dt1_rows_selected
     if(length(s)){
       cat('These rows were selected: \n\n')
       cat(s,sep = ', ')
     }
   })
   output$dt2 <- renderDataTable(iris,
                                 options = list(pageLength = 5),
                                 quoted  = FALSE)
   output$p5 <- renderPlot({
     s <- input$dt2_rows_selected
     plot(iris$Sepal.Length,iris$Sepal.Width)
     if(length(s)){
       points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
              pch =19, cex=1, col = input$color)
     }
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

