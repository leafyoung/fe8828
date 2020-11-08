library(conflicted)
library(shiny)
library(lubridate)
library(bizdays)
library(dplyr)
library(DT)

conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

#Create a bond schedule
#Inputs: start date, tenor, coupon rate, coupon frequency (Q/H/A), and yield to maturity.
#Output: coupon schedule (ignore public holidays), amount in table and plot.

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Generate Your Bond Schedule"),
    fluidRow(
        column(12,
               wellPanel(
                   dateInput("date", "Start Date", value = "2012-01-01", min = "2000-01-01"),
                   numericInput("Tenure", "Tenure", value = 10),
                   numericInput("r", "Coupon Rate", value = 0.05),
                   textInput("Freq", "Coupon Frequency", value = "H", placeholder = "Type Q for quarter, H for semiannual, A for annual"),
                   numericInput("Y", "Yield to maturity", value = 0.05),
                   actionButton("go", "Go")
               ))
    ),
    
    fluidRow(
        column(8, h3("Coupon Schedule table"),
               dataTableOutput("scheduleTable")),
        column(4, h3("Cash Flow Plotting"),
               selectInput("plot_color", "Highlight", choices = colors()),
               plotOutput("cf")
               )
        ),
    h2(textOutput("npv"), align = "center")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    observeEvent(input$go,
                 {
                     npv <- reactiveVal(0)
                     cp <- 0
                     
                     Get_freq <- function(Freq)
                     {
                         #get payment frequency per year
                         freq<- 0
                         if(Freq == "Q")
                         {
                             freq = 4
                         }
                         else if(Freq == "H")
                         {
                             freq = 2
                         }
                         else if(Freq == "A")
                         {
                             freq = 1
                         }
                     }
                     
                     freq <- Get_freq(isolate(input$Freq))
                     #get coupon amount per payment
                     coupon <- isolate(input$r)*100
                     yield <- isolate(input$Y)/freq
                     cp <- coupon/freq
                     
                     CF_Table <- function()
                     {
                         #calculate npv
                         Sum <- 0
                         TotalLen <- isolate(input$Tenure)*freq
                         for(i in (1:TotalLen))
                         {
                             Sum = Sum + cp/(1+yield)^i
                             if(i == TotalLen)
                             {
                                 Sum = Sum + 100/(1+yield)^i
                             }
                         }
                         npv(Sum)
                     }
                     
                     
                     #generate data table
                     cashflow <- reactive(
                         {
                             #generate dates that make payment 
                             startDate <- isolate(input$date)
                             TotalLen <- isolate(input$Tenure)*freq
                             D <- seq(Sys.Date(), Sys.Date(), length.out = TotalLen)
                             for(i in c(1: TotalLen))
                             {
                                 tmpDate <-startDate
                                 month(tmpDate) <- i*(12/freq) + as.integer(as.character(startDate, format = "%m"))
                                 if(weekdays(as.Date(tmpDate)) == "Sunday")
                                 {
                                     day(tmpDate) <- as.integer(as.character(startDate, format = "%d")) + 1
                                 }
                                 else if(weekdays(as.Date(tmpDate)) == "Saturday")
                                 {
                                     day(tmpDate) <- as.integer(as.character(startDate, format = "%d")) + 2
                                 }
                                 D[i] = tmpDate
                             }
                             cf <- tibble(Date = D, Amount = c(seq(cp,cp,length.out= length(D) - 1),(cp+100)))
                             cf
                         }
                     ) 
                     
                     observeEvent(input$r, CF_Table())
                     observeEvent(input$date, CF_Table())
                     observeEvent(input$Tenure, CF_Table())
                     observeEvent(input$Y, CF_Table())
                     
                     output$scheduleTable <-renderDataTable(datatable(
                         isolate(cashflow()),
                         option = list(pageLength = 10,lengthChange=FALSE))%>%
                         formatStyle(columns = c(1:2), 'text-align' = 'center')
                     )
                     
                     output$cf <- renderPlot({
                         s <- input$scheduleTable_rows_selected
                         cf <- isolate(cashflow())
                         plot(cf$Date, cf$Amount, xlab = "Date", ylab = "Amount")
                         if (length(s)) {
                             points(cf[s, c("Date", "Amount"), drop = F],
                                    pch = 19, cex = 1, col = "lightskyblue") # input$plot_color
                         }
                     })
                     output$npv <- renderText(
                         paste0("This bond's NPV is ", isolate(npv()), " at ",input$date)
                     )
                 })
   
}

# Run the application 
shinyApp(ui = ui, server = server)
