library(shiny)
library(tidyverse)
ui <- fluidPage(
  numericInput("infectionrate", "Num", 0.05),
  actionButton("go", "Go"),
  plotOutput("p1")
)

server <- function(input, output, session)
{
  observeEvent(input$go,{
    df_sensi <- full_join(
      tibble(x = 1:25, color = 'Actual Neg'), tibble(y = 1:20, color = 'Actual Neg'), by = 'color')
    
    infectionr<-input$infectionrate
    df_sensi['color'] <- c(rep('False Neg', 500*infectionr*0.05),
                                                  rep('Actual Pos', 500*infectionr*0.95),
                                                  rep('False Pos', 500*(1-infectionr)*0.05),
                                                  rep('Actual Neg', 500 - 500*infectionr*0.05 - 500*infectionr*0.95 - 500*(1-infectionr)*0.05)+2) 
   
    output$p1 <-renderPlot({
      df_sensi
    })
    })
}

shinyApp(ui, server)