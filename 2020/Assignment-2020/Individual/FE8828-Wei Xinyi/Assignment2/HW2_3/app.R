#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
  textInput("stock", "stock", "AMZN"),
  actionButton("go", "Go"),
  plotOutput("p1")
)


server <- function(input, output, session) {
  observeEvent(input$go,{
    output$p1 <- renderPlot({
    df_res <- av_get(input$stock,av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
    
    plot(df_res$timestamp, df_res$adjusted_close) 
    lines(df_res$timestamp, df_res$adjusted_close)
    
    })    
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

