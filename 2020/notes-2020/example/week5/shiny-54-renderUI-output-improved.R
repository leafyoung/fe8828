# shiny-54-renderUI-output-improved.R

library(shiny)

ui <- fluidPage(
  uiOutput("p1")
)

server <- function(input, output, session) {
  output$p1 <- renderUI({
    uiopt <- tagList()
    for (i in 1:3) {
      uiopt <- tagList(
        uiopt,
        h1(paste0("HTML t", i)),
        h1(paste0("Plot p", i)),
        plotOutput(paste0("plot", i)))
    }
    uiopt                     
  })
  
  sds <- 1:3
  sds_i <- 1
  server_env <- environment()
  
  # place the function outside
  plot_one <- function() {
    sds_i <- get('sds_i', envir = server_env)
    hist(rnorm(1000, 0, sds[sds_i] * 100))
    assign('sds_i',sds_i + 1, envir = server_env)
  }
  
  for (i in 1:3) {
    output[[paste0("plot", i)]] <- renderPlot(plot_one())
  }
}

shinyApp(ui, server)

