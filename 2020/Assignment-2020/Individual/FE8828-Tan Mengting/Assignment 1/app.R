#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# This Web application is for TMT Cosmetic Company to show its products, promotion activities and store information to customers.

library(shiny)

# Define UI for TMT Cosmetic 
ui <- fluidPage(

    navbarPage(title = "TMT Cosmetic",
               
               tabPanel("What We Have",
                        navlistPanel
                        (
                            widths = c(2, 10),
                            "Make Up",
                            tabPanel("Eyes",
                              fluidRow(
                                column(3,
                                       wellPanel(tags$h4(tags$strong("Eye Palette")),
                                                 tags$li("$50.00"),
                                                 tags$img(src = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3874780091,4207854146&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                                 tags$br(),
                                                 tags$br(),
                                                 tags$li("$60.00"),
                                                 tags$img(src = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3759340092,3179204543&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                                 tags$br(),
                                                 tags$br(),
                                                 tags$li("$90.00"),
                                                 tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3751179765,2830653829&fm=26&gp=0.jpg",width="70%",hight="auto")
                                                 
                                       )
                                ),
                                column(3,
                                       wellPanel(tags$h4(tags$strong("Eye Liner")),
                                                 tags$li("$7.00"),
                                                 tags$img(src = "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2050438961,4199252127&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                                 tags$br(),
                                                 tags$br(),
                                                 tags$li("$20.00"),
                                                 tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=224861387,171595201&fm=15&gp=0.jpg",width="70%",hight="auto"),
                                                 tags$br(),
                                                 tags$br(),
                                                 tags$li("$15.00"),
                                                 tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1670375411,1643222053&fm=15&gp=0.jpg",width="70%",hight="auto")
                                       )
                                ) 
                              )
                            ),
                            tabPanel("Lips",
                              fluidRow(
                                column(3,
                                     wellPanel(tags$h4(tags$strong("Lip Stick")),
                                               tags$li("$40.00"),
                                               tags$img(src = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3015833627,1974858248&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                               tags$br(),
                                               tags$br(),
                                               tags$li("$70.00"),
                                               tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2288119890,2508852190&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                               tags$br(),
                                               tags$br(),
                                               tags$li("$40.00"),
                                               tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3509682684,3756344098&fm=26&gp=0.jpg",width="70%",hight="auto")
                                     )
                                ),
                                column(3,
                                     wellPanel(tags$h4(tags$strong("Lip Glossr")),
                                               tags$li("$65.00"),
                                               tags$img(src = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3196034366,2583993827&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                               tags$br(),
                                               tags$br(),
                                               tags$li("$75.00"),
                                               tags$img(src = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=835551748,481282437&fm=26&gp=0.jpg",width="70%",hight="auto")
                                     )
                               )
                              )
                            ),
                  
                                   
                            "Skincare",
                            tabPanel("Cleansers",
                              fluidRow(
                                column(3,
                                     wellPanel(tags$h4(tags$strong("Cleaner")),
                                               tags$li("$70.00"),
                                               tags$img(src = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1525933983,1051766212&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                               tags$br(),
                                               tags$br(),
                                               tags$li("$30.00"),
                                               tags$img(src = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3306412467,2597725226&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                               tags$br(),
                                               tags$br(),
                                               tags$li("$20.00"),
                                               tags$img(src = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3541791811,3583197122&fm=26&gp=0.jpg",width="70%",hight="auto")
                                     )
                                ),
                                column(3,
                                     wellPanel(tags$h4(tags$strong("Makeup Remover")),
                                               tags$li("$40.00"),
                                               tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1135469901,2794617705&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                               tags$br(),
                                               tags$br(),
                                               tags$li("$50.00"),
                                               tags$img(src = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3841404853,1493278430&fm=26&gp=0.jpg",width="70%",hight="auto")
                                     )
                               )
                              )
                            ),
                            tabPanel("Suncare",
                                     fluidRow(
                                       column(3,
                                              wellPanel(tags$h4(tags$strong("Suncare")),
                                                        tags$li("$35.00"),
                                                        tags$img(src = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3196962039,2253001664&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                                        tags$br(),
                                                        tags$br(),
                                                        tags$li("$25.00"),
                                                        tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2233100628,2504224966&fm=26&gp=0.jpg",width="70%",hight="auto")
                                              )
                                       )
                                     )
                            ),
                            
                            "Tools",
                            tabPanel("Brushers",
                                     fluidRow(
                                       column(3,
                                              wellPanel(tags$h4(tags$strong("Brush Set")),
                                                        tags$li("$40.00"),
                                                        tags$img(src = "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1206027746,2080586378&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                                        tags$br(),
                                                        tags$br(),
                                                        tags$li("$20.00"),
                                                        tags$img(src = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1384279905,157468016&fm=26&gp=0.jpg",width="70%",hight="auto")
                                              )
                                       )
                                     )
                            ),
                            tabPanel("Combs",
                                     fluidRow(
                                       column(3,
                                              wellPanel(tags$h4(tags$strong("Comb")),
                                                        tags$li("$2.00"),
                                                        tags$img(src = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2089490065,2299686066&fm=26&gp=0.jpg",width="70%",hight="auto"),
                                                        tags$br(),
                                                        tags$br(),
                                                        tags$li("$4.00"),
                                                        tags$img(src = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2864632463,423421246&fm=26&gp=0.jpg",width="70%",hight="auto")
                                              )
                                       )
                                     )
                            )
                          
                        )
               ),
               
               tabPanel("Promotion",
                        fluidPage(
                            sidebarLayout(
                                sidebarPanel(
                                  tags$h2("Promotion Activity"),
                                  tags$ul(tags$strong("Coupons"),
                                    tags$li("$10 Coupon with min. $50 spend"),
                                    tags$li("$20 Coupon with min. $75 spend"),
                                    tags$li("$30 Coupon with min. $100 spend"),
                                    tags$br(),
                                    tags$em("Please note:"), 
                                    tags$p("Coupon codes, email coupon codes and online promotion codes can not be applied towards any products already on sale.
                                            Unfortunately, we can ONLY honor ONE promotion per order. By using a coupon, promotional code, coupon code, or any special offer provided by TMT Cosmetic, you agree to these terms.
                                            If you have any questions please contact us at TMT Cosmetic!
                                            400-170-5800 or mail@tmt_cosmetic.com")
                                  ),  
                                  
                                  tags$br(),
                                  tags$ul(tags$strong("Special DAYS"),
                                    tags$li("SEP 27 L'OREAL PARIS 3 FOR 30% OFF"),
                                    tags$li("OCT 1 FREE DELIVERY DAY"),
                                    tags$br(),
                                    tags$em("Please note:"),
                                    tags$p("When we are running the free delivery promotion on OCT 1, customers that are located in same country with our stores, 
                                         and whose order meets a minimum of $100  are eligible for free delivery. During this promotional period, 
                                         all online orders placed that are within the free delivery radius for a selected store and meet the minimum $100 order value, 
                                         will automatically have their delivery fees updated to $0 via the product cart or at checkout. TMT Cosmetic reserves the right to adjust the free delivery radius, minimum order value or end a Free Delivery promotion at any time.")
                                  )
                              ),
                              mainPanel( 
                                h2("SAVE while SHOPPING!"),
                                tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1349892565,160330733&fm=26&gp=0.jpg",wdith="100%"),
                                tags$br(),
                                h2("SHOP on SEP 24! - GET 3 L'OREAL PARIS FOR 30% OFF "),
                                tags$img(src = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=230401353,1385129241&fm=26&gp=0.jpg",width="50%"),
                                tags$br(),
                                h2("Enjoy FREE SHIPPING on OCT 1"),
                                tags$img(src = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3342169191,2509830416&fm=26&gp=0.jpg", width="50%")
                                )
                         )
                      )
               ),
               
               tabPanel("Find Our Store", fluid = TRUE,
                        titlePanel("Find Us!"),
                        fluidRow(
                            column(4,
                                   wellPanel(h2("China"),
                                             tags$li(tags$strong("Beijing, 138 Wangfujing Road")),
                                             tags$img(src = "https://news.cgtn.com/news/346b544e34637a4d7849544e3145544d35597a4e31457a6333566d54/img/4973b7be40cd426a94ce606a5c024187/4973b7be40cd426a94ce606a5c024187.jpg",width="100%",hight="auto"),
                                             tags$br(),
                                             tags$br(),
                                             tags$li(tags$strong("Shanghai, 300 Nanjing Zhong Road")),
                                             tags$img(src = "https://live.staticflickr.com/1734/27744263537_e6fca861e4_b.jpg",width="100%", hight="auto" )
                                             
                                   )
                            ),
                            column(4,
                                   wellPanel(h2("Singapore"),
                                             tags$li(tags$strong("Jewel Chiangi Airport, 78 Airport Boulevard ")),
                                             tags$img(src = "https://images.unsplash.com/photo-1555830717-bb77c94de724?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",width="100%", hight="auto" )
                                   )
                            ),
                            column(4,
                                   wellPanel(h2("Korea"),
                                             tags$li(tags$strong("Seoul, 13 Yeouigongwon-ro, Yeongdeungpo-gu")),
                                             tags$img(src = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1745468363,3696236684&fm=26&gp=0.jpg",width="100%", hight="auto" )
                                   )
                            )                          
                        )
               )
                   
                
    )
)

server <- function(input, output) { }
shinyApp(ui = ui, server = server)
