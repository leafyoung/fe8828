library(shiny)
library(tidyverse)
library(conflicted)
conflict_prefer("filter","dplyr")
conflict_prefer("lag","dplyr")

ui <- fluidPage(
    fluidPage(
        titlePanel(h3("Coronavirus Antibody Tests Have a Mathematical Pitfall"))),
    numericInput("r", "Infection Rate: ", 0.05),
    actionButton('go','Go'),
    plotOutput("P1",height='auto',width='auto')
)


server <- function(input, output) {
    
    # At 5% infection rate, 
    # Positive 500 * 5% = 25 = Actual Po=s (24 at 95%) + False Neg (1 at 5%) 
    # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%) 
    
    observeEvent(input$go,{
    df <- reactiveVal(0)
    cal_df <- function(){
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'), 
            tibble(y = 1:20, color = 'Actual Neg'), 
            by = 'color') 
        
        a <- round(500*0.95* isolate(input$r))
        b <- round(500*0.05* isolate(input$r))
        df_sensi["color"] <- c(rep('False Neg',b),
                               rep('Actual Pos',500*0.05-b), 
                               rep('False Pos',a),
                               rep('Actual Neg',500*0.95-a))
        df(df_sensi)
    }
    
    observeEvent(isolate(input$r), cal_df())
    
    output$P1 <- renderPlot({
    ggplot(df()) +
        geom_point(aes(x, y,colour = color), 
                   size = 4, shape="circle") + 
        theme_bw() + 
        theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
              axis.line=element_blank(),axis.text.x=element_blank(),
              axis.text.y=element_blank(),axis.ticks=element_blank())
        },width = 650, height = 500)  #fixed size
    })
}

shinyApp(ui = ui, server = server)
