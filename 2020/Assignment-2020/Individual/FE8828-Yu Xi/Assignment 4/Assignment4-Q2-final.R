
library(conflicted)
library(shiny)
library(DT)
library(ggplot2)
library(dplyr)
conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Coronavirus Antibody Tests"),

    # Sidebar with a slider input
    sidebarLayout(
        sidebarPanel(
            sliderInput("rate",
                        "Infection rate:",
                        min = 1,
                        max = 100,
                        value = 5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
        h4("Infographic of infection rate"),
           plotOutput("dotPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    observeEvent(input$rate,
                
        output$dotPlot<-renderPlot({ 
            a<-input$rate/100
            actualPos<-round(500*a*0.95)
            falseNeg<-round(500*a*0.05)
            falsePos<-round(500*(1-a)*0.05)
            actualNeg<-500-actualPos-falseNeg-falsePos
        
        df_sensi<-full_join(
            tibble(x=1:25,color='Actual Neg'),
            tibble(y=1:20,color='Actual Neg'),
            by = 'color')
        
        df_sensi['color'] <- c(rep('False Neg', falseNeg),
                               rep('Actual Pos', actualPos),
                               rep('False Pos', falsePos),
                               rep('Actual Neg', actualNeg))
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    })
    )
   
    
}

# Run the application 
shinyApp(ui = ui, server = server)
