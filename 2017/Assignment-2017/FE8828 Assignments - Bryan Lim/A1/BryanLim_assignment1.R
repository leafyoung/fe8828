library(shiny) 

ui <- fluidPage( 
  fluidPage( 
    navbarPage(title = "Quantum Technologies", 
               
               tabPanel("About us", 
                        titlePanel("Alpha Generation Powered by Quantum Computing"), 
                        sidebarLayout(position = "right",
                          sidebarPanel(
                            h2("Company Information"),
                            tags$ul(tags$b("Senior Management"),
                                    tags$li("Chairman - Steve Li"),
                                    tags$li("Chief Executive Officer - Harry Lee"),
                                    tags$li("Chief Investment Officer - Kanawut Harden")
                              
                                    ),
                            tags$ul(tags$b("Key Facts"),
                                    tags$li("Founded in 2017"),
                                    tags$li("USD 790 Billion AUM (as of Nov 2017"),
                                    tags$li("Ranked no.1 asset manager by itself")
                                    ))
                          ,
                          mainPanel(
                           
                            h3("We invest using technology from the future"),
                            p("Quantum Technologies began in 2017, when renowned quantum computing specialist Steve Li decided to use quantum computers to develop and maintain investment models. 
                              He began by launching the firm's first fund specializing in low-latency quantitative macro strategies and named the firm Quantum Technologies. Today, the firm has funds 
                              that cater to all investor profiles, from A.I-powered deep value strategies to high frequency intraday strategies.")
                          )
                        )),
               
               
               tabPanel("Our Funds", 
                        titlePanel("We believe in the power of computing"), 
                        "All our strategies are possible solely through the use of quantum computers",
                        br(),
                        br(),
                        fluidRow(
                          
                          column(3, offset =1,
                                 wellPanel(h3("Infinium Velocity"),
                                           p("The fund built on speed - the strategies employed here are built on an ultra low-latency edge that is possible only through
                                             out use of hyper-advanced computer sytems and infrastructure.")
                                 )),
                         
                         column(3,offset =0,
    
                                 wellPanel(h3("Quantum Pure Alpha"),
                                           p("Our flagship fund is trusted by global sovereign wealth funds and pension funds for its ability to generate market returns with 
                                             non-positive risk. This is possible through our founder's grounbreaking Shies-Decoux Theorem.")
                                )),
                          
                        column(3, offset =0,
                                 
                                 wellPanel(h3("Quantum Deep Value"),
                                           p("This is the fund that eliminated the traditional value hedge fund market. Simply put, the fund combines the entire unviverse of 
                                             value strategies, and times the selection of different strategies in different economic states to maximize alpha. ")
                                )))),
               
               tabPanel("Our Science",
               navlistPanel(
                 "Our Computers",
                 tabPanel("GEDEX732 QT Compiler",
                          h1("The fastest recorded computer in the world"),
                          
                          p("Developed by our founder Steve Li, the GEGEX732 QT Compiler, also known commercially as the Gigi, is the world's fastest computer. The technology
                            within its processor surpasses that which is used at leading space and technology companies. This allows us to model ultra-sophisticated strategies
                            dynamically, and implement them in infinitesimal timeframes.")),
                 tabPanel("BR0101 Mainframe",
                          h1("The strongest processing unit in the world"),
                          
                          p("After designing Gigi, Steve went out to create the BR0101 Mainframe, also known as the brain. The Brain has the largest processing power in the world,
                            and can perform calculations that no other machine (or human) in the world can perform. Through the use of the Brain, Steve, co-founders Harry and Kanawut
                            launched the Astro Fund, which utilizies astro signals to predict market movement with insignificant error.")),
                 "Our Theories",
                 tabPanel("Steve-Harry Theorem",
                          h1("Steve-Harry Theorem"),
                          
                          p("Our founders Steve and Harry were awarded the Nobel Prize in 2017 for the Steve Harry theorem. The theorem postulates that they are always right, and will
                            always be right as long as the world believes they are right.")),
                 "_ _ _ _ _"
                 
               )),
               
        
               
               
               navbarMenu(title = "Investors", 
                          tabPanel("Current Investors", "Please use your Virtu phone activation."), 
                          tabPanel("Interested Investors", "Please visit your local prestige or private banking branch to find out more.")))
  )
)
    
  

 

server <- function(input, output){ 
  
} 

shinyApp(ui = ui, server = server) 

