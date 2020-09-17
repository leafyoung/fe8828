library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidPage(
        titlePanel("Panel"),
        sidebarLayout(
            position = "right",
            sidebarPanel(
                h1("Introduction to Layout"),
                h2("Sidebar Layout"),
                p("some text as a paragraph"),
                a("A link to Google", href="http://www.google.com"),
                # unordered list
                tags$ul("About",
                    tags$li("Who are we"),
                    tags$li("What we do")
                ),
                # ordered list
                tags$ol("Steps",
                    tags$li("Write"),
                    tags$li("Run")
                ),
                h1("Well 1"),
                wellPanel(
                    h2("Well 1.1"),
                    actionButton("goButton", "Go!")
                )
            ),
            mainPanel(
                img(src = "p19-Hero-Image-796x398.jpg", width = "100%")
            )
        )
    ),
    fluidPage(
        titlePanel("navlistPanel"),
        navlistPanel(
            "Header A",
            tabPanel("Section 1",
                     h1("Section 1"),
                     p("This is section 1. First lecture in FE8828.")),
            tabPanel("Section 2",
                     h1("Section 2")),
            "Header B",
            tabPanel("Section 3",
                     h1("Section 3"))
        )
    ),
    fluidPage(
        titlePanel("tabPanel"),
        tabsetPanel(
            tabPanel("Plot", h1("plot")),
            tabPanel("Summary", h1("summary")),
            tabPanel("Image", img(src = "p19-Hero-Image-796x398.jpg"))
        )
    ),
    fluidPage(
        titlePanel("navbarPage"),
        navbarPage(title = "Runchee Technology",
                   tabPanel("Product",
                            titlePanel("Hello!"),
                            "One more thing!"),
                   tabPanel("About us",
                            titlePanel("Hello!"),
                            "Exordinary people"),
                   navbarMenu(title = "Contact Us",
                              tabPanel("Address", "3/4 platform"),
                              tabPanel("Phone", "+123.456")
                   )
        )
    ),
    fluidPage(
        titlePanel("fluidRow"),
        fluidRow(
            column(4,
                   wellPanel(
                       dateInput("date", "How's weather today?")
                   )
            ),
            column(6, h3("Plot"),
                   wellPanel(plotOutput("distPlot"))
            ),
            column(2, h3("Extra"),
                   wellPanel(plotOutput("extraPlot"))
            )
        )
    ),
    fluidPage(
        title = "Diamonds Explorer",
        fluidRow(
            column(12,
                   img(src = "p19-Hero-Image-796x398.jpg", width = "100%")
            )
        ),
        hr(),
        fluidRow(
            column(3,
                   h4("Diamonds Explorer"),
                   sliderInput('sampleSize', 'Sample Size',
                               min=1, max=nrow(diamonds), value=min(1000, nrow(diamonds)),
                               step=500, round=0),
                   br(),
                   checkboxInput('jitter', 'Jitter'),
                   checkboxInput('smooth', 'Smooth')
            ),
            column(4, offset = 1,
                   selectInput('x', 'X', names(diamonds)),
                   selectInput('y', 'Y', names(diamonds), names(diamonds)[[2]]),
                   selectInput('color', 'Color', c('None', names(diamonds)))
            ),
            column(4,
                   selectInput('facet_row', 'Facet Row', c(None='.', names(diamonds))),
                   selectInput('facet_col', 'Facet Column', c(None='.', names(diamonds)))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
