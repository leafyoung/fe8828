library(shiny)
library(ggplot2)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    sliderInput("infectionrate", "Infection Rate (%)", min=1, max=100,value=5),
    actionButton('go','Go'),
   
    plotOutput("plot",height='auto',width='auto')
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$go,{
        
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
        df_sensi['color'] <- c(rep('False Neg', round(500 * input$infectionrate * 0.0005, 0)),
                               rep('Actual Pos', round(500 * input$infectionrate * 0.0095, 0)),
                               rep('False Pos', round(500 * (100 - input$infectionrate) * 0.0005, 0)),
                               rep('Actual Neg', 500 - round(500 * input$infectionrate * 0.0005, 0) - round(500 * input$infectionrate * 0.0095, 0) - 
                                       round(500 * (100 - input$infectionrate) * 0.0005, 0)))
        output$plot <- renderPlot({
            ggplot(df_sensi) +
                geom_point(aes(x, y,colour = color),
                           size = 7, shape="circle") +
                theme_bw() +
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())
        }, width = 600, height = 600)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
