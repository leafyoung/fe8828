library(shiny)
library(ggplot2)
library(dplyr)
# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("False Positive Alarm"),
    sidebarLayout(
        position = "left",
        sidebarPanel(numericInput("specificity", "Percent Specificity", value = 0.95),
        numericInput("sensitivity", "Percent Sensitivity", value = 0.95),
        actionButton("go", "Go")),
    mainPanel(
        textOutput("p1"),
        plotOutput("plot"),
        textOutput("p2"),
        plotOutput('plot2'),
        textOutput("p3"),
        plotOutput("plot3")
    )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observeEvent(input$go,
               {
                 specificity <- input$specificity
                 sensitivity <- input$sensitivity
                 
                 # At 5% infection rate
                 Affected <- floor(500*0.05)
                 falseNeg <- floor(Affected*(1-sensitivity))
                 falsePos <- ceiling((500-Affected)*(1-specificity))
                 
                 
                 df_sensi <- full_join(
                   tibble(x = 1:25, color = 'Actual Neg'),
                   tibble(y = 1:20, color = 'Actual Neg'),
                   by = 'color') %>%
                   mutate(color = c(rep('False Neg', falseNeg),
                                    rep('Actual Pos', Affected - falseNeg),
                                    rep('False Pos', falsePos),
                                    rep('Actual Neg', 500-Affected-falsePos)))
                 
  output$p1 <- renderText({
      HTML("If a test with", input$specificity, " percent specificity and",
             input$sensitivity, " percent sensitivity is used in a community of 
             500 people with a percent with a 5 percent rate, 
             the results look like this:")
  })
  
  
  output$plot <- renderPlot({
      ggplot(df_sensi) +
          geom_point(aes(x, y,colour = color),
                     size = 4, shape="circle") +
          theme_bw() +
          theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                axis.line=element_blank(),axis.text.x=element_blank(),
                axis.text.y=element_blank(),axis.ticks=element_blank())
  })

  
  # Get the negative map
  TotalNeg = 500 -  Affected - falsePos + falseNeg
  ActlNeg <- 100*(500 - Affected - falsePos)/TotalNeg
  
  df_neg <- full_join(
    tibble(x = 1:25, color = "Actual Neg"),
    tibble(y = 1:ceiling(TotalNeg/25), color = "Actual Neg"),
    by = 'color') %>%
    mutate(Color = c(rep('Actual Neg', TotalNeg-falseNeg),
                     rep("False Neg", falseNeg),
                     rep("NIL", max(x)*max(y)-TotalNeg))) %>%
    select(-color) %>% rename(color = Color) %>%
    filter(color !="NIL")
  
  output$p2 <- renderText({
    paste0("In this scenario, an individual who tests negative has a ", ActlNeg," chance
    of actually being negative.")
  })
  
  output$plot2 <- renderPlot({
    ggplot(df_neg) +
      geom_point(aes(x, y,colour = color),
                 size = 4, shape="circle") +
      theme_bw() +
      theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
            axis.line=element_blank(),axis.text.x=element_blank(),
            axis.text.y=element_blank(),axis.ticks=element_blank())
  })

  # get the positive map
  TotalPos <- Affected - falseNeg + falsePos
  ActPos <- 100*(Affected - falseNeg)/TotalPos

  
  df_pos <- full_join(
    tibble(x = 1:25, color = 'Actual Pos'),
    tibble(y = 1:ceiling(TotalPos/25), color = 'Actual Pos'),
    by = 'color') %>%
    mutate(color = c(rep("Actual Pos", Affected-falseNeg),
                     rep("False Pos", falsePos),
                     rep("NIL", max(x)*max(y)-TotalPos))) ##%>%
    ##select(-color)%>%rename(color = Color) %>%
   ## filter(color != "NIL")
  
  output$p3 <- renderText({
    paste0("\n\nBut an individual who tests positive has a ", ActPos,
           " percent chance of actually being positive.\n\n")
  })
  
  output$plot3 <- renderPlot({
    ggplot(df_pos) +
      geom_point(aes(x, y,colour = color),
                 size = 4, shape="circle") +
      theme_bw() +
      theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
            axis.line=element_blank(),axis.text.x=element_blank(),
            axis.text.y=element_blank(),axis.ticks=element_blank())
  })
  
               })
}

# Run the application 
shinyApp(ui = ui, server = server)
