library(shiny)
library(ggplot2)

ui <- fluidPage(
    
    titlePanel("False Positive Alarm"),
    numericInput("infection", "Infection Rate",0.0,min = 0, max = 100, step = 0.01),
    actionButton("go", "Go"),
    
    plotOutput("p1",height='auto',width='auto'),
    br(),
    textOutput("neg"),
    plotOutput("p2",height='auto',width='auto'),
    br(),
    textOutput("pos"),    
    plotOutput("p3",height='auto',width='auto'),
    
    br()
    
    
)


server <- function(input, output, session) {
    
    observeEvent(input$go,{
        infrate <- isolate(input$infection)
        actrlpos = round(500 * infrate*0.95,0)
        actrlneg = round(500 * (1-infrate)*0.95,0)
        falseneg = round(500 * infrate*0.05,0)
        falsepos = round(500 * (1-infrate)*0.05,0)
        
        # ----------------------------
        totalneg = actrlneg + falseneg
        height1 = ceiling(totalneg/25)/20*600
        condineg = round((1-infrate)*0.95/((1-infrate)*0.95 + infrate*0.05)*100,1)
        # ----------------------------
        totalpos = actrlpos + falsepos
        height2 = ceiling(totalpos/25)/20*600
        condipos = round(infrate*0.95/((1-infrate)*0.05 + infrate*0.95)*100,1)
        
        
        output$p1 <- renderPlot({
        df_sensi <- full_join(
            tibble(x = 1:20, color = 'Actual Neg'),
            tibble(y = 1:25, color = 'Actual Neg'),
            by = 'color')
        
      
        df_sensi['color'] <- c(rep('False Neg', falseneg),
                               rep('Actual Pos', actrlpos),
                               rep('False Pos', falsepos),
                               rep('Actual Neg', 500 - falsepos - falseneg - actrlpos))
        
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 6, shape="circle") + 

            scale_color_manual(values=c("grey","red","orange","pink"))+
            coord_flip() +
            scale_x_reverse()+
            theme_bw() +
            theme(text = element_text(size=20),
                  
                  axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())

        }, width = 800, height = 600)
        
        # # ===============Plot 2 Negative ================
        output$neg <- renderText({paste0("\nIn this scenario, an individual who tests negative has a ", condineg," percent chance of actually being negative\n")})
        output$p2 <- renderPlot({
            
            
            rows = floor(totalneg/25)
            shortcol = totalneg %% 25

            df_neg <- full_join(
                tibble(x = 1:25, color = 'Actual Neg'),
                tibble(y = 1:rows, color = 'Actual Neg'),
                by = 'color')

            if(shortcol > 0){
                df_neg <- bind_rows(df_neg, tibble(x = 1:shortcol, y = rep((rows+1), shortcol), color = 'Actual Neg'))
            }


            df_neg['color'] <- c(rep('Actual Neg', actrlneg), rep('False Neg', falseneg))

            ggplot(df_neg) +
                geom_point(aes(x, y,colour = color),
                           size = 6, shape="circle") +
                scale_color_manual(values=c("grey","orange"))+
                scale_y_reverse(expand = c(0,0.5))+
                theme_bw() +
                theme(text = element_text(size=20),
                      axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())

        }, width = 800, height = height1)
        
        # ===============Plot 3 Postive ================
        output$pos <- renderText({paste0("\nIn this scenario, an individual who tests positive has a ", condipos," percent chance of actually being positive\n")})
        output$p3 <- renderPlot({
            
            
            rows = floor(totalpos/25)
            shortcol = totalpos %% 25
            
            df_pos <- full_join(
                tibble(x = 1:25, color = 'Actual Neg'),
                tibble(y = 1:rows, color = 'Actual Neg'),
                by = 'color')
            
            if(shortcol > 0){
                df_pos <- bind_rows(df_pos, tibble(x = 1:shortcol, y = rep((rows+1), shortcol), color = 'Actual Neg'))
            }
            
            df_pos <- arrange(df_pos, y, x)
            df_pos['color'] <- c(rep('Actual Pos', actrlpos), rep('False Pos', falsepos))
            
            ggplot(df_pos) +
                geom_point(aes(x, y,colour = color),
                           size = 6, shape="circle") +
                scale_color_manual(values=c("red","pink"))+
                scale_y_reverse(expand = c(0,0.5))+
                theme_bw() +
                theme(text = element_text(size=20),
                      axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())
            
        }, width = 800, height = height2)
    })
}
        


# Run the application 
shinyApp(ui = ui, server = server)
