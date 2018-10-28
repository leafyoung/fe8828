# shiny-51-quandl.R

library(shiny)

library(tidyverse) 
library(Quandl)
library(xts)
library(dygraphs)

goldChoice <- "CHRIS/CME_GC1.1" # gold data from CME

dataChoices <- c("WTI oil" = "FRED/DCOILWTICO", #oil data from Fred
                 "Copper" = "ODA/PCOPP_USD", # copper data from ODA
                 "Gold" = "CHRIS/CME_GC1.1",
                 "Silver" = "LBMA/SILVER.1",
                 "Copper" = "CHRIS/CME_HG1.1",
                 "Iron Ore" = "ODA/PIORECR_USD",
                 "Platinum" = "LPPM/PLAT.1",
                 "Palladium" = "LPPM/PALL.1",
                 "Bitcoin" = "BCHARTS/WEXUSD.1")

frequencyChoices <- c("days" = "daily",
                      "weeks" = "weekly", 
                      "months" = "monthly")

ui <- fluidPage(
  titlePanel("Commodity"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("dataSet",
                  "Commodity",
                  choices = dataChoices, #Freddie mac
                  selected = "WTI oil"),
      
      selectInput("frequency",
                  "freq",
                  choices = frequencyChoices, 
                  selected = "months"),

      dateRangeInput("dateRange",
                     "Date range",
                     start = "1980-01-01",
                     end   = Sys.Date())
    ),
    mainPanel(
      dygraphOutput("commodity"),
      dygraphOutput("commodity_gold")
    )
  )
)

server <- function(input, output, session) {
  Quandl.api_key("d9EidiiDWoFESfdk5nPy")
  
  gold <- reactive({
    gold <- Quandl(goldChoice,
                   start_date = format(input$dateRange[1]),
                   end_date = format(input$dateRange[2]),
                   order = "asc",
                   type = "xts",
                   collapse = as.character(input$frequency)
    )
  })  
  
  commodity <- reactive({
    commodity <- Quandl(input$dataSet,
                        start_date = format(input$dateRange[1]),
                        end_date = format(input$dateRange[2]),
                        order = "asc",
                        type = "xts",
                        collapse = as.character(input$frequency)
    )
  })
  
  output$commodity <- renderDygraph({
    dd <- merge(gold(), commodity())
    dd$ratio <- dd[,1]/dd[,2]
    dd <- dd[, -1, drop = F]
    colnames(dd) <- c(names(dataChoices)[dataChoices == isolate(input$dataSet)],
                      "Gold ratio")
    
    dygraph(dd, 
            main = paste("Price history of", names(dataChoices[dataChoices==input$dataSet]), 
                         sep = " "),
            group = "gold group") %>%
      dyAxis("y", label = "$") %>%
      dySeries("Gold ratio", axis = 'y2') %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE,
                colors = RColorBrewer::brewer.pal(3, "Set1")) %>%
      dyRangeSelector()
  })
  
  output$commodity_gold <- renderDygraph({
    dygraph(gold(), 
            main = paste0("Ratio history of ", names(dataChoices[dataChoices==input$dataSet]), "/Gold"),
            group = "gold group") %>%
      dyAxis("y", label = "$") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE) %>%
      dyRangeSelector()
  })
}

shinyApp(ui, server)

