library(shiny)
library(shinythemes)
library(shinyWidgets)

ui<-fluidPage(
  theme = shinytheme("cerulean"),
  setBackgroundImage(
    src = "https://www.xmple.com/wallpaper/blue-gradient-white-linear-1920x1080-c2-87cefa-ffffff-a-270-f-14.svg"
  ),
  
  titlePanel(strong(em("QUANTVERSE"))),
  
  ui<-navbarPage(
    
    tabPanel(""),
    
    tabPanel("Main",
             sidebarLayout(
               sidebarPanel("QuantVerse Asset Management(Q.A.M) is an investment management
                            company with approximately US$5 billion in assets
                            under management as of 31 March 2019 .",
                            br(),
                            "Q.A.M is headquartered in Singapore with affiliated offices in London and Hong Kong ."),
               mainPanel(img(src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Singapore_Skyline_at_Night_with_Black_Sky.JPG", style="width: 100% ; height: 600px")))),
    
    tabPanel("About us",
             h1(img(src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Singapore_Skyline_at_Night_with_Black_Sky.JPG", style="width: 100% ; height: 300px")),
             
             h2("....................ABOUT US....................", align="center"),
             
             h3("We believe we integrate fixed-income arbitrage with global macro strategies in a novel way, 
                developing technology that focuses on the potential of human-machine integration.
                We want to build systems where machines do what they do best, supporting people to do what people do best."),
             br(),
             br(),
             "Quantverse pursues macro and fixed income relative value investment strategies in global interest rate, foreign exchange, equity, commodity and credit markets. 
              Investments are made in both developed and emerging market countries. The firm's activity is weighted to interest rate and foreign exchange markets and to execution via swaps, futures, options and cash instruments. 
              Quantverse seeks to generate superior risk-adjusted returns with low correlations to the main asset classes."),
             
          
    
    navbarMenu("Products",
               tabPanel("GLOBAL ARBITRAGE FUND ",sidebarLayout(sidebarPanel("Global Arbitrage Fund is a niche fund that has an absolute return target with low volatility. 
                                                                   It takes minimal directional exposure to any underlying asset.
                                                                   At its core it trades in arbitrage style strategies across asset classes including FX, Commodities, Rates, Equity and Volatility. 
                                                                  It also trades in relative value basis and curve trading strategies across asset classes. It offers monthly liquidity."), 
                                                     mainPanel(plotOutput("Plot1")))),
               tabPanel("ASIAN EQUITIES STRATEGY FUND", sidebarLayout(sidebarPanel("Our global multi-asset strategy invests in publicly traded bonds, equities and currencies in both developed and emerging markets. 
                                                                                   The strategy draws on systematic sources of risk
                                                                                   premia from both traditional asset classes and non-traditional investment strategies, as well as skill-based sources of returns through active management."), 
                                                  mainPanel(plotOutput("Plot2")))),
               tabPanel("QUANTITATIVE MARKET-NEUTRAL FUND", sidebarLayout(sidebarPanel("Our market neutral fund is a systematic market-neutral long/short equity strategy that seeks to generate attractive risk-adjusted absolute returns through a blend of quantitative and fundamental investment techniques. 
                                                                                       The strategy algorithmically generates stock-specific investment signals through a proprietary process that formulates collective insights on industry and company fundamentals."), 
                                                      mainPanel(plotOutput("Plot3"))))
    ),
    navbarMenu("Contact us",
               tabPanel("Contact details",
                        h1("HR contact no.- +65 8765 4321"),
                        h2("EMail-id - Careers.Quantverse@gmail.com")),
               tabPanel("Career opportunities",
                        h1("Personal Details",
                           fluidPage(
                             textInput("caption1", "Name", width = '50%'),
                             verbatimTextOutput("value1"),
                             br(),
                             textInput("caption2", "Contact number", width = '50%'),
                             verbatimTextOutput("value2"),
                             br(),
                             textInput("caption3", "Email id", width = '50%'),
                             verbatimTextOutput("value3"),
                             br(),
                             textInput("caption4", "About yourself", width = '50%'),
                             verbatimTextOutput("value4", placeholder = TRUE)
                             
                             
                             
                             
                           ))))
  ))

server<-function(input, output){
  output$Plot1<-renderPlot({
    
    barplot(c(12,14,8,10,15),col = "#75AADB", border = "white",
            ylab = "Performance (%)",
            xlab = "Past 5 years performance(2014-2018)")
  })
  output$Plot2<-renderPlot({
    barplot(c(9,11,8,10,14),col = "#75AADB", border = "white",
            ylab = "Performance (%)",
            xlab = "Past 5 years performance(2014-2018)")
  })
  output$Plot3<-renderPlot({
    barplot(c(10,14,8,10,13),col = "#75AADB", border = "white",
            ylab = "Performance (%)",
            xlab = "Past 5 years performance(2014-2018)")
  })
  output$value1 <- renderText({ input$caption1 })
  output$value2 <- renderText({ input$caption2 })
  output$value3 <- renderText({ input$caption3 })
  output$value4 <- renderText({ input$caption4 })
  
}

shinyApp(ui = ui, server = server)