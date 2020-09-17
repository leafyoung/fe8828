library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  fluidPage (
    titlePanel("Wealth Management DIY"),
    sidebarLayout(
      sidebarPanel ("The most trustworthy advisor is", 
                    h1("YOURSELF"),
                    a("Link to the profile of WMDIY's Founder: Kevin Chen JG",
                      href = "https://www.linkedin.com/in/Kevin-JGChen"
                    )
      ),
      mainPanel ("What if you could manage your own wealth from the convenience of your own home and at your own free time?
               What if you could do detailed analysis of your own investment and insurance products at the click of a single button (or a few buttons)?"
      )
    ),
    img(src= "money1.jpg", width = "37%"),
    img(src= "money2.jpg", width = "37%"),
    
    navbarPage (title = "A Do-It-Yourself Approach",
                tabPanel ("What we do",
                          navlistPanel(
                            "What we do",
                            tabPanel ("What is <Wealth Management DIY>?",
                                      h1 ("What is <Wealth Management DIY>?"),
                                      p ("A place where you can conduct your own DIY analysis of 
                investment and insurance products to suit your own wealth management needs.")),
                            tabPanel ("What products can be analyzed?",
                                      h1 ("What products can be analyzed?"),
                                      p ("Stocks/shares, Unit Trust, Bonds, Structured Notes, Life Insurance Plans, Health Insurance Plans, Mortgage Loans etc."))
                          ),
                          titlePanel ("What Qualifications Does Your Founder, Kevin Chen JG Has? Is He Qualified Enough TO Create This Service?"),
                          tags$ol ("Kevin Chen has attained the below certifications:",
                                   tags$li ("Chartered Financial Analyst (CFA)"),
                                   tags$li ("Financial Risk Manager (FRM)"),
                                   tags$li ("Chartered Alternative Investment Analyst (CAIA)"),
                                   tags$li ("Certificate in Investment Performance Measurement (CIPM)"),
                                   tags$li ("Certified Financial Planner (CFP)"),
                                   tags$li ("Chartered Financial Consultant (ChFC)"),
                                   tags$li ("Chartered Life Underwriter (CLU)"),
                                   tags$li ("Institute of Banking and Finance Singapore Advanced Certification (IBFA)")
                          )
                ),
                
                tabPanel ("About Us",
                          titlePanel ("What is unique about us?"),
                          tags$ul ("About Us",
                                   tags$li ("Who are we: We are a one-man team that has a combined experience in the Wealth Management Industry of 12 years"),
                                   tags$li ("What we do: When we see problems within the Wealth Management Industry, we acknowledge it and work on a solution to make people's lives better")
                          ),
                          h1 ("Area To Make Yourself Feel Better"),
                          wellPanel (
                            h2 ("Click to feel slightly better"),
                            actionButton("goButton", "click"),
                            h2 ("Click to feel better"),
                            actionButton("goButton", "Click."),
                            h2 ("Click to feel much better"),
                            actionButton("goButton", "CLICK!")
                          )
                ),
                
                navbarMenu (title = "Contact Us",
                            tabPanel ("Address", "Block 000 Chai Chee Road, Prestige Office Tower, #88-888, Singapore 222222"),
                            tabPanel ("Phone/Email",
                                      tags$ol ("Our Contact Numbers/Emails",
                                               tags$li ("+065-9996540"),
                                               tags$li ("+065-1117802"),
                                               tags$li ("WMDIY@nosuchemail.com")
                                      )  
                                      
                            )
                )
    )
  )    
)        

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)








