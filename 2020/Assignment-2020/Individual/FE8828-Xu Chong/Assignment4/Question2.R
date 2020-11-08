library(shiny)
library(ggplot2)

ui <- fluidPage(
    
    sidebarPanel(
        numericInput("infection", "Infection Rate(%)", 5),
        actionButton('go','Go'),
    ),
    
    mainPanel(
        plotOutput("a",height='auto',width='auto'),
    )
    
)

server <- function(input, output, session) {
    observeEvent(input$go,{
    
        output$a <- renderPlot({
            
            
            df_sensi <- full_join( 
                tibble(x = 1:25, color = 'Actual Neg'), 
                tibble(y = 1:20, color = 'Actual Neg'), by = 'color')
            
            total_positive <- as.integer( 500 * input$infection / 100 )
            total_negative <- 500 - total_positive
            actual_pos <- as.integer( total_positive * 0.95 )
            false_neg <- total_positive - actual_pos
            actual_neg <- as.integer( total_negative * 0.95 )
            false_pos <- total_negative - actual_neg
            
            df_sensi['color'] <- c(rep('False Neg', false_neg),
                                   rep('Actual Pos', actual_pos),
                                   rep('False Pos', false_pos),
                                   rep('Actual Neg', actual_neg))
            
            ggplot(df_sensi) + 
                geom_point(aes(x, y,colour = color), size = 4, shape="circle") + 
                theme_bw() + 
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(), axis.line=element_blank(), axis.text.x=element_blank(), axis.text.y=element_blank(), axis.ticks=element_blank())
        }, width = 400, height = 200)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
