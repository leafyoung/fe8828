library(shiny)
library(DT)
ui <- fluidPage(
  h3("t1"),
  tableOutput("t1"),
  hr(),
  fluidRow(
    column(9, h3("dt1"),
           dataTableOutput("dt1")),
    column(3,h3("x4"),
           verbatimTextOutput("x4"))),
  hr(),
  fluidRow(
    column(8, h3("dt2"),
           dataTableOutput("dt2")),
    
    column(4, 
           # selectInput("color", "Select color", list(
           #   "colors" = c("red", "skyblue","green")
           # )),
           
           selectInput("color", "Select color", choices=colors()),
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
  
  output$p5 <- renderPlot({
    
    s <- input$dt2_rows_selected
    
    plot(iris$Sepal.Length, iris$Sepal.Width)
    isolate({
    if (length(s)) {
      
      points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
             pch = 19, cex = 1, col = input$color)
            #  if(input$color == "red"){
            #    points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
            #  pch = 19, cex = 1, col = "red")}
            #  else if(input$color == "skyblue"){
            #    points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
            #    pch = 19, cex = 1, col = "skyblue")}
            # else if(input$color == "green"){
            #   points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
            #          pch = 19, cex = 1, col = "green") 
            }
        
      })
  })

}
shinyApp(ui, server)
