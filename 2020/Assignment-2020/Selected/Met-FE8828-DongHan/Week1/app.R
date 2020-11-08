library(shiny)
library(ggplot2)

ui <- fluidPage(
    fluidPage(navbarPage(title = "DongHan's Grocery Store",
                        
                         #Product List
                         tabPanel("Brose Products",
                                  titlePanel("Categories"),
                                  textInput("text", label = "Search", value = "Search Products..."),
                                         
                                
                                  navlistPanel(
                                      "Meat & Seafood",
                                      tabPanel("Chicken",
                                               tags$a(href="https://foodpoisoningbulletin.com/wp-content/uploads/Raw-Chicken-2.jpg", 
                                                      tags$img(src="https://foodpoisoningbulletin.com/wp-content/uploads/Raw-Chicken-2.jpg", 
                                                               title="Chicken", 
                                                               width="300",
                                                               height="200")
                                               ),
                                               h3("Raw Whole Chicken - $3"),
                                               numericInput(inputId = "1", label = "Quantity", value = "1"),
                                               submitButton(text = "Add to Basket")
                                      ),
                                      tabPanel("Pork",
                                               tags$a(href="https://www.chicagowholesalemeats.com/wp-content/uploads/2019/06/pork-belly-skin-on.jpg", 
                                                      tags$img(src="https://www.chicagowholesalemeats.com/wp-content/uploads/2019/06/pork-belly-skin-on.jpg", 
                                                               title="Pork Belly", 
                                                               width="300",
                                                               height="200")
                                               ),
                                               h3("Pork Belly - $5 (500g)"),
                                               numericInput(inputId = "1", label = "Quantity", value = "1"),
                                               submitButton(text = "Add to Basket")
                                      ),
                                      tabPanel("Beef & Lamb",
                                               fluidRow(
                                                   column(5,
                                                          tags$a(href="https://cdn.shopify.com/s/files/1/2181/5655/products/chuck_crop_2018_web_2000x.png?v=1600104400", 
                                                                 tags$img(src="https://cdn.shopify.com/s/files/1/2181/5655/products/chuck_crop_2018_web_2000x.png?v=1600104400", 
                                                                          title="Beef", 
                                                                          width="300",
                                                                          height="200")
                                                          ),
                                                          h3("Beef - $7 (500g)"),
                                                          numericInput(inputId = "1", label = "Quantity", value = "1"),
                                                          submitButton(text = "Add to Basket")
                                                   ),
                                                   column(5,
                                                          tags$a(href="https://www.foodsafetynews.com/files/2019/12/veal-cutlet-550x312.jpgg", 
                                                                 tags$img(src="https://www.foodsafetynews.com/files/2019/12/veal-cutlet-550x312.jpg", 
                                                                          title="Lamb", 
                                                                          width="300",
                                                                          height="200")
                                                          ),
                                                          h3("Lamb - $8 (500g)"),
                                                          numericInput(inputId = "1", label = "Quantity", value = "1"),
                                                          submitButton(text = "Add to Basket")
                                                   ),
                                               ),
                                      ),
                                      
                                      tabPanel("Fish & Seafood",
                                               h4("Out of Stock")),
                                      "Fruits & Vegetables",
                                      tabPanel("Fruits",
                                               fluidRow(
                                                   column(5,
                                                          tags$a(href="https://s3.amazonaws.com/finecooking.s3.tauntonclud.com/app/uploads/2017/04/24171743/ING-pineapple.jpg", 
                                                                 tags$img(src="https://s3.amazonaws.com/finecooking.s3.tauntonclud.com/app/uploads/2017/04/24171743/ING-pineapple.jpg", 
                                                                          title="Pineapple", 
                                                                          width="300",
                                                                          height="200")
                                                          ),
                                                          h3("Pineapple - $2 (1Kg)"),
                                                          numericInput(inputId = "1", label = "Quantity", value = "1"),
                                                          submitButton(text = "Add to Basket")
                                                   ),
                                                   column(5,
                                                          tags$a(href="https://images-na.ssl-images-amazon.com/images/I/61Pvv15Jo2L._SL1000_.jpg", 
                                                                 tags$img(src="https://images-na.ssl-images-amazon.com/images/I/61Pvv15Jo2L._SL1000_.jpg", 
                                                                          title="Guava", 
                                                                          width="300",
                                                                          height="200")
                                                          ),
                                                          h3("Guava (Pink) - $3 (1Kg)"),
                                                          numericInput(inputId = "1", label = "Quantity", value = "1"),
                                                          submitButton(text = "Add to Basket")
                                                   ),
                                               ),
                                      ),
                                      
                                      tabPanel("Vegetables",
                                               fluidRow(
                                                   column(5,
                                                          tags$a(href="https://www.irishtimes.com/polopoly_fs/1.3967277.1564062363!/image/image.jpg_gen/derivatives/ratio_1x1_w1200/image.jpg", 
                                                                 tags$img(src="https://www.irishtimes.com/polopoly_fs/1.3967277.1564062363!/image/image.jpg_gen/derivatives/ratio_1x1_w1200/image.jpg", 
                                                                          title="Potato", 
                                                                          width="300",
                                                                          height="200")
                                                          ),
                                                          h3("Potato - $1.5 (1Kg)"),
                                                          numericInput(inputId = "1", label = "Quantity", value = "1"),
                                                          submitButton(text = "Add to Basket")
                                                   ),
                                               ),
                                               
                                               )
                                      )
                                  ),
                         
                         tabPanel("Basket",
                                  sidebarLayout(
                                      sidebarPanel(
                                          radioButtons("time", "Select your desired time slot:",
                                                       c("Morning (8:00-12:00)" = "morning",
                                                         "Afternoon (12:01-18:00)" = "afternoon",
                                                         "Evening (18:01-22:00)" = "eve"))
                                      ),
                                      mainPanel(
                                          titlePanel("These products are in your basket"),
                                          h4("Empty"),
                                          submitButton(text = "Check-out"),
                                          plotOutput("distPlot")
                                          
                                          
                                      )
                                  )
                                  
                         ),
                         
                         
                         # Contact Page
                         tabPanel("Contact Us",
                                  align="center",
                                  titlePanel("Reach out to us!"),
                                  h4("Contact: 1234 5678"),
                                  h4("Address: 1 Marina Bay Road, Singapore 123456"),
                                  "-----",
                                  h3("We would like your feedback!"),
                                  div(
                                      align="center",
                                      column(12,
                                             textInput("text", h4("Email"), value = "Enter your email address here"), 
                                             textInput("text", h4("Suggestions"), value = "Enter your suggestions here"), 
                                             submitButton(text = "Submit")
                                      )
                                
                                  ),
                         )
                                 
    )
    )
)



# Define server logic required to draw a histogram
data <- c(20, 10, 15, 20, 30, 20, 40)
label <- c("Jurong East", "Clementi", "Kent Ridge", "Bishan", "Expo", "CBD", "Punggol")

server <- function(input, output) {
    output$distPlot <- renderPlot({
        barplot(data, 
                names.arg = label,
                main = "Estimated Delivery Time",
                ylab="Time (Mins)",
                xlab="Location")
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
