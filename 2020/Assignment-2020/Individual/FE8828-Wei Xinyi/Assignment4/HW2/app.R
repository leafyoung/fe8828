#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
  titlePanel("Plot infographic"),
  sidebarPanel(
    numericInput("Infection_rate", "Infection_rate", 0.25)),
  mainPanel(
    plotOutput("p1"))
  )

server <- function(input, output, session) {
  
  output$p1 <- renderPlot({ 
    library(ggplot2)
    
    df_sensi <- full_join( 
      tibble(x = 1:20, color = 'Actual Neg'), 
      tibble(y = 1:25, color = 'Actual Neg'),
      by = 'color')
    
    df_sensi['color'] <- c(rep('False Neg', round(500*input$Infection_rate*0.05)),
                           rep('Actual Pos', round(500*input$Infection_rate*0.95)), 
                           rep('False Pos', round(500*(1-input$Infection_rate)*0.05)), 
                           rep('Actual Neg', 500 - round(500*input$Infection_rate*0.05) - 
                                 round(500*input$Infection_rate*0.95) - 
                                 round(500*(1-input$Infection_rate)*0.05)))
    
    ggplot(df_sensi) + 
      geom_point(aes(x, y,colour = color), 
                 size = 4, shape="circle") +
      theme_bw() + 
      theme(axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            axis.line=element_blank(),axis.text.x=element_blank(),
            axis.text.y=element_blank(),axis.ticks=element_blank())
    
  })
}

shinyApp(ui, server)