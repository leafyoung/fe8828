library(shiny)


ui <- fluidPage(
    numericInput("infec_rate", "infection rate", 0.05),
    actionButton("go", "Go"),
    plotOutput("p1")
)

server <- function(input, output, session) {
    df_sensi <- eventReactive(input$go, {
        library(tidyverse)
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
            inr<-isolate(input$infec_rate)
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
            a<-round(500*inr*0.05,0)
            b<-round(500*inr*0.95,0)
            c<-round(500*(1-inr)*0.95,0)
            df_sensi['color'] <- c(rep('False Neg',a ),
                               rep('Actual Pos', b),
                               rep('False Pos', c),
                               rep('Actual Neg', 500 - a-b-c))
        
            df_sensi
    })
  
    output$p1 <- renderPlot({
        ggplot(df_sensi()) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }) 
}

shinyApp(ui, server)
