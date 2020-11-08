# WU Hongsheng
# G2000655A
# Q2

library(shiny)
library(bizdays)
library(lubridate)
library(tibble)

ui <- fluidPage(
    h3("Input"),
    dateInput("start_d", "Start Date"),
    numericInput("tenor", "Tenor (years)", 5),
    numericInput("mv", "Maturity Value", 1000, step = 100),
    numericInput("cpr", "Coupon Rate (annually nominal)", 0.10, step = 0.01),
    selectInput("cpf", "Coupon Frequency (months)", choices = c(3, 6, 12), 3),
    numericInput("ytm", "Yield to Maturity (annually nominal)", 0.08, step = 0.01),

    actionButton("go", "Go"),
    
    h3("Output & Bond Schedule"),
    verbatimTextOutput("dateText"),
    h4("Table Schedule"),
    dataTableOutput("Table"),
    h4("Plot Schedule (for Cash Flow)"),
    plotOutput("p1")
)

server <- function(input, output, session) {

    observeEvent(input$go, {
        
        st_date <- isolate(input$start_d)
        ed_date <- st_date %m+% months((isolate(input$tenor)*12))
        num_mt <- isolate(input$tenor)*12
        inv <- as.numeric(isolate(input$cpf))
        lst <- inv*c(1:(num_mt/inv))
        date_lst <- st_date %m+% months(lst)
        biz_lst <- add.bizdays(date_lst-1, 1, "weekends")
        cp <- ((isolate(input$cpr))/(12/inv)) * isolate(input$mv)
        cp_lst <- rep(cp, length(biz_lst)-1)
        cp_lst <- c(cp_lst, cp+isolate(input$mv))
        t_lst <- 1:length(biz_lst)
        int_rate <- (isolate(input$ytm))/(12/inv)
        dcf_lst <- cp_lst/(1+int_rate)^t_lst
        rdcf <- rep(sum(dcf_lst), length(dcf_lst))
        
        for(i in 1:length(dcf_lst)){
            rdcf[i] <- rdcf[i] - sum(dcf_lst[1:i])
        }
        
        res <- tibble(Date = biz_lst, "Payment No." = t_lst, "Cash Flow (CF)" = cp_lst,
                      "Discounted CF" = dcf_lst, "Bond Price at time0" = sum(dcf_lst),
                      "Remaining Value" = rdcf)
        
        output$dateText  <- renderText({
            paste("The bond period is from", as.character(st_date), "to", as.character(ed_date))
        })
    
        output$Table  <- renderDataTable({
            res
        })
    
        output$p1  <- renderPlot({
            res1 <- tibble(Date = biz_lst, "Cash Flow (CF)" = cp_lst)
            barplot(height = res1$"Cash Flow (CF)", names.arg = res1$Date,
                    xlab = "Date", ylab = "Coupon Cash Flow")
        })
    })
}

shinyApp(ui, server)