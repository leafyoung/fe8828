library(shiny)
library(lubridate)
library(reactable)
library(dplyr)
library(ggplot2)
library(chron)

ui <- fluidPage(
    
    titlePanel("Bond Schedule"),
    
    sidebarLayout(
        sidebarPanel(width = 2,
                     dateInput("start", "Start Date", value = Sys.Date()),
                     numericInput("tenor", "Tenor (Years)", value = 5),
                     selectInput("coupon_frequency", "Coupon Frequency",
                                 choices = c("Quarter" = 4,
                                             "Semi Annual" = 2,
                                             "Annual" = 1)),
                     numericInput("coupon_rate", "Coupon Rate (%)", value = 5),
                     numericInput("yield", "Yield to Maturity (%)", value = 5),
                     numericInput("maturity", "Face Value ($)", value = 100),
                     actionButton("b_submit", "Submit")
        ),
        
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Coupon Schedule Table", reactableOutput("coupon_schedule_table")),
                        tabPanel("Plot", plotOutput("plot")),
                        tabPanel("Net Present Value", verbatimTextOutput("net_present_value")),
                        tabPanel("Bond Price", verbatimTextOutput("bond_price")))
        )
    )
)

server <- function(input, output) {
    
    observeEvent(input$b_submit, {
        bond_cf <- reactive({
            
            n = input$tenor * as.numeric(input$coupon_frequency)
            
            bond_cf = matrix(ncol = 3, nrow = length(seq(0, n-1, 1)))
            
            for(i in seq(0, n-1, 1)) {
                ts <- i/360*30
                date <- as.Date(input$start) %m+% months(i*12/as.numeric(input$coupon_frequency))
                while(is.weekend(date)) {
                    date <- date - 1
                }
                cf <- (input$coupon_rate/100)/as.numeric(input$coupon_frequency)*input$maturity
                bond_cf[i,1] = ts
                bond_cf[i,2] = date
                bond_cf[i,3] = cf
            }
            
            bond_cf[n,1] = n/360*30
            bond_cf[n,2] = as.Date(bond_cf[n-1,2], origin = "1970-01-01") %m+% months(12/as.numeric(input$coupon_frequency))
            bond_cf <- as.data.frame(bond_cf)
            while(is.weekend(bond_cf[n,2])) {
                bond_cf[n,2] <- bond_cf[n,2] - 1
            }
            bond_cf[n,3] = input$maturity + (input$coupon_rate/100)/as.numeric(input$coupon_frequency)*input$maturity
            colnames(bond_cf) <- c("TS","Time","Payout")
            bond_cf %>% 
                as.data.frame() %>% 
                mutate(Time = as.Date(Time, origin = "1970-01-01")) %>% 
                mutate(Payout = round(Payout, digits = 2)) %>% 
                select(Time, Payout)
        })
        
        output$coupon_schedule_table <- renderReactable({
            bond_cf() %>% 
                reactable(pagination = F) 
        })
        
        output$net_present_value <- renderText({
            npv = 0
            for(i in 1:nrow(bond_cf())){
                npv = npv + (bond_cf()$Payout[i])/((1+(input$yield)/100/as.numeric(input$coupon_frequency))^i)
            }
            paste0("The net present value is: $", round(npv, digits = 2))
        })
        
        output$bond_price <- renderText({
            n = input$tenor * as.numeric(input$coupon_frequency)
            val_1 = input$coupon_rate / as.numeric(input$coupon_frequency) * input$maturity/100
            val_2 = (1-(1/(1+(input$yield/100/as.numeric(input$coupon_frequency)))^n))/(input$yield/100/as.numeric(input$coupon_frequency))
            val_3 = input$maturity/(1+(input$yield/100/as.numeric(input$coupon_frequency)))^n
            
            bond_price = (val_1 * val_2) + val_3
            
            paste0("The bond price is: $", round(bond_price, digits = 2))
        })
        
        output$plot <- renderPlot({
            bond_cf() %>% 
                ggplot() +
                geom_col(aes(Time, Payout)) +
                theme_minimal() +
                scale_x_date(breaks = bond_cf()$Time) +
                labs(x = "Date", y = "Payout") +
                theme(axis.text.x = element_text(angle = 75, hjust = 1))
        })
    })
    
}

shinyApp(ui = ui, server = server)
