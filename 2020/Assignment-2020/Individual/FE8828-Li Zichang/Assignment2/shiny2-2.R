
library(shiny)
library(alphavantager)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    titlePanel("Get Data"),

    textInput("Key", "Your Key:", " "),
    textInput("Code", "Code", "MSFT"),
    actionButton("go", "Go"),
    plotOutput("p1", "400px", "400px"),
    plotOutput("p2", "400px", "400px")
    
)

server <- function(input, output, session) {
    
    # Below code can return NA if bad code is passed. 
    df_res <- eventReactive(input$go,{
        av_api_key(input$Key)
        tryCatch({ 
            df_res <- av_get(input$Code, av_fun = "TIME_SERIES_DAILY_ADJUSTED") 
            print(df_res)
            if(is.na(df_res)) {
                "Error!Try agian"
            } else {
                df_res
            }
            },
            error = function(e) { 
                NA 
        })

        #if (is.na(df_res) == FALSE)
    })
    
    # When put in interactive environment (Shiny), don't know how to deal with the plot problem...    
    # plots 
    output$p1 <- renderPlot({ plot(df_res()$timestamp, df_res()$adjusted_close) })
    output$p2 <- renderPlot({ lines(df_res()$timestamp, df_res()$adjusted_close) })
}

# Run the application 
shinyApp(ui = ui, server = server)

