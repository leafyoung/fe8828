#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tibble)
library(dplyr)
library(tidyr)

ui <- fluidPage(
       
    titlePanel(strong("Assignment 4.2")),
 
         fluidRow(
            column(3,h3(strong("Input For Charts")),
               hr(),
               numericInput("rate","Infection Rate (0 to 1)",value=0.05),
               numericInput("size","Sample Size",value=500),
               numericInput("speci","Specificity (0 to 1)",value=0.95),
               h6("Note: High specificity means low rate of false positives"),
               numericInput("sensi","Sensitivity (0 to 1)",value=0.95),
               h6("Note: High sensitivity means low rate of false negatives")
 
            ),
            
            column(9, align="center",
               h4(strong(textOutput("comment1"),align = "left")),
               plotOutput("infection1",width = 800,height = 400),
               h4(strong(textOutput("comment2"),align = "left")),
               plotOutput("infection2",width = 800,height = 400),
               h4(strong(textOutput("comment3"),align = "left")),
               br(),
               plotOutput("infection3",width = 800,height = 400)
            
            )
            
         )
)
   
# Define server logic for plotting the three charts
server <- function(input, output) {
   
   #write a function that automatically adjust row and col of chart given sample size
   chart_data <- function(s){
      chrt_row <- 0
      chrt_col <- 0
      for(i in as.integer(sqrt(s)):s)
      {
         if(input$size %% i==0)
         {  
            chrt_col=i
            chrt_row=input$size/i
            break
         }
      }
      
      y <- tibble(col=1:chrt_col,color="Actual Negative")
      x <- tibble(row=1:chrt_row,color="Actual Negative")
      pdata <- full_join(x,y,by="color")

   }
   
   # high specificity means low rate of false positive (negative but test positive)
   #high sensitivity means low rate of false negative (positive but test negative)
   
   #comment for the first chart
   output$comment1 <- renderText({
      paste("If a test with",input$speci*100,"percent specificity and",input$sensi*100,"percent sensitivity is used 
            in a community of",input$size,"people with a",input$rate*100,"percent infection rate, the results look like this:")
      
   })
   
   #plot the first chart
   output$infection1 <- renderPlot({
      
      pdata <- chart_data(input$size)
      #calculate number of dots for each color
      F_N <- round(input$size*input$rate*(1-input$sensi))
      A_P <- round(input$size*input$rate*input$sensi)
      F_P <- round(input$size*(1-input$rate)*(1-input$speci))
      A_N <- input$size-F_N-A_P-F_P
      pdata$color <- c(
         rep("False Negative",F_N),
         rep("Actual Positive",A_P),
         rep("False Positive",F_P),
         rep("Actual Negative",A_N)
      )

      chart1 <- ggplot(pdata,aes(x=col,y=row,color=color))+geom_point(size=4)+theme_void()+scale_y_reverse()+
                                                           scale_color_manual(values=c("darkorange1","black","green","purple"))
      chart1
   })
   
#comment for the second chart
   output$comment2 <- renderText({
      F_N <- round(input$size*input$rate*(1-input$sensi))
      A_P <- round(input$size*input$rate*input$sensi)
      F_P <- round(input$size*(1-input$rate)*(1-input$speci))
      A_N <- input$size-F_N-A_P-F_P
      percent <- A_N/(A_N+F_N)*100
      percent <- round(percent,2)
      paste("In this scenario, an individual who tests negative has a",percent,"percent chance of actually being negative.")
      
   })
   
#plot the second chart
output$infection2 <- renderPlot({
   
   pdata <- chart_data(input$size)
   F_N <- round(input$size*input$rate*(1-input$sensi))
   A_P <- round(input$size*input$rate*input$sensi)
   F_P <- round(input$size*(1-input$rate)*(1-input$speci))
   A_N <- input$size-F_N-A_P-F_P
   pdata$color <- c(
      rep("Actual Negative",A_N),
      rep("False Negative",F_N),
      rep("Null",A_P+F_P)
   )

   #plot the third chart
   if(A_N==0 || F_N==0)
   {
      chart2 <- ggplot(pdata,aes(x=col,y=row,color=color))+geom_point(size=4)+theme_void()+scale_y_reverse()+
         scale_color_manual(values=c("darkorange1","white"))
      chart2
      
   }else{
      chart2 <- ggplot(pdata,aes(x=col,y=row,color=color))+geom_point(size=4)+theme_void()+scale_y_reverse()+
         scale_color_manual(values=c("darkorange1","black","white"))
      chart2
   }

  })

#comment for the third chart
output$comment3 <- renderText({
   F_N <- round(input$size*input$rate*(1-input$sensi))
   A_P <- round(input$size*input$rate*input$sensi)
   F_P <- round(input$size*(1-input$rate)*(1-input$speci))
   A_N <- input$size-F_N-A_P-F_P
   percent1 <- A_P/(A_P+F_P)*100
   percent1 <- round(percent1,2)
   paste("But an individual who tests positive has a",percent1,"percent chance of actually being positive.")
   
})

#plot the third chart
output$infection3 <- renderPlot({
   
   pdata <- chart_data(input$size)
   F_N <- round(input$size*input$rate*(1-input$sensi))
   A_P <- round(input$size*input$rate*input$sensi)
   F_P <- round(input$size*(1-input$rate)*(1-input$speci))
   A_N <- input$size-F_N-A_P-F_P
   pdata$color <- c(
      rep("Actual Positive",A_P),
      rep("False Positive",F_P),
      rep("Null",A_N+F_N)
   )
   
   if(A_P==0||F_P==0)
   {
      chart3 <- ggplot(pdata,aes(x=col,y=row,color=color))+geom_point(size=4)+theme_void() +scale_y_reverse()+
         scale_color_manual(values=c("darkorange1","white"))+
         theme(legend.justification = "top")
      chart3
      
   }else{
      chart3 <- ggplot(pdata,aes(x=col,y=row,color=color))+geom_point(size=4)+theme_void() +scale_y_reverse()+
         scale_color_manual(values=c("darkorange1","black","white"))+
         theme(legend.justification = "top")
      chart3
   }

})
}
# Run the application 
shinyApp(ui = ui, server = server)
