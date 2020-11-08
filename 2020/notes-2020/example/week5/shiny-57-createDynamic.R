# shiny-57-createDynamic.R

library(shiny)

ui <- fluidPage(
  uiOutput("p1"),
  verbatimTextOutput("o1")
)

server <- function(input, output, session) {
  baseList <- tagList(
    numericInput("shock", "Shock", value = round(runif(1) * 1000), 0),
    actionButton("add", "Add")
  )

  scenarios <- c(-100, -50, 0, 50, 100)
  tagl <- NA
  this_env <- environment()
  gen_ui <- function(scenarios, values = NA) {
    output$p1 <- renderUI({
      assign('tagl',baseList,envir = this_env) # Use t1 here so we can 
      for (ss in 1:length(scenarios)) {
        nm <- paste0("scenarios_", ss)
        if (is.na(values[ss])) {
          val <- TRUE 
        } else {
          val <- values[ss]
        }
        # we are creating a list of checkboxInput in ui
        tagl <- tagList(tagl, checkboxInput(nm, scenarios[ss], value = val))
        # print(paste0("scenarios_", ss, ", ", scenarios[ss], "\n"))
      }
      tagl
    })
  }

  gen_ui(scenarios)

  observeEvent(input$add, {
    shock <- isolate(input$shock)
    if (!(shock %in% scenarios)) {
      vals <- purrr::map_lgl(1:length(scenarios),
                       function(ss) {
                         isolate(input[[paste0("scenarios_", ss)]])
                       })
      assign('scenarios',c(scenarios, shock),envir=this_env)
      gen_ui(scenarios, vals)
    }

    # Change to a new random value
    updateNumericInput(session, "shock", value = round(runif(1) * 1000))
  })
  
  output$o1 <- renderPrint({
    print(names(input))
    print(isolate(input[["scenarios_1"]]))
    x <- purrr::keep(1:length(scenarios),
                     function(ss) {
                       isolate(input[[paste0("scenarios_", ss)]])
                      })
    x <- scenarios[x]
    str(x)
    cat(paste0("length: ", length(x), "\n"))
    cat(paste0(x, "\n"))
  })
}

shinyApp(ui, server)

