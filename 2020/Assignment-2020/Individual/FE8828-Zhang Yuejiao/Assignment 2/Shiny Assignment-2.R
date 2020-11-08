library(shiny)
library(alphavantager)


ui <- fluidPage(
  titlePanel("Downloader: Time Series Daily Adjusted"),
  textInput("ticker", "Ticker"),
  actionButton("go", "Download"),
  textOutput("error"),
  textOutput("status"),
  tags$head(tags$style("#error{color: red;
                                 font-size: 15px;
                                 font-style: italic;
                                 }"
      )
  ),
  plotOutput("p1"),
)

server <- function(input, output, session) {
  dowloader <- function(){
    av_api_key("VBA57XNBTQK090XZ")
    df_res <- tryCatch({
      # output size is default to "compact" -> to download recent 100 days
      df_res <- av_get(isolate(input$ticker), av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
      df_res
      
    }, error = function(e) { #Return NA if bad code passed
      NA
    })
    
    if(!is.null(ncol(df_res))){ 
      saveRDS(df_res, paste0("Download_", isolate(input$ticker),".RDS"))
    }
    
    df_res
  }
  
  errorCheck <- reactiveVal(0)
  observeEvent(input$go, {
    output$p1 <- renderPlot({
      df_res <- dowloader()
      name <- isolate(input$ticker)
      if(is.null(ncol(df_res))){ 
        errorCheck(TRUE)
      }else{
        errorCheck(FALSE)
        plot(df_res$timestamp, df_res$adjusted_close, main=paste0("Time Series Daily Adjusted - ",name), 
             xlab="Timestamp", ylab="Adjusted_close",)
        lines(df_res$timestamp, df_res$adjusted_close, main=paste0("Time Series Daily Adjusted - ",name), 
              xlab="Timestamp", ylab="Adjusted_close",)
      }
    })
    
   })
  
  observeEvent(input$go, {
    output$error <- renderText({
      if(errorCheck()){
        e = "Invalid Ticker"
        }else{e = ""}
      e})
    }
  )
  observeEvent(input$go, {
    output$status <- renderText({
      if(errorCheck()){
        s = ""
        }else{s = paste0("Data downloaded as: Download_", isolate(input$ticker),".RDS")
      }
      s})
  }
  )
}


shinyApp(ui,server)