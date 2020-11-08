

library(shiny)
library(jrvFinance)
library(tidyverse)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            
            numericInput("infection", "What is the infection rate", .05, min=0, step=0.001),
            actionButton("go", "Go")),

        mainPanel(
            plotOutput("mygraph"),
        )
    )
    
)
    

server <- function(input, output, session) {
    observeEvent(input$go, {
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
        df_sensi['color'] <- c(rep('False Neg', input$infection*500-round(input$infection*500*.95)),
                               rep('Actual Pos', round(input$infection*500*.95)),
                               rep('False Pos', (1-input$infection)*500-round((1-input$infection)*500*.95)),
                               rep('Actual Neg', round((1-input$infection)*500*.95)))
        g <- ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
        
        output$mygraph <- renderPlot(g)
    })
    
}

shinyApp(ui, server)