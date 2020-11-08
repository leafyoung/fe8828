library(shiny)

ui <- fluidPage(
    fluidPage(
        navbarPage(title = "Entry into Kitchen",
                   
                   # page 1: introduce the company
                   tabPanel("About Us",
                            #part 1: slogan
                            titlePanel("Live for love and love for food!"),
                            
                            #part 2: dishes show
                            fluidRow(
                                column(4,
                                       img(src = "aboutus-1.jpg", width = "90%")
                                ),
                                
                                column(4,
                                       img(src = "aboutus-2.jpg", width = "90%")
                                ),
                                
                                column(4, 
                                       img(src = "aboutus-3.jpg", width = "90%")
                                )
                                ),
                            
                           #part 3: introduce the firm briefly 
                           navlistPanel(
                               "About Us",
                               tabPanel(h3("Who are we"), 
                                        h1("Who are we"),
                                        p(h2("Here is a community for sharing food recipes and a new e-commerce platform.")),
                                        h3(a("Click here to know more about us!", href="https://www.xiachufang.com"))),
                               tabPanel(h3("What we do"),
                                        h1("What we do"),
                                        p(h2("Our aim is to let kitchen novices learn to make good dishes at home!"))),
                               
                              "Have A Try",
                               tabPanel(h3("Most popular this week"),
                                        tags$ul(h1("Most popular this week"),
                                                tags$li(h2(a("Mushroom with garlic paste", href="https://www.xiachufang.com/recipe/105909485/"))),
                                                tags$li(h2(a("Braised beef with brown sauce", href="https://www.xiachufang.com/recipe/105834770/"))),
                                                tags$li(h2(a("Mashed potato salad sandwich", href="https://www.xiachufang.com/recipe/105917190/"))),
                                        )),
                               tabPanel(h3("Rookie recipes"),
                                        h1("Rookie recipes"),
                                        "------"),
                               tabPanel(h3("New creations"),
                                        h1("New creations"),
                                        "------"),
                               "-----"
                               
                           )
                   ),
                        
                          
                            
                   
                   tabPanel("Community", 
                            titlePanel("Come on! Show your work!"),
                            
                            
                            
                            fluidRow(
                                column(12,
                                       wellPanel(h2("Blue Chimney - Zephyl deep-Sea squid seed pasta"),
                                                 h3("author: 树叶shuye" ),
                                                 tags$p("This is cooked plate products: pasta Q play strength, squid seed sauce taste fragrant delicious, really very authentic, two instant shrimp to match also pretty is artistic conception, let a person eat well meet yet ╰ ´ (* ︶ ` *) ╯ it is worth mentioning that a plane is a large full after boiled, eating small girls may like me half of the is enough, is all right for the boys weight may ~")
                                       )),),
                            
                            tags$img(src = "page2-1.jpg", width = "50%"),
                                
                            fluidRow(    
                                column(12,
                                       wellPanel(h2("Scallion pancakes"),
                                                 h3("author: 下山虎虎" ),
                                                 tags$p("I especially like to bake this kind of cake, which in Xi 'an can also be called a pot helmet. The main thing is to save trouble and be quick to eat. A dough pancake is baked directly into a big cake. No scallions or salt, just the way it is. High gluten gluten or gluten can be low gluten, no strict requirements. Don't be afraid. The dough will be easy to operate if you leave it to rest for a while. You can also use more dry powder to prevent it from sticking. This kind of cake is very soft and delicious.")
                                       )), ),
                            
                            tags$img(src = "page2-2.jpg", width = "80%")
                            
                   ),
                   
                   
                   
   
                   navbarMenu(title = "Contact Us",
                              
                              tabPanel("Cooperation", 
                                       tags$ul(h1("Cooperation"),
                                              tags$li(h2("Electrical business cooperation"),
                                                      h3("If you would like to enter the kitchen market, please contact: parter@xiachufang.com")),
                                              tags$li(h2("Advertising cooperation"),
                                                      h3("If there is a need for advertising and business cooperation, please contact: ad@xiachufang.com")),
                                              tags$li(h2("Market cooperation"),
                                                      h3("If you want to cooperate in the market, or have interview needs, please contact: marketing@xiachufang.com")),
                                              tags$li(h2("Rights and interests protection"),
                                                      h3("If your original recipe is stolen, or text large copy, please contact: protect@xiachufang.com, 010-52800126")),
                                              tags$li(h2("Feedback about problems"),
                                                      h3("If you need feedback or ask for help, you can contact us in the following ways: talk@xiachufang.com"))
                                              )),
                                           
                                       
                              tabPanel("Access to app", 
                                       tags$ul(h1("Access to app"),
                                              tags$li(h2("Apple store"),
                                              tags$li(h2("Android：Myapp"),      
                                                      )),     ))
                   
                   
                   
                              )
    )
    
))

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


