library(shiny)
library(tidyverse)
library(conflicted)
conflict_prefer("lags", "dplyr")
conflict_prefer("filter", "dplyr")

# Define UI for application that draws an infographic
ui <- fluidPage(

    # Application title
    titlePanel("Infographic Regarding the Covid-19 Test and Infection Rate"),

    # Sidebar with a slider input for Infection Rate 
    sidebarLayout(
        sidebarPanel(
            sliderInput("infectRate",
                        "Infection Rate (%):",
                        min = 0,
                        max = 100,
                        value = 5)
        ),

        # Show the infographic and concluding sentence
        mainPanel(
           uiOutput("infographic")
        )
    )
)

# Define server logic required to draw the infographic
server <- function(input, output, session) {
    infected <- reactiveVal(0)
    infectedNeg <- reactive({round(0.05 * infected())})
    infectedPos <- reactive({infected() - infectedNeg()})
    notInfectedPos <- reactive({round(0.05*(500 - infected()))})
    notInfectedNeg <- reactive({500 - infected() - notInfectedPos()})
    
    observeEvent(input$infectRate, infected(500 / 100 * input$infectRate))
    
    output$infographic <- renderUI({
        tagList(
            plotOutput("fullChart",height='auto',width='auto'),
            p(HTML(paste0("An individual who tests negative has a <b>",
                    format(notInfectedNeg()/(notInfectedNeg()+infectedNeg()) * 100, digits = 2, nsmall = 1),
                    " percent</b> chance of actually being negative."))),
            plotOutput("negChart",height='auto',width='auto'),
            p(HTML(paste0("An individual who tests positive has a <b>",
                          format(infectedPos()/(notInfectedPos()+infectedPos()) * 100, digits = 2, nsmall = 1),
                          " percent</b> chance of actually being positive."))),
            plotOutput("posChart",height='auto',width='auto'),
        )
    })
    
    output$fullChart <- renderPlot({
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'Actual Neg'),
            tibble(y = 1:20, color = 'Actual Neg'),
            by = 'color')
        # At 5% infection rate,
        # Positive 500 * 5% = 25 = Actual Pos (24 at 95%) + False Neg (1 at 5%)
        # Negative 500 * 95% = 475 = Actual Neg (451 at 95%) + False Pos (24 at 5%)
        df_sensi['color'] <- c(rep('False Neg', infectedNeg()),
                               rep('Actual Pos', infectedPos()),
                               rep('False Pos', notInfectedPos()),
                               rep('Actual Neg', notInfectedNeg()))
        cols <- c("False Neg" = "darkred", "Actual Pos" = "red", "False Pos" = "green", "Actual Neg" = "grey")
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            scale_colour_manual(values = cols) +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }, width=500, height=250)
    
    output$negChart <- renderPlot({
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'NA'),
            tibble(y = 1:20, color = 'NA'),
            by = 'color')
        df_sensi['color'] <- c(rep('False Neg', infectedNeg()),
                               rep('Actual Neg', notInfectedNeg()),
                               rep('NA', 500 - infectedNeg() - notInfectedNeg()))
        cols <- c("False Neg" = "darkred", "Actual Neg" = "grey", "NA" = "NA")
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            scale_colour_manual(values = cols, breaks = c("False Neg", "Actual Neg")) +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }, width=500, height=250)
    
    output$posChart <- renderPlot({
        df_sensi <- full_join(
            tibble(x = 1:25, color = 'NA'),
            tibble(y = 1:20, color = 'NA'),
            by = 'color')
        df_sensi['color'] <- c(rep('Actual Pos', infectedPos()),
                               rep('False Pos', notInfectedPos()),
                               rep('NA', 500 - infectedPos() - notInfectedPos()))
        cols <- c("Actual Pos" = "red", "False Pos" = "green", "NA" = "NA")
        ggplot(df_sensi) +
            geom_point(aes(x, y,colour = color),
                       size = 4, shape="circle") +
            scale_colour_manual(values = cols, breaks = c("Actual Pos", "False Pos")) +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank())
    }, width=500, height=250)
}

# Run the application 
shinyApp(ui = ui, server = server)
