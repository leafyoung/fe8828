library(shiny)

d24Page <- fluidPage(
    h3("D24"),
    fluidRow(
        column(6,
               tags$img(src="D24.jpg", width="55%")
        ),
        column(6,
               wellPanel(
               tags$ul(
                   tags$li("Thick and creamy"),
                   tags$li("Ideal for first-timers")
               ),
               p("Current Sale Price: $66"))
        )
    )
)

mswPage <- fluidPage(
    h3("Mao Shan Wang"),
    fluidRow(
        column(6,
               tags$img(src="MSW.jpg", width="90%")
        ),
        column(6,
               wellPanel(
                   tags$ul(
                       tags$li("Bittersweet"),
                       tags$li("Ideal for durian lovers who love surprises")
                   ),
                   p("Current Sale Price: $88"))
        )
    )
)

rpPage <- fluidPage(
    h3("Red Prawn"),
    fluidRow(
        column(6,
               tags$img(src="RP.jpg", width="90%")
        ),
        column(6,
               wellPanel(
                   tags$ul(
                       tags$li("Sweet and milky"),
                       tags$li("Ideal for durian lovers who have sweet tooth")
                   ),
                   p("Current Sale Price: $22"))
        )
    )
)

aboutPage <- fluidPage(tags$img(src="BaoJiak Logo.png"),
                       titlePanel("Hello to All Durian Lovers!"),
                       "We will do our best to deliver the best durians to you, even though almost all the time
                       we don't have them with us. Hey, best things always worth the wait right?")

productsPage <- fluidPage(
    titlePanel("Check Out Our Durians!"),
    navlistPanel(
                tabPanel("D24",
                         d24Page),
                tabPanel("Mao Shan Wang",
                         mswPage),
                tabPanel("Red Prawn",
                         rpPage)
    )
)

orderPage <- fluidPage(
    titlePanel("I Want Durians NOW!"),
    p("Sure, you can order the durians here!"),
    fluidRow(
        column(3,
               wellPanel(
                   h4("Current Stock"),
                   p("D24: ",textOutput("numD24",inline = TRUE)),
                   p("Mao Shan Wang: ",textOutput("numMSW",inline = TRUE)),
                   p("Red Prawn: ",textOutput("numRP",inline = TRUE))
                   )
               ),
        column(4, offset = 1,
               numericInput("userD24", "Number of D24: ", 0, min = 0),
               numericInput("userMSW", "Number of Mao Shan Wang: ", 0, min = 0),
               numericInput("userRP", "Number of Red Prawn: ", 0, min = 0)
               ),
        column(3, offset = 1,
               wellPanel(p("Total cost:"),
                         h3("$",textOutput("totalCost", inline = TRUE)),
                         actionButton("order", "Order"))
               )
        )
)

ui <- fluidPage(
    navbarPage(
        title=div(img(src="BaoJiak Logo.png",
                      style="margin-top:-20px;padding-right:10px;padding-bottom:10px",
                      height=70)),
        tabPanel("Durians", productsPage),
        tabPanel("Order", orderPage),
        navbarMenu(title = "All about Bao Jiak Holdings",
                   tabPanel("About us", aboutPage),
                   tabPanel("Address", fluidPage(h1("Address"),"An imaginary plantation in an imaginary planet.")),
                   tabPanel("Phone", fluidPage(h1("Phone"),"+65 7123 4567"))
                   )
        )
)

# Define server logic required
server <- function(input, output, session) {
    if (file.exists("durianNum.Rds")) {
        print("afdf")
        durianNum <- readRDS(file = "durianNum.Rds")
    } else {
        durianNum <- list("numD24" = 99, "numMSW" = 88, "numRP" = 77)
    }
    values <- reactiveValues("numD24" = durianNum$numD24, "numMSW" = durianNum$numMSW, "numRP" = durianNum$numRP)
    totalCost <- reactiveValues("cost" = 0)
    
    observe(output$numD24 <- renderText({
        if (values$numD24 <= 0) return("Sold Out!")
        values$numD24
    }))
    observe(output$numMSW <- renderText({
        if (values$numMSW <= 0) return("Sold Out!")
        values$numMSW
    }))
    observe(output$numRP <- renderText({
        if (values$numRP <= 0) return("Sold Out!")
        values$numRP
    }))
    observe(output$totalCost <- renderText({
        # Display total cost to the user
        if (is.na(input$userD24) || is.na(input$userMSW) || is.na(input$userRP))
            0
        else
            input$userD24 * 66 + input$userMSW * 88 + input$userRP * 22
    }))
    
    updateNumericInput(session, "userD24", max = isolate(values$numD24))
    updateNumericInput(session, "userMSW", max = isolate(values$numMSW))
    updateNumericInput(session, "userRP", max = isolate(values$numRP))
    
    observeEvent(input$order, {
        if (values$numD24 < input$userD24 || values$numMSW < input$userMSW || values$numRP < input$userRP)
            showNotification("Error, you can't order more durians than what we have!",type="error")
        else if (input$userD24 < 0 || input$userD24 < 0 || input$userD24 < 0) 
            showNotification("Error, you can't give us your durians!",type="error")
        else {
            values$numD24 <- values$numD24 - input$userD24
            values$numMSW <- values$numMSW - input$userMSW
            values$numRP <- values$numRP - input$userRP
            durianNumList <- isolate(reactiveValuesToList(values))
            saveRDS(durianNumList, "durianNum.Rds")
        }
        updateNumericInput(session, "userD24", max = values$numD24, value = 0)
        updateNumericInput(session, "userMSW", max = values$numMSW, value = 0)
        updateNumericInput(session, "userRP", max = values$numRP, value = 0)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
