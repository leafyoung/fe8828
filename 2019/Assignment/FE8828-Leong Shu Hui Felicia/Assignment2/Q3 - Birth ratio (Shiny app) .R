library(shiny)

ui <- fluidPage(

    numericInput("n", "Samples:", 100),
    h1("Ratio of girls in the population",align="center"),
    plotOutput("p1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$p1 <- renderPlot({
        birth_ratio <- function() {
            families <- sample(c(0,1), replace=TRUE, size=10)
            boy = 0
            girl = 0
            
            while (length(families)!=0) {
                familywithallgirls =0
                for(i in families) {
                    if (i == 0) {
                        boy = boy +1
                    } 
                    if (i == 1) {
                        girl = girl +1
                        familywithallgirls = familywithallgirls +1
                    }
                }
                families <- sample(c(0,1), replace=TRUE, size=familywithallgirls)
            }
            
            total = boy + girl
            Ratio = girl / total
            return(Ratio)
        }
        
        n = input$n
        listofbirth = list()
        count =0
        for (i in 1:n){
            listofbirth[i] = birth_ratio()
        }
        
        Distribution <- unlist(listofbirth, use.names = FALSE)
        hist(Distribution)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
