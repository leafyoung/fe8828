library(shiny)
library(ggplot2)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Infection Plot"),
    numericInput("infectionrate","Infection rate",0.05),
    actionButton("go", "Go"),
    textOutput("t1"),
    plotOutput("p1"),
    textOutput("t2"),
    plotOutput("p2"),
    textOutput("t3"),
    plotOutput("p3")
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    observeEvent(input$go,{
        infectionrate<-isolate(input$infectionrate)
        realneg_testneg<-round(500*(1-infectionrate)*0.95)
        realneg_testpos<-round(500*(1-infectionrate)*0.05)
        realpos_testpos<-round(500*infectionrate*0.95)
        realpos_testneg<-round(500*infectionrate*0.05)
        
        testneg_percent<-realneg_testneg/(realneg_testneg+realpos_testneg)
        
        testpos_percent<-realpos_testpos/(realpos_testpos+realneg_testpos)
        
        output$t1<-renderText({
            perc<-infectionrate
            res <- paste0('a text with 95 percent specificity and 95 percent sensitivity is used in a community of 500 people with a ', round(perc,3) * 100, ' percent infection rate. The result looks like this:')
            res
        })
        
        df_sensi<-full_join(
            tibble(x=1:25,color='Actual Neg'),
            tibble(y=1:20,color='Actual Neg'),
            by='color')
        df_sensi['color']<-c(rep('False Neg',realpos_testneg),
                             rep('Actual Pos',realpos_testpos),
                             rep('False Pos',realneg_testpos),
                             rep('Actual Neg',500-realpos_testneg-realpos_testpos-realneg_testpos)
                             )
        output$p1<-renderPlot({
            ggplot(df_sensi)+
            geom_point(aes(x,y,colour=color),
                       size=4,shape="circle")+
            theme_bw()+
            theme(axis.title.x=element_blank(),axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
        
        })
        
        output$t2<-renderText({
            perc<-testneg_percent
            res <- paste0('In this scenario, an individual who tests negative has a ', round(perc,3)*100, ' percent chance of actually being negative.')
            res
        })
        
        
        output$t3<-renderText({
            perc<-testpos_percent
            res <- paste0('But an individual who tests positive only has a ', round(perc,3) * 100, ' percent chance of actually being positive.')
            res
        })
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

