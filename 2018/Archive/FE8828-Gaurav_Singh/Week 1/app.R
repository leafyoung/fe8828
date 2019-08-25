library(shiny)
install.packages("shinythemes")
library(shinythemes)
install.packages("shinyBS")
library(shinyBS)
install.packages("quantmod")
library(quantmod)
install.packages("Quandl")
library(Quandl)
install.packages("lubridate")
library(lubridate)
install.packages("tis")
library(tis)
# Define UI for application
logo<-tags$img(src="logo.png",width=150,height=50)
companyName<-"GammaCapital"
fontS<-"font-family:Blackadder ITC;"
selectedTheme<-shinytheme("united")
myimg<-tags$img(src = "download.jpg",width=225,height=175, align = "center")
#popup<-mainPanel(bsModal(id = 'startupModal', title =tags$div(logo, 'Welcome to GammaCapital!'), trigger = '',size = 'medium', p("Explore ways to increase your investment!")),width = 12)
titlePanel<-titlePanel(fluidRow(class = "text-center",column(width = 4,logo),column(width=6, tags$b(companyName, style=fontS,style = "font-size:50px;"))),tags$head(tags$link(rel = "icon", type = "image/png", href = "logo.png"),tags$title(companyName)))
navTitle<-tags$a(companyName, style=fontS,style = "font-size:20px;",style="color:inherit;",href="javascript:history.go(0)")

#page1 start------------------------------------

#products page
#reactive plugin***************************************
Quandl.api_key("rTF5jEDYfHn9bFoaZvye")
stockPlugin <- fluidPage(
  titlePanel("Example : Get Historical Prices for tickers & compare with S&P 500 Statistics"),
  fluidRow(
    column(3,
           h3("Enter Ticker"),
           wellPanel(
             textInput("stock", "Enter Ticker :", value="AAPL"),
             selectInput("stat", "Choose Statistic :", c("SP500 PE RATIO/MONTH"="MULTPL/SP500_PE_RATIO_MONTH","SP500 EARNINGS YIELD/MONTH"="MULTPL/SP500_EARNINGS_YIELD_MONTH","SP500 DIV GROWTH/QUARTER"="MULTPL/SP500_DIV_GROWTH_QUARTER"))
           ),
           sliderInput("obs", "Number of months:",
                       min = 1, max = 500, value = 12
           )
    ),
    column(9,
           tabsetPanel(
             tabPanel("Stock Price History",h3("Stock Price History"),basicPage(plotOutput("plot1", click = "plot_click1"),wellPanel("Click on graph to get value"), verbatimTextOutput("info1"))),
             tabPanel("S&P500 Statistics",h3("S&P500 Statistics"),basicPage(plotOutput("plot2", click = "plot_click2"),wellPanel("Click on graph to get value"),verbatimTextOutput("info2")))
             
           )
    )
  ),
  wellPanel("There is an interesting observation around the 2008 financial crisis!")
)
#end *************************************** plugin

page1section1<-"FinTech Solutions"
page1section2<-"Analytics Support"
page1section3<-"Algorithm Trading Support"
page1section1content<-wellPanel("We provide tailor made software solutions and consultancy to clients of all sizes involved in equity trading.",HTML('<br></br>'),stockPlugin)
page1section2content<-wellPanel("We provide Analytics Support to clients who heavily rely on data to make transaction decisions. 24x7 chat bot support available! ",HTML('<br></br>'),HTML('<center><img src="analytics.png" width="400"></center>'),HTML('<center><i>(Image: 8x8)</i></center>'))
page1section3content<-wellPanel("We provide Algorithm Trading Solutions and Support backed by our expert analysts with minimum code latency!",HTML('<br></br>'),HTML('<center><img src="algorithmic-trading.jpg" width="400"></center>'),HTML('<center><i>(Image: binary-options)</i></center>'))
page1<-navlistPanel("Products", tabPanel(page1section1, h1(page1section1),page1section1content), tabPanel(page1section2, h1(page1section2),page1section2content),tabPanel(page1section3, h1(page1section3),page1section3content),widths = c(3, 9))
#page1<-navlistPanel("Products",tabPanel( page1section1, h1(page1section1),page1section1content), tabPanel(page1section2, h1(page1section2),page1section2content),tabPanel(page1section3, h1(page1section3),page1section3content) ) 
navPage1<-tabPanel("Product", page1)
#page1 ends------------------------------------

#page2 start------------------------------------

#about page
page2section1<-"What is GammaCapital?"
page2section2<-"What we do?"
page2section3<-"Upcoming Projects"
page2section1content<-wellPanel("GammaCapital is a FinTech startup firm providing clients tailor made solutions for their trading needs. It was founded by Gaurav Singh, a participant in the MSc Financial Engineering Program at Nanyang Business School.",HTML('<br></br>'),"Gaurav also writes a blog www.fundasingh.info with the motto to Dare-Dream-Deliver!",HTML('<br></br>'),HTML('<center><img src="myimg.png" width="400"></center>'),HTML('<center><i>Gaurav Singh</i></center>'))
page2section2content<-wellPanel("GammaCapital provides Quantitative Analytics support to clients involved in equity trading. ",HTML('<br></br>'),HTML('<center><img src="analytics.jpg" width="400"></center>'),HTML('<center><i>(Image: Google Analytics)</i></center>'),HTML('<center><img src="fintech.jpg" width="400"></center>'),HTML('<center><i>(Image: iStock)</i></center>'))
page2section3content<-wellPanel("We plan to provide interactive dashboards for options and other commodities as per client need.",HTML('<br></br>'),HTML('<center><img src="dashboard.png" width="400"></center>'),HTML('<center><i>(Image: MQL5)</i></center>'))
page2<-navlistPanel("About Us", tabPanel(page2section1, h1(page2section1),page2section1content), tabPanel(page2section2, h1(page2section2),page2section2content),tabPanel(page2section3, h1(page2section3),page2section3content) ,widths = c(3, 9)) 
navPage2<-tabPanel("About us", page2)
#page2 ends------------------------------------

#page3 start------------------------------------

phoneContact<-tabsetPanel(tabPanel("Singapore",br(),h1("Singapore Support:"),br(),tags$a("+65-93421261",style="color:inherit;",href="tel:+65-93421261")), tabPanel("India",br(),h1("India Support:"),br(),tags$a("+91-8506059373",style="color:inherit;",href="tel:+91-8506059373")))
emailContact<-tabsetPanel(tabPanel("Singapore",br(),h1("Singapore Support:",br(),tags$a("gaurav013@e.ntu.edu.sg",style="color:inherit;",href="mailto:gaurav013@e.ntu.edu.sg"))),tabPanel("India",br(), h1("India Support:",br(),tags$a("gauravsingh0109@gmail.com",style="color:inherit;",href="mailto:gauravsingh0109@gmail.com"))))
mainPanelPhone<-mainPanel(phoneContact,width=9)
mainPanelMail<-mainPanel(emailContact,width=9)
sidebarLayoutPhone<-sidebarLayout(sidebarPanel("Support Phone: ",br(),em("Click number to Call"),width=3),mainPanelPhone)
sidebarLayoutMail<-sidebarLayout(sidebarPanel("Support E-mail: ",br(),em("Click address to Email"),width=3),mainPanelMail)
navPage3<-navbarMenu(title = "Contact Us", tabPanel("Phone",sidebarLayoutPhone), tabPanel("E-Mail",sidebarLayoutMail) )
#page3 ends------------------------------------

navBar<-navbarPage(navTitle,navPage1,navPage2 ,navPage3)
ui <- fluidPage(theme=selectedTheme,titlePanel,navBar,hr(),HTML('<center><i>Project 1 for FE8828. Copyrights subject to respective owners.</i></center>'),hr())

# Define server logic
server <- function(input, output,session)
{
  #popup
  #toggleModal(session, "startupModal", toggle = "open")
  
  #PLOT 1 logic, data from QUANTMOD
  output$plot1 <- renderPlot({
  startDate<-as.Date(Sys.Date()-30*input$obs)
  stockData <- na.omit(getSymbols(input$stock, from=startDate , to=as.Date(Sys.Date()),auto.assign = F) [,4])
  plot(stockData,main="Stock Price($)",yaxis.right = FALSE)
    
  })
  
  output$info1 <- renderText({
    paste0("x=",as.Date(as_datetime(as.numeric(input$plot_click1$x))), "\ny=", input$plot_click1$y)
  })
  #PLOT 1 logic ends
  
  #PLOT 2 logic,data from QUANDL
  output$plot2 <- renderPlot({
    startDate<-as.Date(Sys.Date()-30*input$obs)
    dataCompany <- Quandl(input$stat,collapse="daily",start_date=startDate,end_date=as.Date(Sys.Date()),type="raw")
    plot(dataCompany$Date, dataCompany$Value,type="l",xlab="time",ylab="S&P500 EARNINGS/MONTH")
  })
  
  output$info2 <- renderText({
    paste0("x=", as.Date(as.numeric(input$plot_click2$x)), "\ny=", input$plot_click2$y)
  })
  #PLOT 2 logic ends
}
# Run the application
shinyApp(ui = ui, server = server)
