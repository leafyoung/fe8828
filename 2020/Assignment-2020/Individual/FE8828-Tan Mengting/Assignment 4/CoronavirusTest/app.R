library(shiny)
library(DT)
library(lubridate)
library(tidyverse)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

    titlePanel("False Positive Alarm"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("infection_rate", "Infection Rate: ",
                        1:100),
            actionButton("go", "Go")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("Info Graphic"),
            
            htmlOutput("info1"),
            plotOutput("infographic1"),
            
            htmlOutput("info2"),
            plotOutput("infographic2"),
            
            htmlOutput("info3"),
            plotOutput("infographic3")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    reactive <- eventReactive(input$go, {
        infection_rate <- as.numeric(input$infection_rate)
        
        Positive <- round(500 * infection_rate / 100)
        Actual_Pos <- round(Positive * 0.95)
        False_Neg <- Positive - Actual_Pos
        
        Negative <- 500 - Positive
        Actual_Neg <- round(Negative * 0.95)
        False_Pos <- Negative - Actual_Neg
        
        Negtive_Rate = round((100-(False_Neg/(Negative-False_Pos))*100),1)
        Positive_Rate = round( Actual_Pos /(Actual_Pos + False_Pos)*100,1)
        
        df <- data.frame("infection_rate" = infection_rate,
                         
                         "Positive" = Positive,
                         "Actual_Pos" = Actual_Pos,
                         "False_Neg" = False_Neg,
                         
                         "Negative" = Negative,
                         "Actual_Neg" = Actual_Neg,
                         "False_Pos" = False_Pos,
                         
                         "Negative_Rate" = Negtive_Rate,
                         "Positive_Rate" = Positive_Rate)
        return(df)
    })
        
    output$info1 <- renderText({
        df <- reactive()
        HTML(paste("If a test with",
                   "<strong> 95 percent specificity</strong>",
                   "and",
                   "<strong> 95 percent sensitivity</strong>" ,
                   " is used in a community of <strong> 500 people</strong>, with a ",
                   "<strong> ",df['infection_rate'], "</strong>",
                   "<strong>  percent infection rate </strong>",
                   ", the result looks like: "))   
    })  
    
    output$infographic1 <- renderPlot({
        df <- reactive()
        infection_rate <- as.numeric(df['infection_rate'])
        
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        
        df_sensi['color'] <- c(rep('False Neg', as.numeric(df['False_Neg'])),
                               rep('Actual Pos', as.numeric(df['Actual_Pos'])),
                               rep('False Pos', as.numeric(df['False_Pos'])),
                               rep('Actual Neg', as.numeric(df['Actual_Neg'])))
        
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }) 
        
    output$info2 <- renderUI({
        df <- reactive()
        HTML(paste("In this scenerio, an individual who tests negative has a ",
                   "<strong>", df['Negative_Rate'], "percent </strong>",
                   "chance of actually being negative."))
    })
    
    output$infographic2 <- renderPlot({
        df <- reactive()
        count <- as.numeric(df['Actual_Neg'] + df['False_Neg'])
        infection_rate <- as.numeric(df['infection_rate'])
       
        df_sensi <- full_join(
                tibble(x = 1:25, color = 'Actual Neg'),
                tibble(y = 1:20, color = 'Actual Neg'),
                by = 'color')
        
        df_sensi['color'] <- c(rep('Actual Neg', as.numeric(df['Actual_Neg'])),
                               rep('False Neg', as.numeric(df['False_Neg'])),
                               rep('Others', as.numeric(df['Actual_Pos']+df['False_Pos'])))
        
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }) 
    
    output$info3 <- renderUI({
        df <- reactive()
        HTML(paste("But an individual who tests positive has a ",
                   "<strong>", df['Positive_Rate'], "percent </strong>",
                   "chance of actually being positive."))
    })
    
    output$infographic3 <- renderPlot({
        df <- reactive()
        infection_rate <- as.numeric(df['infection_rate'])
        
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        
        df_sensi['color'] <- c(rep('Actual Pos', as.numeric(df['Actual_Pos'])),
                               rep('False Pos', as.numeric(df['False_Pos'])),
                               rep('Others', as.numeric(df['Actual_Neg']+df['False_Neg'])))
        
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }) 
}
# Run the application 
shinyApp(ui = ui, server = server)
