library(conflicted)
library(shiny)
library(ggplot2)
library(tidyverse)
conflict_prefer("filter", "dplyr")

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Sidebar with a slider input for number of bins 
    sliderInput("InfectionRate",
                "InfectionRate:",
                min = 1,
                max = 100,
                value = 5),
    # Show a plot of the generated distribution
    h2("The results look like this"),
        plotOutput("distPlot"  ,   height='auto',width='auto'),   hr(),
    h2("The positive results look like this"),
        plotOutput("distPlot2",    height='auto',width='auto'),   hr(),
    h2("The negative results look like this"),
        plotOutput("distPlot3"    ,height='auto',width='auto')
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    test <- reactive({
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        
        FN <- as.integer(0.05 * input$InfectionRate * 500 /100)
        AP <- as.integer(0.95 * input$InfectionRate * 500 /100)
        FP <- as.integer(0.05 * (100-input$InfectionRate) * 500 /100)
        
        df_sensi['color'] <- c(rep('False Neg', FN),
                               rep('Actual Pos', AP),
                               rep('False Pos', FP),
                               rep('Actual Neg', 500 - FN - AP - FP))
        df_sensi
    })
    
    output$distPlot <- renderPlot({
        a <- test()

        cols <- c("False Neg" = "red", "Actual Pos" = "blue", "False Pos" = "darkgreen", "Actual Neg" = "grey")
        ggplot(a) +
            geom_point(aes(y, x,colour = color),
                       size = 4, shape="circle") + scale_colour_manual(values = cols) + scale_y_reverse() +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank(),panel.border = element_blank())}
        , width = 400, height = 200)
    
    output$distPlot2 <- renderPlot({
        a <- test()
        print(a)
        a <- filter(a, (color == 'Actual Neg') | (color == 'False Neg') )
        
        n <- rep(1,nrow(a)); m <- rep(1,nrow(a))
        for (i in seq_along(n)){
            n[i] = ((i-1) %/% 20)+1
            m[i] = ((i-1) %% 20) +1
        }
        a$x <- n
        a$y <- m
        print(a)
        
        cols <- c("False Neg" = "red", "Actual Pos" = "blue", "False Pos" = "green", "Actual Neg" = "grey")
        ggplot(a) +
            geom_point(aes(y, x,colour = color),
                       size = 4, shape="circle") + scale_colour_manual(values = cols) + scale_y_reverse() +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank(),panel.border = element_blank())    }
        , width = 400, height = 200)
    
    output$distPlot3 <- renderPlot({
        a <- test()
        a <- filter(a, (color == 'Actual Pos') | (color == 'False Pos') )
        
        n <- rep(1,nrow(a)); m <- rep(1,nrow(a))
        for (i in seq_along(n)){
            n[i] = ((i-1) %/% 20)+1
            m[i] = ((i-1) %% 20) +1 }
        a$x <- n; a$y <- m
        
        cols <- c("False Neg" = "red", "Actual Pos" = "blue", "False Pos" = "darkgreen", "Actual Neg" = "grey")
        ggplot(a) +
            geom_point(aes(y, x,colour = color),
                       size = 4, shape="circle") + scale_colour_manual(values = cols) +scale_y_reverse() +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank(),panel.border = element_blank())    }
        , width = 400, height = 200)
}

# Run the application 
shinyApp(ui = ui, server = server)
