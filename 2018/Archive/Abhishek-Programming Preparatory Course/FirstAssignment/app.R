library(shiny)
library(quantmod)
library(shinythemes)
library(Quandl)

Webpagetheme<-shinytheme("journal")
HeadPanel<-headerPanel(
  img(src="download.jpg", align = "left",height=100)
)
#Code for UI for homepage
tabpanel1<-tabPanel("Home",
                    h1("Welcome to DataBargain!",
                       style = "font-family: 'Helvetica', cursive;
                       font-weight: 700; line-height: 1.1;text-align:center; 
                       color: #000000;background-color: #fff"),
                    br(),
                    h4("The one stop shop for access to all data relevant to traders and investors alike, explore our website to discover the power of Data at no cost!, Our offerings include",
                       style = "font-family: 'Courier', cursive;
                       font-weight: 700; line-height: 1.1;text-align:center; 
                       color: #000000;background-color: #fff"),
                    tags$ol(
                      tags$li("Stock Price History"),
                      tags$li("Financial Statements")
                      ,style = "font-family: 'Courier', cursive;
                      font-weight: 700; line-height: 1.1;font-size:18px;text-align:left; 
                      color: #000000;background-color: #fff")
                    )
#Code for UI for Second tab- Price History
tabpanel2<-tabPanel("Price History",sidebarLayout(
  sidebarPanel(
    helpText("Enter The Stock Code and the date range"),
    textInput("symb", "Symbol", "SPY"),
    dateRangeInput("dates", 
                   "Date range",
                   start = "2013-01-01", 
                   end = as.character(Sys.Date())),width = 3
  ),
  mainPanel(plotOutput("plot"))
))
#Code for UI for Third Tab - Financial Data
tabpanel3<-tabPanel("Financial Data",textInput("symb1", "Symbol", "AAPL"),helpText("Enter The Stock Code"),
                    fluidRow(column(6,navlistPanel(
                      
                      "Financial Statements",
                      tabPanel("Balance Sheet",tableOutput("table1")),
                      tabPanel("Income Sheet",tableOutput("table2")),
                      tabPanel("Cash Flow Sheet",tableOutput("table3"))
              )
        )
    )
)
#Code for the navigation bar 
NavigationPage<-navbarPage(
  "Databargain.com",
  tabpanel1,
  tabpanel2,
  tabpanel3
)
Pagefooter<-fluidRow(tags$footer("Information Costs Money, Insight Makes Money",tags$footer("To sign-up for our Data Analytics package"),tags$a(href="www.google.com", "Click Here!"),
                                 style = "font-family: 'Courier', cursive;
                                 font-weight: 700;font-style: italic;font-size:18px; line-height: 1.1;text-align:center;padding-top:685px"))

                    
ui <- fluidPage(theme=Webpagetheme,
                HeadPanel,
                fluidRow( br(),br(),br(),br(),br(),
                          column(12,NavigationPage),
                          Pagefooter
                )
)
server <- function(input, output) {
  #Reactive function that accepts input from user and generates chart. Data source -> Yahoo
  dataInput <- reactive({
    getSymbols(input$symb, src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  #Reactive function that accepts input from user and generates Data Table. Data source -> Quandl
  dataTable <- reactive({
    Quandl.api_key('yt-yAxtA53mZ5zgmPST5')
    dataF<-Quandl.datatable('SHARADAR/SF1', calendardate='2017-12-31', ticker=input$symb1)
  })
  #Plots stock price chart
  output$plot <- renderPlot({
    chartSeries(dataInput(), theme = chartTheme("white"), 
                type = "line",TA=NULL)
  })
  #Three functions below all render same table, I was unable to find an API that could give me accurate financial statement data for 
  #Balance Sheet, Income Statement etc. This is just to demonstrate the skeleton code for accpeting inout from the user and generating
  #the corresponding data table
  output$table1<-renderTable(
    {
      dataTable()
    }
  )
  output$table2<-renderTable(
    {
      dataTable()
    }
  )
  output$table3<-renderTable(
    {
      dataTable()
    }
  )
}
shinyApp(ui = ui, server = server)
