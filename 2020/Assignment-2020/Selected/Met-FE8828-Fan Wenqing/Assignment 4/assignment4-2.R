library(shiny)
library(tidyverse)

ui <- fluidPage(
    numericInput("r1", "Infection Rate", 0.05),
    numericInput("r2", "Specificity and Sensitivity", 0.95),
    plotOutput("p1"),
    h4("The percentage of an individual who tests negative is actually negative is:"),
    textOutput("t1")
)

server <- function(input, output) {

    output$p1 <- renderPlot({
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'), 
            tibble(y = 1:20, color = 'Actual Neg'), by = 'color')
        
        n1 <- round(500*(input$r1)*(1 - input$r2))
        n2 <- 500*(input$r1) - n1
        n3 <- 500*(1 - input$r2) - n1
        n4 <- 500 - n1 -n2 - n3
        
        df_sensi['color'] <- c(rep('False Neg', n1),
                               rep('Actual Pos', n2),
                               rep('False Pos', n3),
                               rep('Actual Neg', n4))
        
        
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") + 
            theme_bw() +
            theme(axis.title.x=element_blank(), 
                  axis.title.y=element_blank(), 
                  axis.line=element_blank(),
                  axis.text.x=element_blank(), 
                  axis.text.y=element_blank(),
                  axis.ticks=element_blank())
    })
    
   output$t1 <- renderPrint({
       n1 <- round(500*(input$r1)*(1 - input$r2))
       n2 <- 500*(input$r1) - n1
       n3 <- 500*(1 - input$r2) - n1
       n4 <- 500 - n1 -n2 - n3
       chance = (n3+n4)/(n1+n3+n4) *100
       
       chance
   })
}

# Run the application 
shinyApp(ui = ui, server = server)
