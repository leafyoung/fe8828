library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
    titlePanel("Mathematical Pitfall on Coronavirus Antibody Tests"),
    
    sidebarLayout(
        sidebarPanel(width = 3,
            "With any test that is not 100 percent accurate, there are four possible outcomes for each individual",
            tags$ol(
                tags$li("You are positive and test positive"), 
                tags$li("You are negative and test negative"), 
                tags$li("You are positive but test negative"),
                tags$li("You are negative but test positive")
            ),
            "A test with a low rate of false positives has a high specificity. A test with a low rate of false negatives",
            "has a high specificity.",
            hr(),
            "If a test has 95 percent specificity and 95 percent sensitivity, that means it correctly identifies 95 percent",
            "of people who are positive and 95 percent of those who are negative. Even with very effective screening tests",
            ", depending on the infection rate in the population, an individusal's test result may not be reliable."
        ),
        mainPanel(
            "If a test with 95 percent specificity and 95 percent sensitivity is used in community of 500 people with a",
            "5 percent infection rate, the results look like this:",
            plotOutput("plot_1", width = "600px"),
            "In this scenerio, an individual who tests negative has a 99.8 percent chance of actually being negative.",
            plotOutput("plot_2", width = "600px"),
            "But an individual who tests positive only has a 50 percent chance of actually being positive.",
            plotOutput("plot_3", width = "600px", height = "100px"),
            hr(),
            "If an equally accurate test is used in a community of 500 people with a 25 percent infection rate",
            ", the results look like this:",
            plotOutput("plot_4", width = "600px"),
            "In this scenerio, an individual who tests negative has a 98.3 percent chance of actually being negative",
            plotOutput("plot_5", width = "600px", height = "400px"),
            "And an individual who tests positive has an 86 percent chance of actually being positive.",
            plotOutput("plot_6", width = "600px", height = "170px"),
        )
        
    )
)

server <- function(input, output) {
    n = 500
    infection_rate = 0.05
    positive = n * infection_rate
    false_negative = round(positive * 0.05)
    
    negative = n * (1-infection_rate)
    false_positive = round(negative * 0.05)
    
    output$plot_1 <- renderPlot({
        data.frame(
            color = c(
                rep("False Negative", false_negative),
                rep("True Positive", positive-false_negative),
                rep("False Positive", false_positive),
                rep("True Negative", negative-false_positive)
            ),
            y = rep((1:20), 25) %>% sort(decreasing = T),
            x = 1:25
        ) %>% 
            mutate(color = factor(color, levels = c("False Negative", "True Positive",
                                                    "False Positive", "True Negative")))  %>% 
            ggplot() +
            geom_point(aes(x, y, color = color), size = 8) +
            theme_void() +
            labs(color = "Type") +
            scale_color_manual(values = c("#CC9664","#AC0451","#238C8D","gray"))
        })
    
    output$plot_2 <- renderPlot({
        data.frame(
            color = c(
                rep("True Negative", negative-false_positive),
                rep("False Negative", false_negative),
                rep("Blank", n-false_negative-negative+false_positive)
            ),
            y = rep((1:20), 25) %>% sort(decreasing = T),
            x = 1:25
        ) %>% 
            mutate(color = factor(color, levels = c("True Negative","False Negative", "Blank")))  %>% 
            filter(color != "Blank") %>% 
            ggplot() +
            geom_point(aes(x, y, color = color), size = 8) +
            theme_void() +
            labs(color = "Type") +
            scale_color_manual(values = c("gray","#AC0451"))
    })
    
    output$plot_3 <- renderPlot({
        data.frame(
            color = c(
                rep("True Positive", positive-false_negative),
                rep("False Positive", false_positive)
            ),
            y = rep((1:2), 24) %>% sort(decreasing = T),
            x = 1:24
        ) %>% 
            mutate(color = factor(color, levels = c("True Positive","False Positive", "Blank")))  %>% 
            #filter(color != "Blank") %>% 
            ggplot() +
            geom_point(aes(x, y, color = color), size = 8) +
            theme_void() +
            ylim(0,3) + 
            labs(color = "Type") +
            scale_color_manual(values = c("gray","#AC0451","white"))
    })
    
    output$plot_4 <- renderPlot({
        n = 500
        infection_rate = 0.25
        positive = n * infection_rate
        false_negative = round(positive * 0.05)
        
        negative = n * (1-infection_rate)
        false_positive = round(negative * 0.05)
        
        data.frame(
            color = c(
                rep("False Negative", false_negative),
                rep("True Positive", positive-false_negative),
                rep("False Positive", false_positive),
                rep("True Negative", negative-false_positive)
            ),
            y = rep((1:20), 25) %>% sort(decreasing = T),
            x = 1:25
        ) %>% 
            mutate(color = factor(color, levels = c("False Negative", "True Positive",
                                                    "False Positive", "True Negative")))  %>% 
            ggplot() +
            geom_point(aes(x, y, color = color), size = 8) +
            theme_void() +
            labs(color = "Type") +
            scale_color_manual(values = c("#CC9664","#AC0451","#238C8D","gray"))
    })
    
    output$plot_5 <- renderPlot({
        n = 500
        infection_rate = 0.25
        positive = n * infection_rate
        false_negative = round(positive * 0.05)
        
        negative = n * (1-infection_rate)
        false_positive = round(negative * 0.05)
        
        data.frame(
            color = c(
                rep("True Negative", negative-false_positive),
                rep("False Negative", false_negative),
                rep("Blank", n-false_negative-negative+false_positive)
            ),
            y = rep((1:20), 25) %>% sort(decreasing = T),
            x = 1:25
        ) %>% 
            mutate(color = factor(color, levels = c("True Negative","False Negative", "Blank")))  %>% 
            filter(color != "Blank") %>% 
            ggplot() +
            geom_point(aes(x, y, color = color), size = 8) +
            theme_void() +
            labs(color = "Type") +
            scale_color_manual(values = c("gray","#AC0451"))
        
    })
    
    output$plot_6 <- renderPlot({
        n = 500
        infection_rate = 0.25
        positive = n * infection_rate
        false_negative = round(positive * 0.05)
        
        negative = n * (1-infection_rate)
        false_positive = round(negative * 0.05)
        
        data.frame(
            color = c(
                rep("True Positive", positive-false_negative),
                rep("False Positive", false_positive),
                rep("Blank", n-positive-false_positive+false_negative)
            ),
            y = rep((1:20), 25) %>% sort(decreasing = T),
            x = 1:25
        ) %>% 
            mutate(color = factor(color, levels = c("True Positive","False Positive", "Blank")))  %>% 
            filter(color != "Blank") %>% 
            ggplot() +
            geom_point(aes(x, y, color = color), size = 8) +
            theme_void() +
            labs(color = "Type") +
            scale_color_manual(values = c("gray","#AC0451","white"))
    })
}

shinyApp(ui = ui, server = server)
