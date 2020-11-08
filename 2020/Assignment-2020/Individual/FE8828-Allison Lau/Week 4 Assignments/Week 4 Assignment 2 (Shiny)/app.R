library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    numericInput(inputId = "infection_rate","Input Infection Rate in %", 5),
    actionButton(inputId = "go", "Go"),
    plotOutput("p1")
    )

server <- function(input, output, session) {
    observeEvent(input$go, {
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        
        positive <- round(500 * (isolate(input$infection_rate)/100))
        actual_pos <- round(0.95 * positive)
        false_neg <- round(0.05 * positive)
        negative <- round(500 - positive)
        actual_neg <- round(0.95 * negative)
        false_pos <- round(0.05 * negative)
        
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
        df_sensi['color'] <- c(rep('False Neg', false_neg),
                               rep('Actual Pos', actual_pos),
                               rep('False Pos', false_pos),
                               rep('Actual Neg', actual_neg))

    output$p1 <- renderPlot({
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    })})
}

# Run the application 
shinyApp(ui = ui, server = server)

