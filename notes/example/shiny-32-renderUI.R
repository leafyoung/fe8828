# shiny-32-renderUI.R

library(shiny)
library(knitr)
library(kableExtra)

ui <- fluidPage(
  numericInput("num", "Num", 3),
  uiOutput("p1"),
  hr(),
  tableOutput("p2")
)

server <- function(input, output, session) {
  observe({
    row_num <- input$num

    output$p1 <- renderUI({
      tagList(
        tags$h1("This is a header"),
        {
          if (row_num > 0 & row_num < 7) {
            hx <- paste0("h", row_num)
            (tags[[hx]])(toupper(hx))
          } else {
            (tags[["h6"]])(toupper("h6"))
          }
        },
        numericInput("num_plot", "Give a number",
          value = round(runif(1, min = 0, max = nrow(iris)), 0),
          min = 0, max = nrow(iris)),
        plotOutput("plot"),
        
        tags$h3("kable can't be used with tagList."),
        kable(iris[1:row_num, , drop = T], format = "html")
      )
    })
    
    # num_plot is the newly created input.
    # plot is the newly created output.
    # You can use the newly created input/output immediately
    # This is particularly useful for creating multiple plots and tables.
    output$plot <- renderPlot({
      if (input$num_plot > 0) {
        ggplot(iris[1:input$num_plot, , drop = F],
               aes(x = Sepal.Length, y = Petal.Width)) +
          geom_point() +
          geom_smooth() +
          theme_minimal()
      }
    })

    # Use anything together with kable, use function() { paste0(...) }
    output$p2 <- function() {
      paste0(
        tags$h1("kable is used inside a function()"),
        kable(iris[1:row_num, , drop = T], format = "html"))
    }
  })
}

shinyApp(ui, server)