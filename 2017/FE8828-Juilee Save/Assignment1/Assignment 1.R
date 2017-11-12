#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage( 
  fluidPage(
    titlePanel(img(src = "logo.png", height = 50, width = 100, hspace = "400" )),
    navbarPage(title = "WholeMeals", 
          tabPanel("Home",
                  titlePanel("Delicious & nutricious meals delivered to your doorstep"),
                  fluidRow(column(12,img(src = "WholeMeals.png", width = "100%"))),
                  hr(),
                  fluidRow(
                  column(4,wellPanel(h4("Customise Your Meal Plan"),h5("Be it weight-loss, bulking, low-cholestrol or gluten-free, 
                                                                       you get to choose the plan that suits your health goals."))),
                  column(4,wellPanel(h4("Local and International Selections"), h5("We have over 500 recipes from wide ranging cuisines, 
                                                                      including popular Asian and Western fares, so your tastebuds will never get bored. "))),
                  column(4,wellPanel(h4("Your Convenience, Delivered"), h5("Fresh meals prepared daily and delivered to your office or home
                                                                      in individually packed and microwave safe containers. ")))
                  )
          ),
          
          
          tabPanel("About Us",
                   navlistPanel(
                   tabPanel("Our Team",
                            wellPanel(
                              h3("Our Team"),
                              br(),
                              img(src = "chefs.png", width = "100%"),
                              br(),
                              h4("The WholeMeals team is comprised of excellent high level chefs and nutritionists. 
                                          We bring our decades of experience in catering, restaurants and fitness to the table 
                                          to create your well-balanced and tasty meals."))),                  
                    tabPanel("Our Mission",
                             wellPanel(
                              h3("Our Mission"),
                              br(),
                              img(src = "healthy.png", width = "100%"),
                              br(),
                              h4("With the hustle and bustle of modern lifestyle, your health often takes a backseat. 
                                          Our mission is to help you maintain a healthy lifestyle without compromising on the taste. 
                                          We want to dispel the myth that diets comprise of bland, boring meals."))),
                    tabPanel("Our Kitchen",    
                            wellPanel(
                               h3("Our Kitchen"),
                               br(),
                               img(src = "kitchen.png", width = "100%"),
                               br(),
                               h4("Our meals are prepared and packed in our specially designed kitchen, with procedures to 
                                            ensure hygiene, freshness and prevent cross-contamination. We count portion and label our
                                            meals so you don't have to.")))
                   )
          ),
             
                    
          navbarMenu(title = "Contact Us",                                       
                  tabPanel("Address", h4("Address"), "No. 29, Woodlands Industrial Park,", br()," E1 #04-17 Northtech", br(),"Singapore, 726811"),
                  tabPanel("Phone", h4("Phone"), "+65 9988 9988", br(), "+65 9999 9999"),
                  tabPanel("Email", h4("Email"), "customerservice@wholemeals.com")
                  )
          )
    )
  )





server <- function(input, output) {
}   

# Run the application
shinyApp(ui = ui, server = server)

