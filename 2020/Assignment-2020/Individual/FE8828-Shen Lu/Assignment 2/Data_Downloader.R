library(shiny)
library(alphavantager)

ui <- fluidPage(

    # Application title
    titlePanel("Nice Data Downloader"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            textInput("ticker", "Type a US Stock Ticker here:", value = "AAPL"),
            selectInput("freq", "What kind of frequency would you like for your tikcer?", choices = c("Daily" = "DAILY", "Intraday" = "INTRADAY",
                                                                                                      "Daily Adjusted" = "DAILY_ADJUSTED",
                                                                                                      "Weekly" = "WEEKLY",
                                                                                                      "Weekly Adjusted" = "WEEKLY_ADJUSTED",
                                                                                                      "Monthly" = "MONTHLY",
                                                                                                      "Monthly Adjusted" = "MONTHLY_ADJUSTED")),
            tabsetPanel(id = "change",
                        type = "hidden",
                        tabPanel("I",
                                 selectInput("interval", "Time interval you prefer:", choices = c("1min" = "1min", "5min" = "5min", "15min" = "15min",
                                                                                                  "30min" = "30min", "60min" = "60min")),
                                 selectInput("size", "Choose the output size of your data:", choices = c("compact" = "compact", "full" = "full"))
                        ),
                        tabPanel("S",
                                 selectInput("size", "Choose the output size of your data:", choices = c("compact" = "compact", "full" = "full"))
                        ),
                        tabPanel("NIL")),
            actionButton("go", "Go")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("Plot"),
           p(textOutput("error"))
           )
        )
    )

server <- function(input, output, session) {
    switchChoice <- function(){
        freq <- isolate(input$freq)
        if(freq == "INTRADAY" || freq == "DAILY" || freq == "DAILY_ADJUSTED"){
            updateTabsetPanel(session, "change", selected = {
                if(freq == "INTRADAY"){
                    "I"
                }else if(freq == "DAILY" || freq == "DAILY_ADJUSTED"){
                    "S"
                }
            })
        }
        else{
            updateTabsetPanel(session, "change", selected = "NIL")
        }
    }
    observeEvent(input$freq, switchChoice()) 
    
    observeEvent(input$go,
                 {
                     av_api_key("AYQYMDI2Y114CYVB")
                     freq <- isolate(input$freq)
                     ticker <- isolate(input$ticker)
                     tickerData <- tryCatch({
                         if(freq == "INTRADAY"){
                             tickerData <- av_get(ticker, av_fun = paste0("TIME_SERIES_", freq), interval = isolate(input$interval), outputsize = isolate(input$size))
                         }
                         else if(freq == "DAILY" || freq == "DAILY_ADJUSTED"){
                             tickerData <- av_get(ticker, av_fun = paste0("TIME_SERIES_", freq), outputsize = isolate(input$size))
                         }
                         else{
                             tickerData <- av_get(tickeAAPLr, av_fun = paste0("TIME_SERIES_", freq))
                         }
                         tickerData
                     }, error = function(e) {
                         NA
                     })
                     if(is.na(tickerData))
                     {
                         output$error <- renderText(paste0("There is something wrong with your input ", isolate(input$ticker)))
                         output$Plot <- renderPlot({})
                     }
                     else
                     {
                         lower <- tolower(freq)
                         saveRDS(tickerData, file = paste0(isolate(input$ticker), "_", lower, ".rds."))
                         output$Plot <- renderPlot({
                             if(freq == "DAILY" || freq == "INTRADAY" || freq == "WEEKLY" || freq == "MONTHLY"){
                                 plot(x = tickerData$timestamp, y = tickerData$close, xlab = "Date", ylab = paste0(lower," Price"))
                                 lines(tickerData$timestamp, tickerData$close)
                             }
                             else{
                                 plot(x = tickerData$timestamp, y = tickerData$adjusted_close, xlab = "Date", ylab = paste0(lower," Price"))
                                 lines(tickerData$timestamp, tickerData$adjusted_close)
                             }
                         })
                         output$error <- renderText(paste0("Your chosen ticker ", isolate(input$ticker), 
                                                           " has been successfully downloaded to ", isolate(input$ticker), "_", lower, ".rds."))
                     }
                     
                 })
}

# Run the application 
shinyApp(ui = ui, server = server)
