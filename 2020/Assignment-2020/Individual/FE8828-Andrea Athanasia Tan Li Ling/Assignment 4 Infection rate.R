library(shiny)
library(tidyverse)
library(ggplot2)

ui <- fluidPage(
    titlePanel(strong("Coronavirus Antibody Tests Have a Mathematical Pitfall")),
    sidebarLayout(
        sidebarPanel(
            sliderInput("irate","Infection rate",min=1,max=100,value=5,step=1),
            actionButton("go","Go")
        ),
        mainPanel(
            p("With any test that is not 100 percent accurate, there are four possible outcomes for each individual:"),
            tags$ul("",
                    tags$li("You are positive and test positive"),
                    tags$li("You are negative and test negative"),
                    tags$li("You are positive but test negative"),
                    tags$li("You are negative but test positive")),
            p("A test with a low rate of false positives has a high specificity."),
            p("A test with a low rate of false negatives has a high sensitivity."),
            p("If a test has 95 percent specificity and 95 percent sensitivity, 
              that means it correctly identifies 95 percent of people who are 
              positive and 95 percent of those who are negative. Even with very 
              effective screening tests, depending on the infection rate in the 
              population, an individual's test result may not be reliable. "),
            hr(),
            textOutput("Des"),
            plotOutput("infogram",height='auto',width='auto'),
            textOutput("Des1"),
            plotOutput("AN",height='auto',width='auto'),
            textOutput("Des2"),
            plotOutput("AP",height='auto',width='auto')
        )
    )
)

server <- function(input,output,session){
    observeEvent(input$go, {
        df_sensi <- full_join(
            tibble(x = 1:20, color = 'white'),
            tibble(y = 1:25, color = 'white'),
            by = 'color')
        
        Positive <- round(500 * isolate(input$irate)/100) #25
        Negative <- 500 - Positive #475
        Actpos <- round(0.95 * Positive) #24
        Falneg <- Positive - Actpos #1
        Actneg <- round(0.95 * Negative) #451
        Falpos <- Negative - Actneg #24
        
        df_sensi['color'] <- c(rep('You are positive but test negative', Falneg),
                               rep('You are positive and test positive', Actpos),
                               rep('You are negative but test positive', Falpos),
                               rep('You are negative and test negative', Actneg))

        df_sensi['color'] <- as.character(df_sensi[['color']])
        cols <- c('You are positive but test negative' = "maroon", 
                  'You are positive and test positive' = "orange", 
                  'You are negative but test positive' = "darkgreen",
                  'You are negative and test negative'= "lightblue")
        
        output$Des <- renderText({paste("If a test with 95 percent specificity 
                                        and 95 percent sensitivity is used in a 
                                        community of 500 people with a ",
                                        isolate(input$irate),"percent infection
                                        rate, the results look like this:")})
        
        output$infogram <- renderPlot({ggplot(df_sensi) +
                geom_point(aes(x, y,colour = color),size = 4, shape="circle") + 
                scale_colour_manual(values = cols) +
                theme_bw() +
                coord_flip() + scale_x_reverse() +
                theme(legend.position = "top", legend.title = element_blank(),
                      axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())},
                                   width=25*20,height=20*20)
        
        #FIGURE 2
        Testneg <- Actneg + Falneg
        AN <- format(round(Actneg/Testneg*100,2),nsmall=1)
        output$Des1 <- renderText({paste("In this scenario, an individual who tests
                                        negative has a",AN,"percent chance of actually 
                                         being negative")})
        
        base <- ceiling(Testneg/25)
        df_AN <- full_join(
            tibble(x = 1:base, color = 'white'),
            tibble(y = 1:25, color = 'white'),
            by = 'color')
        
        df_AN['color'] <- c(rep('You are negative and test negative', Actneg),
                            rep('You are positive but test negative', Falneg),
                            rep('NIL',25*base-Testneg))
        
        df_AN['color'] <- as.character(df_AN[['color']])
        cols1 <- c('You are positive but test negative' = "maroon", 
                   'You are negative and test negative'= "lightblue",
                   'NIL'= "white")
        
        output$AN <- renderPlot({ggplot(df_AN) +
                geom_point(aes(x, y,colour = color),size = 4, shape="circle") + 
                scale_colour_manual(values = cols1) +
                theme_bw() +
                coord_flip() + scale_x_reverse() +
                theme(legend.position = "none", legend.title = element_blank(),
                      axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())},
                width=25*20,height=base*20)

        #FIGURE 3
        Testpos <- Actpos + Falpos
        AP <- format(round(Actpos/Testpos*100,2),nsmall=1)
        output$Des2 <- renderText({paste("But an individual who tests positive only 
                                        has a",AP,"percent chance of actually 
                                         being positive")})
        
        base2 <- ceiling(Testpos/25)
        df_AP <- full_join(
            tibble(x = 1:base2, color = 'white'),
            tibble(y = 1:25, color = 'white'),
            by = 'color')
        
        df_AP['color'] <- c(rep('You are positive and test positive', Actpos),
                            rep('You are negative but test positive', Falpos),
                            rep('NIL',25*base2-Testpos))
        
        df_AP['color'] <- as.character(df_AP[['color']])
        cols2 <- c('You are positive and test positive' = "orange", 
                   'You are negative but test positive' = "darkgreen",
                   'NIL'= "white")
        
        output$AP <- renderPlot({ggplot(df_AP) +
                geom_point(aes(x, y,colour = color),size = 4, shape="circle") + 
                scale_colour_manual(values = cols2) +
                theme_bw() +
                coord_flip() + scale_x_reverse() + xlim(0.5,base2+0.5)+
                theme(legend.position = "none", legend.title = element_blank(),
                      axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())},
               height=100, width=25*20)
    })
}

shinyApp(ui,server)
