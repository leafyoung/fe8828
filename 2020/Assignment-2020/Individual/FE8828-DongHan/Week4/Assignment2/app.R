library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    numericInput("infRate", "Infection Rate: (%)", 5, min = 0, max = 100),
    actionButton('go','Generate Plot'),
    plotOutput("a",height='100%',width='100%'),

   
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$go,{
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'), tibble(y = 1:20, color = 'Actual Neg'), by = 'color')
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%) 
        false_neg = round(0.01*500*input$infRate*(1-0.95), 0)
        actual_pos = round(0.01*500*input$infRate*0.95, 0)
        false_pos = round(0.01*500*(100-input$infRate)*0.05, 0)
        
        df_sensi['color'] <- c(rep('False Neg', false_neg),
                               rep('Actual Pos', actual_pos),
                               rep('False Pos', false_pos),
                               rep('Actual Neg', 500-false_neg-actual_pos-false_pos))
        
        # 1. Use height and width with renderPlot
        output$a <- renderPlot({
            ggplot(df_sensi) +
                geom_point(aes(x, y,colour = color),
                           size = 4, shape="circle") + 
                theme_bw() +
                theme(axis.title.x=element_blank(), 
                      axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())
            
        }, width = 400, height = 200)
        
        # 2. Fix color coding for certain type of value
        # There are only three values in mtcars gear column, 3,4,5
        # Use character type to convert from continuous to discrete for ggplot
        mtcars['gear'] <- as.character(mtcars[['gear']])
        
        # Use a vector
        cols <- c("3" = "red", "4" = "blue", "5" = "darkgreen")
        
        output$b <- renderPlot({
            ggplot(mtcars) + geom_point(aes(mpg, cyl,color=gear), size = 4) +
                scale_colour_manual(values = cols)
        }, width = 400, height = 300)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
