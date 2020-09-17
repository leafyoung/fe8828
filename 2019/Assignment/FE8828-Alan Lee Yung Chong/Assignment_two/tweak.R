library(shiny)
library(DT)
library(dplyr)
#UI code
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
           plotOutput("p5")))
)
options(error = function() traceback(2))

# server side code
server <- function(input, output, session) {
  output$t1 <- renderTable(iris[1:10,], striped = TRUE, hover = TRUE)
  output$dt1 <- renderDataTable(iris)
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
 
  #-------------------------------------Assignment function------------------------------
  color <- function(s){
    #slice the dataset.
    selected<- iris[s, "Species"]
    color_c <- c()
    pos <- 1
    # get the species
    for (species in selected){
      if (species == "setosa"){
        color_c[pos] <- "red"
      } else if (species == "versicolor"){
        color_c[pos] <- "green"
      } else if (species == "virginica"){
        color_c[pos] <- "blue"
      }
    # print(c(select(selected, selected.Species)))
      pos <- pos+1
    }
    print(color_c)
    
    return(color_c)
  }
  #---------------------------------------------------------------------------------------
  
  output$p5 <- renderPlot({
    s <- input$dt2_rows_selected

    plot(iris$Sepal.Length, iris$Sepal.Width)
    if (length(s)) {
      points(iris[s, c("Sepal.Length", "Sepal.Width"), drop = F],
             pch = 19, cex = 1, col = color(s))
    }
  })
}

shinyApp(ui, server)