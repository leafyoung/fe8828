library(shiny) 
library(DT)

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
    selectInput("color1", "Species1", colors()),
    selectInput("color2", "Species2", colors()),
    selectInput("color3", "Species3", colors()),
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
  output$p5 <- renderPlot(
    {
      s <- input$dt2_rows_selected    
      plot(iris$Sepal.Length, iris$Sepal.Width)    
      if (length(s)) 
      {      
        grn<-vector()
        bl<-vector()
        rd<-vector()
        for(i in s)
        {
          if(i<=50)
          {
            grn<-c(grn, i)
          }
          else if(i>50&i<101)
          {
            bl<-c(bl,i)
          }
          else if(i>=101)
          {
            rd<-c(rd,i)
          }
        }
          
        points(iris[grn, c("Sepal.Length", "Sepal.Width"), drop = F],             
               pch = 19, cex = 1, col = input$color1)
        points(iris[bl, c("Sepal.Length", "Sepal.Width"), drop = F],             
               pch = 19, cex = 1, col = input$color2)
        points(iris[rd, c("Sepal.Length", "Sepal.Width"), drop = F],             
               pch = 19, cex = 1, col = input$color3)
        
      }
    
    }  
  ) 
}
shinyApp(ui, server)
