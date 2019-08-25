#assignment 2
#Fang You G1800202G
#run shiny 24.R pg 62 of 102

library(shiny)
library(DT)

ui <- fluidPage(
  
  selectInput("choice","Color:",c("Choose color"="SkyBlue1",colors())),
  
  h3("Assignment 2 plot"),
  plotOutput("col_plot"),
  
  h3("t1"),
  tableOutput("t1"),
  hr(),
  
  fluidRow(
    column(9, h3("dt1"),
           dataTableOutput("dt1")
    ),
    column(3, h3("x4"),
           verbatimTextOutput("x4")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(8, h3("dt2"),
           dataTableOutput("dt2")
    ),
    column(4, h3("pg5"),
            plotOutput("pg5")
    )
  )
  
)

options(error = function() traceback(2))

server <- function(input, output, session) {
  output$t1 <- renderTable(iris[1:10,],striped = TRUE,hover = TRUE)
  output$dt1 <- renderDataTable(iris,options = list(pagelength = 5))
  output$x4 <- renderPrint({
    s = input$dt1_rows_selected
    if (length(s)) {
      cat('These rows were selected: \n\n')
      cat(s, sep = ',')
    }
  })

  output$dt2 <- renderDataTable(iris,
                                options = list(pageLength = 5),
                                server = FALSE)
  output$p5 <- renderPlot({
    s <- input$dt2_rows_selected
    plot(iris$Sepal.Length,iris$Sepal.Width)
    if(length(s)) {
      points(iris[s, c("Sepal.Length","Sepal.Width"), drop = F],
             pch = 19, cex = 1, col = "red")
    }
  })
  
  output$col_plot <- renderPlot({
    plot(1:10, pch = 19, cex = 1, col = input$choice)
  })  
}

# Run the application 
shinyApp(ui = ui, server = server)

