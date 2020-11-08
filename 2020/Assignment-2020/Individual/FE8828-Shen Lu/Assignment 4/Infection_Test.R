library(conflicted)
library(shiny)
library(tidyverse)
conflict_prefer("filter", "dplyr")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Infection Test"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("rate",
                        "Infection Rate (%):",
                        min = 0,
                        max = 100,
                        value = 5),
            actionButton('go','Go'),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            # 1. Use auto for height/width
            h3(textOutput("Total")),
            plotOutput("TotalMap"),
            h3(textOutput("actualNeg")),
            plotOutput("TrueNeg"),
            h3(textOutput("actualPos")),
            plotOutput("TruePos"),
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$go,{
        InfectRate <- reactive({
            isolate(input$rate)/100
        })
        
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        Affected = round(InfectRate()*500)
        specificity = 0.95
        sensitivity = 0.95
        FalseNeg = round(Affected*(1-sensitivity))
        FalsePos = round((500 - Affected)*(1-specificity))
        df_sensi['color'] <- c(rep('False Neg', FalseNeg),
                                   rep('Actual Pos', Affected - FalseNeg),
                                   rep('False Pos', FalsePos),
                                   rep('Actual Neg', 500 - Affected - FalsePos))
        #Get the negative's map
        TotalNeg = 500 - Affected - FalsePos + FalseNeg
        ActlNeg <- reactive({
            100*(500 - Affected - FalsePos)/TotalNeg
        })
        df_Neg <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:ceiling(TotalNeg/25), color = 'Actual Neg'),
            by = 'color')%>%
            mutate(Color = c(rep('Actual Neg', TotalNeg - FalseNeg),
                             rep('False Neg', FalseNeg),
                             rep("NIL", max(x) * max(y) - TotalNeg)))%>%
            select(-color)%>%rename(color = Color)%>%
            filter(color != "NIL")
        
        #Get the positive's map
        TotalPos = Affected - FalseNeg + FalsePos
        ActPos <- reactive({
            100*(Affected - FalseNeg)/TotalPos
        })
        df_Pos <- full_join(
            tibble(x = 1:25, color = 'Actual Pos'),
            tibble(y = 1:ceiling(TotalPos/25), color = 'Actual Pos'),
            by = 'color')%>%
            mutate(Color = c(rep('Actual Pos', Affected - FalseNeg),
                             rep('False Neg', FalsePos),
                             rep("NIL", max(x) * max(y) - TotalPos)))%>%
            select(-color)%>%rename(color = Color)%>%
            filter(color != "NIL")
        #output the results    
        output$Total <- renderText(paste0("If a test with 95 percent specificity and 95 percent sensitivity
                                          is used in a community of 500 people with a ", 100*InfectRate(),
                                   " percent infection rate, the results look like this:\n\n"))
        
        output$TotalMap <- renderPlot({
            ggplot(df_sensi) +
                geom_point(aes(x, y, col = color),
                           size = 6, shape="circle")+
                theme_bw()+
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())
            
        })
        
        output$actualNeg <- renderText(paste0("\n\nIn this scenario, an individual who tests negative has a ", round(ActlNeg(),1),
                                              " percent chance of actually being negative.\n\n"))
        output$TrueNeg <- renderPlot({
            ggplot(df_Neg) +
                geom_point(aes(x, y, col = color),
                           size = 6, shape="circle")+
                theme_bw() +
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())
            
        })
        
        output$actualPos <- renderText(paste0("\n\nBut an individual who tests positive only has a ",
                                              round(ActPos(), 1), " percent chance of actually being negative.\n\n"))
        output$TruePos <- renderPlot({
            ggplot(df_Pos) +
                geom_point(aes(x, y, col = color),
                           size = 6, shape="circle")+
                theme_bw() +
                theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                      axis.line=element_blank(),axis.text.x=element_blank(),
                      axis.text.y=element_blank(),axis.ticks=element_blank())
            
        })
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
