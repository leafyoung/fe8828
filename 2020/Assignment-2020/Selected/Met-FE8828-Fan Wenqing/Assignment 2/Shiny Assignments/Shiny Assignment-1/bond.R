library(shiny)

ui <- fluidPage(
    textInput("date", "Start Date (YYYY/MM/DD)", "2008/08/11"),
    numericInput("t", "Tenor", 3),
    numericInput("r", "Coupon Rate", 0.2),
    numericInput("x", "Coupon Frequnecy", 2),
    numericInput("ytm", "Yield To Maturity", 0.05),
    
    
    h4("Bond Price"),
    textOutput("t1"),
    h4("Coupon Sechedule Table"),
    tableOutput("t2"),
    h4("Coupon Sechedule Plot"),
    plotOutput("p1")
)

server <- function(input, output, session) {
    
        output$t1 <- renderPrint({
            n <- input$t * input$x
            coupon <- 100*input$r/input$x
            real_ytm <- input$ytm/input$x          
        
            npv <- c(n)
            for(i in 1:n){
                npv[i] = coupon/((1+real_ytm)^i)
            }
            npv[n] = npv[n] + 100/((1+real_ytm)^n)
            price <- sum(npv)
            cat(paste0(round(price,2),"\n"))
        })
        
       output$t2 <- renderTable({
           
           n <- input$t * input$x
           coupon <- 100*input$r/input$x
           bond <- list()
           bond$time <-c(1:n)
           bond$fv <- c(n)
           for(i in 1:(n-1)){
               bond$fv[i] = coupon
               i = i + 1
           }
           bond$fv[n] = coupon + 100
           
          bond
       })
        
        output$p1 <- renderPlot({
            n <- input$t * input$x
            coupon <- 100*input$r/input$x
            real_ytm <- input$ytm/input$x          
            
            fv <- c(n)
            for(i in 1:n){
                fv[i] = coupon/((1+real_ytm)^i)
            }
            fv[n] = fv[n] + 100/((1+real_ytm)^n)
            plot(fv)
            lines(fv)
        })
        
}
        

shinyApp(ui, server)