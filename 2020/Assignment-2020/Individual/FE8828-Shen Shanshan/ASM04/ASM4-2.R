library(shiny)
library(dplyr)
library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

ui <- fluidPage(
    titlePanel("Coronavirus Antibody Tests Have a Mathematical Pitfall"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("infect",
                        "Infection Rate:",
                        min = 1,
                        max = 100,
                        value = 5),
            actionButton("go", "Go")
        ),
        
        mainPanel(
            h3("With 95% specificity and 95% sensitivity, the results look like this:"),
            plotOutput("plot1"),
            h3("An individual who test negative can actually be positive with probability of:"),
            textOutput("ratio1"),
            plotOutput("plot2"),
            h3("An individual who test positive can actually be positive with probability of:"),
            textOutput("ratio2"),
            plotOutput("plot3")
        )
    )
)

server <- function(input, output, session) {
    make_graph <- function(n){
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        
        df_sensi['color'] <- c(rep('False Neg', round(500*n*0.01*0.05)),
                               rep('Actual Pos', round(500*n*0.01*0.95)),
                               rep('False Pos', round(500*(100-n)*0.01*0.05)),
                               rep('Actual Neg', round(500*(100-n)*0.01*0.95)))
        df_test_neg <- filter(df_sensi, color %in% c("Actual Neg", "False Neg"))
        df_test_pos <- filter(df_sensi, color %in% c("Actual Pos", "False Pos"))
        
        g1 <- ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
        
        g2 <- ggplot(df_test_neg) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
        
        g3 <- ggplot(df_test_pos) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
        
        graphs <- list(g1, g2, g3)
        return(graphs)
    }
    
    ratio1 <- function(n){
        actual_neg <- round(500*(100-n)*0.01*0.95)
        false_neg <- round(500*n*0.01*0.05)
        test_neg <- actual_neg + false_neg
        ratio <- actual_neg / test_neg
        print(ratio)
    }
    
    ratio2 <- function(n){
        actual_pos <- round(500*n*0.01*0.95)
        false_pos <- round(500*(100-n)*0.01*0.05)
        test_pos <- actual_pos + false_pos
        ratio <- actual_pos / test_pos
        print(ratio)
    }
    
    observeEvent(input$go,{
        output$plot1 <- renderPlot(make_graph(isolate(input$infect))[1])
        output$ratio1 <- renderText(ratio1(isolate(input$infect)))
        output$ratio2 <- renderText(ratio2(isolate(input$infect)))
        output$plot2 <- renderPlot(make_graph(isolate(input$infect))[2])
        output$plot3 <- renderPlot(make_graph(isolate(input$infect))[3])
    }
    )
}

shinyApp(ui = ui, server = server)
