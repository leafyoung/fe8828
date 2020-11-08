library(shiny)
library(dplyr)
library(ggplot2)


ui <- fluidPage(

    titlePanel("Infection Test Simulation"),
    
    hr(),

    sidebarLayout(
        
        sidebarPanel(
            sliderInput("infectionRate",
                        "Infection Rate (%):",
                        min = 0,
                        max = 100,
                        value = 25),
            width = 3
        ),


        mainPanel(
           plotOutput("chart")
        )
    )
)


server <- function(input, output) {

    output$chart <- renderPlot({
        
        df_sensi <- full_join(
            tibble(x = 1:20, color = 'Actual Neg'),
            tibble(y = 1:25, color = 'Actual Neg'),
            by = 'color')
        
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
        
        rate = input$infectionRate * 0.01
        
        actPos = round(rate * 500 * 0.95,0)
        falNeg = round(rate * 500 * 0.05,0)
            
        actNeg = round((1-rate) * 500 * 0.95,0)
        falPos = round((1-rate) * 500 * 0.05,0)
        
        
        df_sensi['color'] <- c(rep('False Neg', falNeg),
                               rep('Actual Pos', actPos),
                               rep('False Pos', falPos),
                               rep('Actual Neg', 500 - falNeg - actPos - falPos))
        
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 5, shape="circle") +
            theme_classic() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank()) +
            scale_color_manual(values = c("#6bcab6", "#ef5675", "#003f5c", "#ffa600"),
                               limits = c("False Neg", "Actual Pos", "False Pos", "Actual Neg")) +
            coord_flip() +
            scale_x_reverse()
        
        
    })
}


shinyApp(ui = ui, server = server)
