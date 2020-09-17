library(shiny)

ui <- fluidPage(
    h1("Optimal split number for size N",align="center"),
    numericInput("N", "N:", 100),
    numericInput("sample", "Samples:", 300),
    actionButton("go", "Go"),
    h3("Optimal split number:"),
    verbatimTextOutput("t1")
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observeEvent(input$go, {
        output$t1 <-renderText({
            make_choice <- function(N, split_number) {
                input_sample <-sample(N,N,replace=FALSE)
                input_list <- list(0)
                count =0
                for (i in input_sample) {
                    count = count +1
                    input_list[count]=i
                }
                
                evaluation <- input_list[1:split_number]
                selection <-input_list[split_number+1:N]
                bestnumber <- max(unlist(evaluation))
                
                if (bestnumber == N) {
                    return(FALSE)
                } else {
                    for (i in selection){
                        if (i>bestnumber){
                            selected <-i
                            if(selected == N){
                                return(TRUE)
                            }else {
                                return(FALSE)
                            }
                            break
                            
                        }
                    }
                }
            }
            
            find_optimal <- function(N,calls) {
                count =0
                optimalN = 0
                for(i in 1:as.integer(N/2)) {
                    foundN = 0
                    for(j in 1:calls){
                        if (make_choice(N,i)==TRUE){
                            foundN = foundN +1
                        }
                        
                    }
                    if (foundN > count) {
                        count <- foundN
                        optimalN <- i
                    }
                }
                return(optimalN)
            }
            
            #finding for N = 100, with 500 calls for each number:
            print(find_optimal(input$N,input$sample))
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
