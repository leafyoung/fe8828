library(shiny)
library(readr)
library(DT)
library(plotly)
TSLA <- read_csv("TSLA.csv")

ui <- fluidPage(
    fluidPage(
        navbarPage(title = "XXZPEDIA",
            tabPanel("main page",
                     h2("Welcome to Xxz's Pedia! :)"),
                     fluidRow(
                         column(6,
                                wellPanel(h4("From today's featured article"),
                                          tags$p("Jomo Kenyatta (c.1897 – 1978) was an anti-colonial activist and politician who governed Kenya as its prime minister from 1963 to 1964 and then as its first president from 1964 to his death in 1978. He was the country's first indigenous head of government and played a significant role in the transformation of Kenya from a colony of the British Empire into an independent republic. In 1947, he began lobbying for independence from British colonial rule through the Kenya African Union, attracting widespread indigenous support. In 1952, he was among the Kapenguria Six arrested and charged with masterminding the anti-colonial Mau Mau Uprising. Although protesting his innocence—a view shared by later historians—he was convicted. Upon his release in 1961, he led the Kenya African National Union party until his death. During his presidency, he secured support from both the black majority and white minority with his message of reconciliation.")
                                )),
                         column(6,
                                wellPanel(h4("Today's featured picture-Autumn"),
                                          tags$p("Autumn is one of the four temperate seasons, marking the transition from summer to winter. In North America, where it is known as fall, the season traditionally starts on the September equinox (21 to 24 September) and ends on the winter solstice (21 or 22 December). Meteorologists in the Northern Hemisphere use a definition based on Gregorian calendar months, with autumn being September, October, and November. In Southern Hemisphere countries such as Australia and New Zealand, which also base their seasonal calendars meteorologically rather than astronomically, autumn officially begins on 1 March and ends on 31 May.
This photograph shows a typical autumnal scene in Dülmen, Germany, with the shedding of yellow, orange and red leaves by deciduous trees in temperate climates. The September equinox falls at 13:31 UTC on 22 September in 2020.")
                                ))
                     ),
                     img(src = "nice.png",align = "right")
                     ),
            tabPanel("My favourite stock",
                     h4("Tesla, Inc. (TSLA)"),
                     h6("NasdaqGS - NasdaqGS Real Time Price. Currency in USD"),
                     fluidRow(
                         column(12,plotlyOutput("line_chart")),
                         column(12,dataTableOutput("table"))
                     )),
            tabPanel("About Covid19",
                     navlistPanel(
                         "Menu",
                         tabPanel("Overview", 
                                  tags$ul(tags$li(a(h4("Worldwide COVID-19 Dashboard"),href="https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6")),  
                                          tags$li(h4("Singapore Dashboard")),
                                          img(src = "Cov_sg.png",height='450px',width='720px')
                                            )),
                         tabPanel("Statistics",
                                  img(src = "new.png",height='350px',width='560px'),
                                  fluidRow(
                                      column(
                                      12,wellPanel(h4("About this data"),
                                                      tags$p("It changes rapidly.This data changes rapidly and might not reflect some cases still being reported.
It includes confirmed and probable cases.Total counts include both confirmed and probable cases in some locations. Probable cases are identified by public health officials and use criteria developed by government authorities. Some areas may not have data because they haven’t published their data or haven’t done so recently.
Why do I see different data from different sources?There are various sources that are tracking and aggregating coronavirus data. They update at different times and may have different ways of gathering data.")
                                  )))
                                  
                         ),
                         tabPanel("Health Info", 
                                  tags$ul(h4("Symptoms may appear 2-14 days after exposure to the virus. People with these symptoms may have COVID-19:"),
                                      tags$li("Fever or chills"),
                                      tags$li("Cough"),
                                      tags$li("Shortness of breath or difficulty breathing"),
                                      tags$li("Fatigue"),
                                      tags$li("Muscle or body aches")
                                  )
                         ),
                         tabPanel("News", 
                                  tags$ul(
                                          tags$li(a(h4("EU News"),href = "https://ec.europa.eu/commission/presscorner/detail/en/IP_20_1709" )),
                                          tags$li(a(h4("BBC News"),href = "https://www.bbc.com/news/uk-54232126" )),
                                          tags$li(a(h4("FDA gov"),href = "https://www.fda.gov/news-events/press-announcements/coronavirus-covid-19-update-daily-roundup-september-21-2020" )),
                                  )
                         )
                     )
                ),
            navbarMenu(title = "Contact Us",
                       tabPanel("Address", "B612"),
                       tabPanel("Phone", "4008-123123")
            )
                )
    )
)

server <- function(input, output){
    output$line_chart <- renderPlotly({
        plot_ly(x = TSLA$Date,y = TSLA$`Adj Close`)%>%
        add_lines()
    })
    
    output$table <- renderDataTable({
        datatable(TSLA)
    })
}
    
shinyApp(ui = ui, server = server)
