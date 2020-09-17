library(shiny)
library(DT)

#Q4. Shiny app tweak (shiny-24.R)

# In server function, I will create a vector, called color_vec, by sampling from colors() without replacement. 
# The vector length matches length of iris dataset, so every colour is unique. 
# Also, each observation in iris dataset corresponds to specific index in color_vec, so each observation will always be given the same color. 

ui <- fluidPage(
  h3("t1"),
  tableOutput("t1"),
  hr(),
  fluidRow(
    column(9, h3("dt1"),
           dataTableOutput("dt1")),
    column(3,   h3("x4"),
           verbatimTextOutput("x4"))),
  hr(),
  fluidRow(
    column(8, h3("dt2"),
           dataTableOutput("dt2")),
    column(4, h3("p5"),
           plotOutput("p5")))
)
options(error = function() traceback(2))
server <- function(input, output, session) {
  output$t1 <- renderTable(iris[1:10,], striped = TRUE, hover = TRUE)
  output$dt1 <- renderDataTable(iris, options = list( pageLength = 5))
  output$x4 <- renderPrint({
    s = input$dt1_rows_selected
    if (length(s)) {
      cat('These rows were selected:\n\n')
      cat(s, sep = ', ')
    }
  })    
  
  output$dt2 <- renderDataTable(iris,
                                options = list(pageLength = 5),
                                server = FALSE)
  color_vec <- sample(colors(), nrow(iris))
  output$p5 <- renderPlot({
    s <- input$dt2_rows_selected
    plot(iris$Sepal.Length, iris$Sepal.Width)
    if (length(s)) {
      points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
             pch = 19, cex = 1, col = color_vec[s]) 
    }
  })
}

shinyApp(ui, server)

