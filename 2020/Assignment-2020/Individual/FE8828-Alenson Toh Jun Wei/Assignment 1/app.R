library(shiny)

ui <- fluidPage(
    
    tags$head(
        tags$style( 
        "
              @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
              
              h2 {
                font-family: 'Lobster', cursive;
                font-weight: 500;
                line-height: 1.1;
                color: #ad1d28;
              }
              
              h3 {
                font-family: 'Lobster', cursive;
                font-weight: 300;
                line-height: 1.1;
                color: #ad1d28;
              }
              
              body {
                background-color: #fff;
              }")
    ),
    
    titlePanel("Nanyang Pizza"), 
    navlistPanel(widths = c(2, 9), # Shows the relative dimensions of panel and content
                 tabPanel("Products",
                          fluidRow( # Row-wise section
                              column(width = 9, # Column-wise section
                                     img(src="top_image.jpg", align = "center", height="100%", width="100%"), # Image
                                     h2("Products")),
                          ),
                          fluidRow(
                              column(width = 3,
                                     img(src="product_1.jpg", align = "center", height="100%", width="100%"),
                                     h3("THE BIG CHEESEZY PIZZA"),
                                     "Huge pizza cut into 8 extra-large slices. Authentic, soft & foldable 
                                          Italian-style dough, topped with Marinara pizza sauce & lots of stretchy mozzarella",
                                     hr(),
                                     tags$b("Order Now! Only for $20!")
                              ),
                              column(width = 3,
                                     img(src="product_2.jpg", align = "center", height="100%", width="100%"),
                                     h3("THE BIG PEPPERONI PIZZA"),
                                     "Huge pizza cut into 8 extra-large slices. Authentic, soft & foldable Italian-style dough, 
                                          topped with Marinara pizza sauce & lots of crispy American pepperoni with hints of fennel & chilli",
                                     hr(),
                                     tags$b("Order Now! Only for $24!")
                              ),
                              column(width = 3,
                                     img(src="product_3.jpg", align = "center", height="100%", width="100%"),
                                     h3("THE BIG HAWAIIAN PIZZA"),
                                     "Huge pie cut into 8 extra-large slices. Authentic, soft & foldable Italian-style dough, .
                                          topped with Marinara pizza sauce, smoky leg ham & sweet pineapple pieces",
                                     hr(),
                                     tags$b("Order Now! Only for $26!")
                              )
                          )
                 ),
                 tabPanel("About Us",
                          fluidRow(
                              column(width = 9,
                                     img(src="about_us.jpg", align = "center", height="100%", width="100%"),
                                     h2("About Us"),
                                     "For over 5 years, Nanyang Pizza has stayed true to its roots. Hardworking owners and staff, 
                                     family-friendly dining, and a high-quality product make us who we are. We take pride in the smile 
                                     that first bite of pizza gives our guests. We strive to make everyone feel as if this is their 
                                          hometown pizzeria.",
                                     hr())),
                          fluidRow(
                              column(width = 3,
                                     h3("Our Founder"),
                                     img(src="qilong.jpg", align = "center", height="100%", width="100%")),
                              column(width = 6,
                                     h3("History"),
                                     "Dejected from not securing a job after his graduation from Nanyang Business School's MSc Financial Engineering, 
                                          Nanyang Pizza's founder Charlie threw open the doors of the first Nanyang Pizza in Nex Serangoon, 
                                          in 2015 and became one of the most remarkable and impactful entrepreneurs and philanthropists of recent times.
                                          With it, he revolutionised Singapore's pizza restaurant scene forever, bringing casual dining to 
                                          the high street. Charlie travelled to Europe in the early 2010s, deciding to  
                                          settle in Milan; to learn how to make the best pizza in the world. Having fallen for the continental dining culture, 
                                          Charlie returned home, distraught to find that there was nowhere to buy a proper Italian pizza. 
                                          Ever an opportunist, he decided to make, sell and eat it himself.")
                          )
                 ),
                 tabPanel("Contact us",
                          fluidRow(
                              column(width = 4,
                                     img(src="contact_1.jpg", align = "center", height="100%", width="100%"),
                                     h2("NEX"),
                                     "23 Serangoon Central, #03-11/12/13, Singapore 556083, Phone: +65 6634 8015"),
                              column(width = 4,
                                     img(src="contact_2.jpg", align = "center", height="100%", width="100%"),
                                     h2("JEWEL CHANGI AIRPORT"),
                                     "78 Airport Blvd, #03 - 230, Singapore 819666, Phone: +65 6245 9522")
                          )
                 )
    )
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
