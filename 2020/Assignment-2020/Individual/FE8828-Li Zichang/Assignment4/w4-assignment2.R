# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(conflicted)
library(tidyverse)
conflict_prefer("lag", "dplyr")
conflict_prefer("filter", "dplyr")
library(ggplot2)
                                     

ui <- fluidPage(
    "500 people in total.",
    p(),
    "We have 95% specificity and 95% sensitivity.",
    p(),
    numericInput("num", "Infection rate", 0.05),
    actionButton("go", "Go"),
    plotOutput("p1"),
    textOutput("text"),
)



# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$go, {
        output$p1 <- renderPlot({
          input_num <- isolate(input$num)
          
          df_sensi <- full_join(tibble(x = 1:25, color = 'Actual Neg'),
                                tibble(y = 1:20, color = 'Actual Neg'),
                                by = 'color')
          
          Actual_pos <- round(500 * input_num * 0.95)
          False_neg <- 500 * input_num - Actual_pos
          Actual_neg <- round(500 * (1 - input_num) * 0.95)
          False_pos <- 500 * (1 - input_num) - Actual_neg
          
          df_sensi['color'] <-c(rep('False Neg', False_neg),
                                rep('Actual Pos', Actual_pos),
                                rep('False Pos', False_pos),
                                rep('Actual Neg', Actual_neg))
          
          ggplot(df_sensi) + 
              geom_point(aes(x, y, colour = color), size = 4, shape ="circle") + 
              theme_bw() + 
              theme(axis.title.x = element_blank(),axis.title.y = element_blank(),
                    axis.line = element_blank(),axis.text.x = element_blank(),
                    axis.text.y = element_blank(),axis.ticks = element_blank())
            })
        
          ##output$text <- renderText({"In this scenario, an individual who tests negative has a xxx percent chance 
            #  of actually being negative."})
          ## Sorry Dr.Yang, I don't know how to output the reactive number inside the text...
    })
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
