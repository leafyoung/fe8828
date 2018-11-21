#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(bizdays)
library(DT)
library(ggplot2)

# Define UI for application 
ui <- fluidPage(
   
   # Application title
   h1(align = "center",strong("Bond Price Calculator")),
   hr(),
   
   # Sidebar with user input fields 
   sidebarLayout(
      sidebarPanel(
        h4(align = "center", strong("Enter Bond Details Here")),
        textInput("coyname", "Ticker Name", value = "SUNSHI"),
        dateInput("startDate","Start Date of Bond",value = "2017-11-16"),
        sliderInput("tenor","Bond Tenor", value = 3, min = 1, max = 50, step = 1),
        numericInput("cpn","Coupon Rate (%)", value = 7.5, min = 0, max = 100, step = 0.1),
        selectInput("cpnfreq","Coupon Frequency", choices = c("Annual", "Semi-Annual","Quarterly"), selected = "Semi-Annual"),
        numericInput("ytm", "Yield to Maturity",value = 7.69, min = 0, max = 100, step = 0.001)
      ),
      
      # Show bond details
      mainPanel(
         h3(align = "center",tags$b(textOutput("Title"))),
         plotOutput("CpnPlot"),         
         dataTableOutput("BSchedule"),
         hr(),
         fluidRow(
           column(6, align = "center", h4(tags$b("Ask Yield-to-Maturity")),
                  h2(textOutput("AskYTM"))
                  ),
           column(6, align = "center", h4(tags$b("Current Ask Price")),
                  h2(textOutput("NPV"))
                  )
         )
      )
   )
)

c.freq <- function(user.Input){
  if(user.Input == "Annual")
    y = 1
  if(user.Input == "Semi-Annual")
    y = 2
  if(user.Input == "Quarterly")
    y = 4
  return(y)
}

BS <- function(input){
  create.calendar(name = "WEEKDAYS", start.date = as.Date("2000-01-01"), end.date = as.Date("2100-01-01"), weekdays = c("saturday","sunday"))
  
  cpnCount = input$tenor*c.freq(input$cpnfreq)
  
  d = as.Date(input$startDate, format = "%y-%m-%d")
  month(d) = month(d) + 12/c.freq(input$cpnfreq)
  d.vec = rep(Sys.Date(),cpnCount)
  c.vec = rep(0, cpnCount)
  
  for(i in 1:(cpnCount)){
    d.vec[i] = as.Date(adjust.next(d, "WEEKDAYS"),format = "%y-%m-%d")
    c.vec[i] = input$cpn/c.freq(input$cpnfreq)
    month(d) = month(d) + 12/c.freq(input$cpnfreq)
  }
  
  c.vec[cpnCount] = c.vec[cpnCount] + 100
  
  bs = data.frame(d.vec,c.vec)
  names(bs) = c("Date", "Cash Flows")     

  bs
}

bondpx <- function(input){
  bs.df = BS(input)
  df = bs.df[bs.df$Date >= Sys.Date(),] 
  n = nrow(df)
  
  yield = input$ytm/c.freq(input$cpnfreq)/100
  cpn =   input$cpn/ c.freq(input$cpnfreq)
  round(cpn * (1-(1/(1+yield)^n))/yield + (100/((1+yield)^n)), 3)
}

# Define server logic required
server <- function(input, output) {
     
     output$Title <- renderPrint({
       bs.df = BS(input)
       maturity = as.Date(bs.df$Date[nrow(bs.df)], format = "%d%b%y")
       cat(paste0(toupper(input$coyname)," ", input$cpn, "% ", maturity," Corp"))
     })
     output$BSchedule <- renderDataTable(BS(input), options = list(pageLength = 5))
     output$CpnPlot <- renderPlot({
       bs.df = BS(input)
       p<-ggplot(bs.df, aes(Date, `Cash Flows`))
       p+geom_bar(stat = "identity")
     })
     output$AskYTM <- renderPrint({
       cat(input$ytm)
     })
     output$NPV <- renderPrint({
       cat(bondpx(input))
     })
}

# Run the application 
shinyApp(ui = ui, server = server)

