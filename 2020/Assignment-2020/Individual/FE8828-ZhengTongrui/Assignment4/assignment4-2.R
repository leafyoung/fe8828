library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)

ui <- fluidPage(
    h3("graph of testing results"),
    sliderInput("infection_rate", "infection rate", 0,1,0.05),
    actionButton("Plot","Plot the result"),
    
    h3("Plot result"),
    plotOutput("p1"),
)

server <- function(input, output, session) {
    
    cal<-function(){
        df_sensi<-full_join(
            tibble(x=1:25,color="Actual Neg"),
            tibble(y=1:20,color="Actual Neg"),
            by="color")
        
        df_sensi["color"]<-c(rep("False Neg",round(500*input$infection_rate*0.05)),
                             rep("Actual Pos",round(500*input$infection_rate*0.95)),
                             rep("False Pos",round(500*(1-input$infection_rate)*0.05)),
                             rep("Actual Neg",500-round(500*(1-input$infection_rate)*0.05)-
                                     round(500*input$infection_rate*0.95)-round(500*input$infection_rate*0.05)))
        return(df_sensi)
        
    }
    observeEvent(input$Plot,{
        result<-cal()
        output$p1<-renderPlot({ggplot(result) +
                geom_point(aes(x,y,colour=color),
                           size=8,shape="circle")+
                theme_bw()+
                theme(axis.title.x=element_blank(),axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())}) 
    })
}

shinyApp(ui, server)
