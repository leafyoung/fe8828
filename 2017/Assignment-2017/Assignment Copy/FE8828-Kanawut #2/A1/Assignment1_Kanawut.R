require(shiny)

myUi <- fluidPage(
  fluidPage(
    titlePanel(p("RICCIO INVESTMENT LIMITED", style = "color:navy")),
    navbarPage(title = "",
             
               
               tabPanel("HOME",
                        headerPanel(
                          column(8,offset=0,
                                 tags$img(height=400,
                                          width=1400,
                                          src="https://i2.wp.com/blogs.cfainstitute.org/investor/files/2017/04/Investing-in-Europe-Where-is-the-Return-1.png?resize=940%2C575&ssl=1")
                          )
                        ),
                        navlistPanel(
                          tabPanel("ABOUT US",
                                   titlePanel("RICCIO INVESTMENT (GLOBAL MACRO STRATEGY)"),
                                   
                                   p("Riccio Investment Limited was registered in BVI (British Vergin Islands) on 9 May 2013 funded by the management and directors more than US$ 600,000 and financially based in Hong Kong."),
                                   strong("***Our Vision : At Riccio, our intrigrity and our reputation are the top prioprities.***"),
                                   br(),
                                   strong("- Preserve the principle but maximise the profits."),
                                   br(),
                                   strong("- Distribute excess cash flow every month."),
                                   br()
                                   
                                   
                                   
                                   
                                   
                          ),
                          tabPanel("MANAGEMENT TEAM",
                                   h3(strong("Chief Invesment Officer - Kanawut Laoritthikrai")),
                                   br(),
                                   p("Mr Kanawut is currently one of the directors of Riccio Investment Limited and a fund manager of Mudley group. He participates as an opinion leader in public providing investment ideas, where he initially develops his own successful model that helps individual investors with the development of stock trading strategy as a whole."),
                                   p("After winning the Stock Exchange of Thailand's University Stock Competition in 2002, Mr Kanawut resigned from the faculty of Engineering, King Mongkut's Institute of Technology Ladkrabang and started his career as a private portfolio manager managing portfolio for wealthy foreign, and Thai investors. In 2004, Kanawut joined E-Finance Thai as a specialized speaker in the topic of technical analysis."),
                                   p("After 2 years of sophisticated investment training in the US, Mr Kanawut served as a trader and analyst at Altera Partners Management from 2008 - 2010, a London based investment management company with asset under management of more than USD 500 million.  His portfolio under his management earned a positive double digit 12% returns during the financial market crisis of 2008 - 2009."),
                                   p("Mr Kanawut left Altera Partners Management in 2011 to participate in Mudley group full time. He is also the co-founder of Riccio Investment Limited."),
                                   br(),
                                   h3(strong("Managing Director - Bryan Lim")),
                                   br(),
                                   p("Mr Bryan is one of the founders of FXA Group Limited, a leading developer and supplier of integrated traceability software for the food and animal health industry. As the company's Chief Operating Officer since May 2001, he has been instrumental in raising first round capital and in securing market leadership for FXA's flagship OpsSmart traceability software within the Asia-Pacific region and beyond."),
                                   p("Mr Bryan's experience in the Thai business sector includes 3 years as Managing Director of Samart New Media Co Ltd, where he developed and managed several emerging e-commerce  and internet businesses. As Director of Samart Corporation (Public Corporation) Ltd, he managed one of the fastest growing Internet Service Providers in Thailand at the time. Mr Chatta also spent four and a half years with IBM Thailand and the Siam Cement Group during which time he acquired a detailed understanding of the ICT sector and database management."),
                                   p("Mr Bryan is the co-founder of Riccio Investment Limited.")
                                   
                                   
                                   
                                   ),
                          tabPanel("PAST PERFORMANCE",
                                   headerPanel(
                                     column(8,offset=0,
                                            tags$img(height=400,
                                                     width=800,
                                                     src="http://roulettetrader.com/wp-content/uploads/2017/07/GBPJPY-Breakout-7-15-17-small.png")
                                     )
                                   ),
                                  
                                   h2(strong("***Past performances do not garuntee the future profit***"))
                                   
                                   
                                   )
                         
                          
                        )
                       
               ),
               navbarMenu(title="PRODUCT",
                          tabPanel("Emerging market fund",
                                  titlePanel("EMERGING MARKET FUND"),
                                    headerPanel(
                                     column(8,offset=0,
                                            tags$img(height=400,
                                                     width=1400,
                                                     src="http://beginners-investing.com/wp-content/uploads/2015/10/blue-man-with-papers-1200x440.jpg")
                                     )
                                   ),
                                 
                                  
                                   h2("Equity"),
                                   tags$li(h3("China growth equity")),
                                   tags$li(h3("India growth equity")),
                                   tags$li(h3("Thailand growth equity")),
                                   
                                   h2("Bond"),
                                   tags$li(h3("Short-term government bond")),
                                   tags$li(h3("Long-term government bond")),
                                   tags$li(h3("High-yield coporate bond"))
                                 
                                   ),
                          tabPanel("US market fund",
                                   titlePanel("US MARKET FUND"),
                                   headerPanel(
                                     column(8,offset=0,
                                            tags$img(height=400,
                                                     width=1400,
                                                     src="http://i2.cdn.turner.com/money/dam/assets/150414102528-us-strong-economy-780x439.jpg")
                                     )
                                     
                                   ),
                                   h2("Equity"),
                                   tags$li(h3("Us technology stock")),
                                   tags$li(h3("US energy stock")),
                                   br(),
                                   h2("Bond"),
                                   tags$li(h3("Short-term government bond")),
                                   tags$li(h3("Long-term government bond")),
                                   tags$li(h3("High-yield coporate bond"))
                                   
                                   ),
                          tabPanel("Commodity and foreign excahnge fund",
                                   titlePanel("COMMODITY AND FOREIGN EXCHANGE FUND"),
                                   headerPanel(
                                     column(8,offset=0,
                                            tags$img(height=400,
                                                     width=1400,
                                                     src="https://jbcommodity.com/wp-content/uploads/2016/06/what-is-commodity.png")
                                     )
                                   ),
                                   h2("Commodity"),
                                   tags$li(h3("Gold long-short strategy")),
                                   tags$li(h3("Crude-oil long-short strategy")),
                                   br(),
                                   h2("Foreigh exchange"),
                                   tags$li(h3("Asia currency long-short strategy")),
                                   tags$li(h3("US-AUD-EUR statistical arbitrage strategy"))
                                  
                                   )
               ),
               tabPanel(title="CONTACT US",
                          titlePanel("CONTACT US"),
                        p("Address: 66 Raffles place"),
                        p("Phone: +65 99990000"),
                        p("Emial: riccio@investment.com"),
                        br(),
                        titlePanel("MAP"),
                        headerPanel(
                          column(8,offset=0,
                                 tags$img(height=400,
                                          width=800,
                                          src="https://food.mthai.com/app/uploads/2014/06/Raffles-Place-Map2.jpg")
                          )
                        )
                        
               )
               
               
           )
    )
)

myServer <- function(input, output){}
shinyApp(ui = myUi, server=myServer)


