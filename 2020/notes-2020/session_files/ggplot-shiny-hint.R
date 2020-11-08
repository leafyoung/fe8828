library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    actionButton('go','Go'),
    # 1. Use auto for height/width
    plotOutput("a",height='auto',width='auto'),
    plotOutput("b",height='auto',width='auto'),
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$go,{
    
        # 1. Use height and width with renderPlot
        output$a <- renderPlot({
            ggplot(mtcars) + geom_line(aes(mpg, cyl))            
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
