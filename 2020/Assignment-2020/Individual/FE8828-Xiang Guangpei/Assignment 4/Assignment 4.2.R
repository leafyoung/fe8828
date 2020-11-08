library(shiny)
library(ggplot2)
library(dplyr)
library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

ui <- fluidPage(
    numericInput("infection_rate", "Infection Rate", min = 0, max = 100, value =  5),
    numericInput("specificity", "Specificity", min = 0, max = 100, value = 95),
    numericInput("sensitivity", "Sensitivity", min = 0, max = 100, value = 95),
    actionButton('go','Go'),
    h3("With specificity and sensitivity as choosen, the results look like this:"),
    plotOutput("resulta",height='auto',width='auto'),
    h3("An individual who test negative can actually be positive with probability of:"),
    textOutput("ratio1"),
    plotOutput("resultb",height='auto',width='auto'),
    h3("An individual who test positive can actually be positive with probability of:"),
    textOutput("ratio2"),
    plotOutput("resultc",height='auto',width='auto')
)


server <- function(input, output, session) {
    coltable <-function(){ 
        
        df_sensi <- full_join(
        tibble(x = 1:25, color = 'Actual Neg'),
        tibble(y = 1:20, color = 'Actual Neg'),
        by = 'color')

        FN <- as.integer( 500*input$infection_rate/100 - round(500*input$infection_rate/100*input$specificity/100))
        AP <- as.integer( round(500*input$infection_rate/100*input$specificity/100))
        FP <- as.integer( round(500*(1-input$infection_rate/100)*(1-input$specificity/100)))
        AN <- 500-FN-AP-FP
        
        df_sensi['color'] <- c(rep('False Neg', FN),
                           rep('Actual Pos', AP),
                           rep('False Pos', FP),
                           rep('Actual Neg', AN))
        
        df_test_neg <- filter(df_sensi, color %in% c("Actual Neg", "False Neg"))
        df_test_pos <- filter(df_sensi, color %in% c("Actual Pos", "False Pos"))
        
        datas <- list(df_sensi,df_test_neg,df_test_pos)
        return(datas)
        }
     ratio1 <- function(){
            FN <- as.integer( 500*input$infection_rate/100 - round(500*input$infection_rate/100*input$specificity/100))
            AP <- as.integer( round(500*input$infection_rate/100*input$specificity/100))
            FP <- as.integer( round(500*(1-input$infection_rate/100)*(1-input$specificity/100)))
            AN <- 500-FN-AP-FP
            test_neg <- AN + FN
            ratio <- AN /  test_neg
            return(ratio)
}   

    ratio2 <- function(){
            FN <- as.integer( 500*input$infection_rate/100 - round(500*input$infection_rate/100*input$specificity/100))
            AP <- as.integer( round(500*input$infection_rate/100*input$specificity/100))
            FP <- as.integer( round(500*(1-input$infection_rate/100)*(1-input$specificity/100)))
            AN <- 500-FN-AP-FP
            test_pos <- AP + FP
            ratio <- AP /  test_pos
            return(ratio)
}   
observeEvent(input$go,{
                   output$resulta <- renderPlot({
                   ggplot(coltable()[[1]]) +
                        geom_point(aes(x, y,colour = color),size = 4, shape="circle") +
                        theme_bw() +
                        theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                              axis.line=element_blank(),axis.text.x=element_blank(),
                              axis.text.y=element_blank(),axis.ticks=element_blank())
                    }, width = 400, height = 300)
                   output$resultb <- renderPlot({
                       ggplot(coltable()[[2]]) +
                           geom_point(aes(x, y,colour = color),size = 4, shape="circle") +
                           theme_bw() +
                           theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                                 axis.line=element_blank(),axis.text.x=element_blank(),
                                 axis.text.y=element_blank(),axis.ticks=element_blank())
                   }, width = 400, height = 300)
                   output$resultc <- renderPlot({
                       ggplot(coltable()[[3]]) +
                           geom_point(aes(x, y,colour = color),size = 4, shape="circle") +
                           theme_bw() +
                           theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                                 axis.line=element_blank(),axis.text.x=element_blank(),
                                 axis.text.y=element_blank(),axis.ticks=element_blank())
                   }, width = 400, height = 300)
                   output$ratio1 <- renderText(ratio1())
                   output$ratio2 <- renderText(ratio2())
                })

}
shinyApp(ui = ui, server = server)
