# Assignment 4 Part 2
# WU Hongsheng
# G2000655A

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- pageWithSidebar(
    headerPanel("Test Result & Actual Result"),
    sidebarPanel(
        sliderInput("samples",
                    label = "samples:",
                    min = 500,
                    max = 1000,
                    step = 100,
                    value = 500),
        hr(),
        sliderInput("infectionrate",
                    label = "infection rate:",
                    min = 0,
                    max = 1,
                    step = 0.01,
                    value = 0.05),
        hr(),
        sliderInput("specificity",
                    label = "specificity:",
                    min = 0,
                    max = 1,
                    step = 0.05,
                    value = 0.95),
        hr(),
        sliderInput("sensitivity",
                    label = "sensitivity:",
                    min = 0,
                    max = 1,
                    step = 0.05,
                    value = 0.95),
        hr(),
        sliderInput("pic_wid",
                    label = "circles in a row:",
                    min = 20,
                    max = 50,
                    step = 5,
                    value = 25),
    ),
    mainPanel(
        h3("Overall Result"),
        textOutput("text_a"),
        plotOutput("a",height='auto',width='auto'),
        
        h3("Negative Result"),
        textOutput("text_b"),
        plotOutput("b",height='auto',width='auto'),
        
        h3("Positive Result"),
        textOutput("text_c"),
        plotOutput("c",height='auto',width='auto')
    )
)
   
# Define server logic required to draw a histogram
server <- function(input, output, session) {
   
    alldata <- reactive({
        alldatas <- list()
        
        samples <- input$samples
        pic_wid <- input$pic_wid
        pic_len <- ceiling(samples/pic_wid)
        infectionrate <- input$infectionrate
        Positive <- samples * infectionrate
        Negative <- samples * (1-infectionrate)
        
        specificity <- input$specificity
        ActualNegative <- round(Negative * specificity)
        FalsePositive <- Negative - ActualNegative
        
        sensitivity <- input$sensitivity
        ActualPositive <- round(Positive * sensitivity)
        FalseNegative <- Positive - ActualPositive
        
        predictresult <- data.frame(id = 1:samples) %>%
            mutate(Actual = c(rep("Pos", Positive),
                              rep("Neg", Negative)),
                   prediction = c(rep("Pos", ActualPositive),
                                  rep("Neg", FalseNegative),
                                  rep("Pos", FalsePositive),
                                  rep("Neg", ActualNegative)),
                   color = c(rep("ActualPositive", ActualPositive),
                             rep("FalseNegative", FalseNegative),
                             rep("FalsePositive", FalsePositive),
                             rep("ActualNegative", ActualNegative)),
                   x = rep_len(1:pic_wid, samples),
                   y = rep(1:pic_len, each=pic_wid, length.out=samples))
        
        predictnegativeN <- FalseNegative + ActualNegative
        pic_len2 <- ceiling(predictnegativeN / pic_wid)
        predictnegative <- predictresult %>%
            filter(prediction == "Neg") %>%
            mutate(x = rep_len(1:pic_wid, predictnegativeN),
                   y = rep(1:pic_len2, 
                           each = pic_wid, 
                           length.out = predictnegativeN))
        
        predictpositiveN <- ActualPositive + FalsePositive
        pic_len3 <- ceiling(predictpositiveN / pic_wid)
        predictpositive <- predictresult %>%
            filter(prediction == "Pos") %>%
            mutate(x = rep_len(1:pic_wid, predictpositiveN),
                   y = rep(1:pic_len3, 
                           each = pic_wid, 
                           length.out = predictpositiveN))
        
        alldatas[[1]] <- predictresult
        alldatas[[2]] <- predictnegative
        alldatas[[3]] <- predictpositive
        
        
        predictnegativeresult <- predictnegative %>%
            group_by(Actual) %>%
            summarise(N = n()/(FalseNegative+ActualNegative))
        
        alldatas[[4]] <- round(as.numeric(predictnegativeresult[1,2]),4)
        
        
        predictpositiveresult <- predictpositive %>%
            group_by(Actual) %>%
            summarise(N = n()/predictpositiveN)
        
        alldatas[[5]] <- round(as.numeric(predictpositiveresult[2,2]),4)
        
        print(alldatas)
        return(alldatas)
    })
    
    output$text_a <- renderText({
        paste("If a test with",
              input$specificity*100, 
              "percent specificity and",
              input$sensitivity*100,
              "percent sensityvity is used in a community of",
              input$samples,
              "people with a",
              input$infectionrate*100,
              " percent infection rate, the results look like this:", 
              sep = " ")
    })
    
    output$a <- renderPlot({
        ggplot(alldata()[[1]]) +
            geom_point(aes(x, y,colour = color),
                       size = 5, shape="circle") +
            scale_color_manual(values = c("green", "red", "orange", "blue")) +
            labs(colour = "") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank(),
                  legend.position = "bottom")
    }, width = 500, height = 500)
    
    output$text_b <- renderText({
        paste("In this scenario, an individual who tests negative has a",
              alldata()[[4]]*100, 
              "percent chance of actually being negative.", 
              sep = " ")
    })
    
    output$b <- renderPlot({
        ggplot(alldata()[[2]]) +
            geom_point(aes(x, y,colour = color),
                       size = 5, shape="circle") +
            scale_color_manual(values = c("green", "orange")) +
            labs(colour = "") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank(),
                  legend.position = "bottom")
    }, width = 500, height = 500)
    
    output$text_c <- renderText({
        paste("But an individual who tests positive only has a",
              alldata()[[5]]*100, 
              "percent chance of actually being positive.", 
              sep = " ")
    })
    
    output$c <- renderPlot({
        ggplot(alldata()[[3]]) +
            geom_point(aes(x, y,colour = color),
                       size = 5, shape="circle") +
            scale_color_manual(values = c("red", "blue")) +
            labs(colour = "") +
            theme_bw() +
            theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
                  axis.line=element_blank(),axis.text.x=element_blank(),
                  axis.text.y=element_blank(),axis.ticks=element_blank(),
                  legend.position = "bottom")
    }, width = 500, height = 300)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
