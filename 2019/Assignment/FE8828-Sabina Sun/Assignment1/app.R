library(shiny)
ui <-    fluidPage(
        navbarPage(title = "Duck Typing",
                   tabPanel("What is it?",
                            img(src = "quote.jpg")                           
                   ),
                   tabPanel("How do we know?",
                            titlePanel("Let's test it!"),
                            checkboxInput("a", "It walks like a duck",),
                            checkboxInput("b", "It quacks like a duck",),
                            actionButton("go", "Test it!"),
                            titlePanel(textOutput("output_id")),
                            uiOutput(outputId = "outputimg")),
                   tabPanel("Find out more",
                            # unordered list
                            tags$ul("Links Below:",
                                   tags$li(a(href="https://en.wikipedia.org/wiki/Duck_typing", "Wikipedia")),
                                   tags$li(a(href="https://devopedia.org/duck-typing", "Devopedia")),
                                   tags$li(a(href="https://www.quora.com/What-is-duck-typing", "Quora")),
                                   tags$li(a(href="https://stackoverflow.com/questions/4205130/what-is-duck-typing", "Stack Overflow"))
                            ),
                            img(src = "ducktype.jpg")
                   
        )
    )
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    inputa<- isolate(input$a)
    inputb<- isolate(input$b)
    if (inputa==T&&inputb==T) {
      output$output_id <-  renderText({"It must be a duck!"})
      output$outputimg <-  renderUI({tags$img(src = "duck.png")})
    }
    else{
      output$output_id <-  renderText({"Hmm.. we are not sure"})
      output$outputimg <-  renderUI({tags$img(src = "hmm.jpg")})
    }
})
}

# Run the application
shinyApp(ui = ui, server = server)