library(shiny)
library(conflicted)
library(bizdays)
library(lubridate)
library(dplyr)
library(DT)

conflict_prefer("dataTableOutput", "DT")
conflict_prefer("renderDataTable", "DT")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Bond Schedule"),
    fluidRow(
        column(8,
               wellPanel(
                   dateInput("startTime", "Start Time", value = "2020-01-01"),
                   numericInput("tenor", "Tenor", value = 10),
                   numericInput("Rate", "Coupon Rate", value = 0.05),
                   textInput("couponFreq", "Coupon Frequency", value = "H",
                             placeholder = "Q/H/A"),
                   numericInput('yield', "Yield to Maturity", value = 0.03),
                   actionButton("go", "Ok")
               ))
    ),
    fluidRow(
        column(8, h4("Coupon Schedule Table"),
               dataTableOutput("Table")),
        column(4, h4("Cash Flow Plot"),
               selectInput("plot_color", "Highlight", choices = colors()),
               plotOutput("CF")),
        h4(textOutput("NPV"), aligh = "center")
        
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$go,
                 {
                     NPV <- reactiveVal(0)
                     cp <- 0
                     
                     get_freq <- function(Freq){
                         if (Freq == "A")
                             freq <- 1
                         else if (Freq == "H")
                            freq <- 2
                         else if (Freq == "Q")
                             freq <- 4
                     }
                 freq <- get_freq(isolate(input$couponFreq))
                 coupon <- isolate(input$Rate)*100
                 yield <- isolate(input$yield)/freq
                 cp <- coupon/freq
                 
                 CF_Table <- function(){
                     sum <- 0
                     totalLen <- isolate(input$tenor)*freq
                     for (i in (1:totalLen))
                     {
                         sum = sum + cp/(1+yield)^i
                         if (i == totalLen)
                         {
                             sum = sum + 100/(1+yield)^i
                         }
                     }
                     NPV(sum)
                 }
                 
                 cash_flow <- reactive(
                     {
                         startDate <- isolate(input$startTime)
                         totalLen <- isolate(input$tenor)*freq
                         Date <- seq(Sys.Date(), Sys.Date(), length.out = totalLen)
                         for (i in c(1:totalLen)){
                             tmpDate <- startDate
                             month(tmpDate) <- i*(12/freq) + as.integer(as.character(startDate, format = "%m"))
                             if(weekdays(as.Date(tmpDate)) == "Sunday")
                             {
                                 day(tmpDate) <- as.integer(as.character(startDate, format = "%d")) + 1
                             }
                             else if(weekdays(as.Date(tmpDate)) == "Saturday")
                             {
                                 day(tmpDate) <- as.integer(as.character(startDate, format = "%d")) + 2
                             }
                             Date[i] = tmpDate
                         }
                         CF <- tibble(Date = Date, Amount = c(seq(cp,cp,length.out= length(Date) - 1),(cp+100)))
                         CF
                         }
                 )
                 
                 observeEvent(input$Rate, CF_Table())
                 observeEvent(input$startTime, CF_Table())
                 observeEvent(input$tenor, CF_Table())
                 observeEvent(input$yield, CF_Table())
                 
                 output$Table <-renderDataTable(datatable(
                     isolate(cash_flow()),
                     option = list(pageLength = 15,lengthChange=FALSE))%>%
                         formatStyle(columns = c(1:2), 'text-align' = 'center')
                 )
                 
                 output$CF <- renderPlot({
                     s <- input$Table_rows_selected
                     CF <- isolate(cash_flow())
                     plot(CF$Date, CF$Amount, xlab = "Date", ylab = "Amount")
                     if (length(s)) {
                         points(cf[s, c("Date", "Amount"), drop = F],
                                pch = 19, cex = 1, col = "lightskyblue") # input$plot_color
                     }
                 })
                 output$NPV <- renderText(
                     paste0("The bond's NPV is ", round(isolate(NPV()),2), " at ", input$startTime, sep = " ")
                 )
                 
                 })
}

# Run the application 
shinyApp(ui = ui, server = server)
