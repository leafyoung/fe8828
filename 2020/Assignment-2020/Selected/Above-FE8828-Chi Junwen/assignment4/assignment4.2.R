

library(shiny)
library(ggplot2)
library(conflicted)
library(tidyverse)
conflict_prefer("lag", "dplyr")
conflict_prefer("filter", "dplyr")

ui <- fluidPage(

    titlePanel("False positive alarm"),
    numericInput("infrate","infection rate",0.05),
    actionButton('go','Go'),
    div(textOutput("t1"),style = "font-size:20px;",align="center"),
    div(plotOutput("a",height='auto',width='auto'),align="center"),
    div(textOutput("t2"),style = "font-size:20px;",align="center"),
    div(plotOutput("b",height='auto',width='auto'),align="center"),
    div(textOutput("t3"),style = "font-size:20px;",align="center"),
    div(plotOutput("c",height='auto',width='auto'),align="center")
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    df<-eventReactive(input$go,{
        ##input$infrate<-isolate(input$infrate)
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        df_sensi["color"]<-c(rep("False Neg",floor(500*input$infrate*0.05)),
                       rep("Actual Pos",floor(500*input$infrate-floor(500*input$infrate*0.05))),
                       rep("False Pos",ceiling(500*(1-input$infrate)*0.05)),
                       rep("Actual Neg",500-floor(500*input$infrate*0.05)-floor(500*input$infrate-floor(500*input$infrate*0.05))-ceiling(500*(1-input$infrate)*0.05)))
        df_sensi
    })
       
    observeEvent(input$go,{
        output$t1<-renderText(paste0("If a test with 95 percent specificity and 95 percent sensitivity is used iin a community of 500 people with a ",as.character(isolate(input$infrate)*100)," percent infection rate, the results look like this."))})
       
       output$a<-renderPlot({
            ggplot(df()) +
                geom_point(aes(x, y,colour = color),
                           size = 4, shape="circle") +
                theme_bw() +
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())+coord_flip()+scale_x_reverse()
        },width = 600, height =400 )
        
        
       observeEvent(input$go,{
           output$t2<-renderText(paste0("In this scenario,an in dividual who tests negative has a ",
                                        as.character((1-isolate(input$infrate))*0.95*100/(((1-isolate(input$infrate))*0.95)+isolate(input$infrate)*0.05))," percent chance of actualy being negative"))}) 
        
       
        
        output$b<-renderPlot({
            
            df2<-df()%>%filter(color=="False Neg"|color=="Actual Neg")
            
            y_length=length(df2$color)%/%20
            last_length=length(df2$color)%%(20*y_length)
            x<-c()
            for (i in 1:20){
                x<-c(x,rep(i,y_length))
            }
            x1<-c(x,rep(21,last_length))
            y1<-c(rep(1:y_length,20),1:last_length)
            
            assign("par_height",y_length+1,envir=.GlobalEnv)
            df2<-mutate(df2,x=x1,y=y1)
                df2%>%ggplot() +
                geom_point(aes(x, y,colour = color),
                           size = 4, shape="circle") +
                theme_bw() +
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())+coord_flip()+scale_x_reverse()
        },width = 600, height = 400)
        
        observeEvent(input$go,{
            output$t3<-renderText(paste0("And an individual who tests positive has an ",
                                         as.character(isolate(input$infrate)*0.95*100/((1-isolate(input$infrate))*0.05+isolate(input$infrate)*0.95))," percent chance of actually being positive"))}) 
        
        output$c<-renderPlot({
            df3<-df()%>%filter(color=="False Pos"|color=="Actual Pos")
            
            x_length=length(df3$color)%/%20
            
            
            last_length=length(df3$color)%%(20*x_length)
            
            y1<-c(rep(1:20,x_length),rep(1:last_length))
            
            x<-c()
            for(i in 1:x_length){
                x<-c(x,rep(i,20))
            }
            x1<-c(x,rep(x_length+1,last_length))
            df3<-mutate(df3,x=x1,y=y1)
            df3%>%ggplot() +
                geom_point(aes(x, y,colour = color),
                           size = 4, shape="circle") +
                theme_bw() +
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())+coord_flip()+scale_x_reverse()
        },width = 600, height=100)
            
       
}

# Run the application 
shinyApp(ui = ui, server = server)
