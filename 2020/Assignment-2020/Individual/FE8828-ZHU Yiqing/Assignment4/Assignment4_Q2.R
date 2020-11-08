#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Covid-19 Test"),
    numericInput("InfectionRate", "Infection Rate(%)", 5),
    actionButton("draw", "Draw the Plot"),
    h2("Plot of Cash Flow"),
    plotOutput("plot1"),
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    gettable <- function(input){
        FN <-as.integer(0.05 * input$InfectionRate/100 * 500)
        AP <-as.integer(0.95 * input$InfectionRate/100 *500)
        FP <- as.integer(0.05 * (1- input$InfectionRate/100) * 500)
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
        df_sensi['color'] <- c(rep('False Neg', FN),
                               rep('Actual Pos', AP),
                               rep('False Pos', FP),
                               rep('Actual Neg', 500 - FN - AP - FP))
        df_sensi
    }
    observeEvent(input$draw, {
    output$plot1 <- renderPlot({ggplot(gettable(input)) +
            geom_point(aes(x, y,colour = color), size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())})
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
