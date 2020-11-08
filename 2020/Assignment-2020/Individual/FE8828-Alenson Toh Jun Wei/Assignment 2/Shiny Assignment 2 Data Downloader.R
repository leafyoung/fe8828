library(shiny)
library(alphavantager)
library(magrittr)
library(dplyr)
library(xts)
library(quantmod)

av_api_key("PU0HA7OMRABN5308")

ui <- fluidPage(
    titlePanel("Stock Data Downloader from Alpha Vantage"),
    sidebarLayout(
        sidebarPanel(width = 2,
                     helpText("This Shiny app allows you to download financial data from Alpha Vantage"),
                     textInput("symbol", "Stock Symbol", placeholder = "Symbol"),
                     dateInput("date_start", "Start Date", value = Sys.Date()-365),
                     dateInput("date_end", "End Date", value = Sys.Date()),
                     selectInput("av_fun", label = "Interval", choices = c("Monthly" = "TIME_SERIES_MONTHLY_ADJUSTED",
                                                                           "Weekly" = "TIME_SERIES_WEEKLY_ADJUSTED",
                                                                           "Daily" = "TIME_SERIES_DAILY_ADJUSTED")),
                     actionButton("b_plot","Plot", icon = icon("chart-line"))
        ),
        
        mainPanel(
            downloadLink("downloadData", "Save Dataset as .RDS"),
            plotOutput("plot")
        )
    )
)

server <- function(input, output) {
    observeEvent(input$b_plot,{
        
        history <- reactive({
            validate(need(input$symbol != "", "Please enter a valid Stock Symbol"))
            av_get(symbol     = input$symbol, 
                   av_fun     = input$av_fun, 
                   outputsize = "full") %>% 
                filter(timestamp < input$date_end,
                       timestamp > input$date_start)
        })
        
        output$plot <- renderPlot({
            
            plot(history()$timestamp, history()$adjusted_close, pch = 19, cex = .5, type = "b",
                 xlab = "Years", ylab = "Adjusted Close",
                 main = paste(input$symbol, "Adjusted Close Values between", input$date_start, "and", input$date_end))
        })
        
        output$downloadData <- downloadHandler(
            validate(need(input$symbol != "", "Please enter a valid Stock Symbol")),
            filename = function() {
                paste("data-", Sys.Date(), ".rds", sep="")
            },
            content = function(file) {
                saveRDS(history(), file)
            })
    })
    
}

shinyApp(ui = ui, server = server)
