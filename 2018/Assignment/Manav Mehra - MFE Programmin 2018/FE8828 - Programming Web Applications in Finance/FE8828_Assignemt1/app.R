#install.packages("shinyThemes")
#install.packages("slickR")
#install.packages("bsplus")
library(shiny)
library(shinythemes)
library(slickR)
library(bsplus)
ui <- fluidPage(
  fluidPage(theme = shinytheme("spacelab"),
    navbarPage(title = "MMRJ Music",
               tabPanel("Product", img(src = "MMRJ Logo.png", width="200px", height="200px", 
                                       style="display:block; margin-left:auto; margin-right:auto"),
                        titlePanel(HTML('<marquee behavior="scroll" direction="left" scrollamount="10" style="animation:marquee linear infinite">
                                        MMRJ Music - The Online Hub for Upcoming Musicians
                                        </marquee>')),
                        fluidRow(
                          column(6,
                                 p("Welcome to MMRJ Music. We provide a range of music related Services.
                          You can read more about these by clicking on the 'Services Offered'
                          tab. Feel free to contact us or come drop by to learn more about us.", 
                                   style="padding-top:50px; padding-left:50px; font-size:14pt;"),
                                 p(tags$b(tags$em("Open Daily: 8am - 10pm")),
                                   style="padding-left:50px; padding-top:50px; color:red;
                                   font-size:14pt;"
                                 )
                                 
                          ),
                          column(6,
                                 h3("Promotions", align="center"),
                                 tags$div(slickROutput("slickr", width="350px", height="280px"),
                                   align="center", style="margin-bottom:50px;")
                          )
                        )
                        ),
               tabPanel("Services Offered",
                        tags$h2("Hello music enthusiasts"),
                        tags$p("MMRJ is the one stop solution for any music related 
                               needs. We provide the following services. Click on any 
                               of them to learn more."),
                        fluidRow(
                          column(4,
                                 h3("Music Academy", style="text-align:center;"),
                                 wellPanel(a(href="#academy_details", 
                                             img(src="music_school.jpg", 
                                                 width="400px", height="400px"))
                           )
                          ),
                          column(4,
                                 h3("Music Editing", style="text-align:center;"),
                                 wellPanel(a(href="#music_editing_services", 
                                             img(src="music_editing.jpg", 
                                                 width="400px", height="400px"))
                                           )
                          ),
                          column(4, h3("Instrument Store", style="text-align:center;"),
                                 wellPanel(a(href="#online_and_physical_instument_store", 
                                             img(src="instrument_store.jpg", 
                                                 width="400px", height="400px"))
                                           )
                          )
                        )
               ),
               tabPanel("Contact Us",
                 fluidPage(
                   navlistPanel(
                     tabPanel("Address",
                              fluidRow(
                                column(6,
                                       h1("Reach Us", align="right"),
                                       p("MMRJ Music", br(), "48 Nanyang Crescent", br(), 
                                       "Nanyang Technological University", br(), 
                                       "Singapore - 637121", style="padding-top:100px; 
                                       text-align:right; font-size:12pt;")
                                       ),
                                column(6,
                                       wellPanel(div(img(src="map_loc.png", 
                                                     width="380px", height="380px")),
                                                 style="margin-bottom:180px;"
                                       )
                                )
                              )
                      ),
                     tabPanel("Email and Phone",
                              h1("Contact Us"),
                              div(
                                p(tags$b(tags$em("Email: inquire@MMRJ.com.sg")), 
                                  style="font-size: 18pt;"),
                                p(tags$b(tags$em("Phone: +65 8674-2898")), 
                                  style="font-size: 18pt;"), style="margin-bottom:450px;" 
                              )),
                     tabPanel("FAQ",
                              h1("FAQs"), 
                              bs_accordion(id = "faqs") %>%
                                bs_append(title = "Do I need a piano at home to take piano lessons?", 
                                          content = "It is ideal if you do have a piano at home, but you can 
                                          start lessons with our piano teachers by using an electric keyboard 
                                          to practice on at home. Most of our students rent or buy small electric
                                          keyboards to practice on at home. We recommend a keyboard that 
                                          has a minimum of 61 regular sized keys, a sustain pedal, and a touch
                                          sensitive response. A touch sensitive keyboard means if you press a key
                                          harder it will play louder and if you press a key softer it will play quieter.") %>%
                                bs_append(title = "How long does it take to learn an instrument?", 
                                          content = "There is no set answer of how long it takes to learn an 
                                          instrument. This varies from student to student and really depends
                                          on the individual, how much practicing you do and your age. Playing
                                          is a physical skill so it does take repetition to improve. With regular
                                          practice a basic level of playing can be accomplished within a few months.
                                          Most of our students take lessons on a long term basis because they want
                                          to be constantly improving and they find the lessons enjoyable.") %>%
                                bs_append(title = "Can I interview a teacher before I begin lessons?", 
                                          content = "Our teachers are highly educated, experienced and licensed
                                          professional instructors. Each instructor has already been properly
                                          screened and has been very carefully chosen for their skills and abilities.
                                          Our job is to give you best music education possible, in order to do this
                                          our instructors are required to focus solely on teaching. For that reason,
                                          it is not in the instructor’s job description, nor in our policies, to be
                                          interviewed by prospective students or parents.") %>%
                                bs_append(title = "Are the teachers qualified?", 
                                          content = "Yes. All of our teachers are highly qualified professionals
                                          and many have extensive performance experience. All instructors are
                                          required to be licensed, university or college degreed in the programs
                                          and instruments they teach. Our teachers are experienced teachers and are
                                          chosen not only for their qualifications, but for their ability to relate
                                          to the students.")%>%
                                bs_append(title = "Can we take lessons every other week instead of every week?", 
                                          content = "It is very important that the teacher checks your progress and
                                          corrects your form every week, because of this, we only offer weekly lessons.
                                          In addition, it is impossible for us to find a student to fill the hole that
                                          is created on the weeks you are not here.")%>%
                                bs_append(title = "How much practice should my child do each week?", 
                                          content = "We recommend a minimum of 15 minutes per day, six day’s per week.
                                          Although this is the absolute minimum recommendation, students will progress
                                          faster and remember more if they are able to practice more often. Short practice
                                          sessions done several times per day, every day, works out much better than longer
                                          practice sessions a few times per week. For young children, the practicing goes
                                          much better if the parent supervises.")%>%
                                bs_append(title = "How much does it cost to ship my order?", 
                                          content = "Once you add a product to your shopping cart, you will have
                                          the ability to view the shipping charges.")%>%
                                bs_append(title = "I want to buy your product but do not live in Singapore, how should i buy it?",
                                          content = "Our stores do not ship internationally through our website. Not
                                          all stores and/or product will ship internationally and the 
                                          decision to do so is definedby the individual franchise locations.")%>%
                                bs_append(title = "How do I find the best deals on your website?", 
                                          content = "Look for products with the red tag “price reduction” or the
                                          yellow tag “special price.” You can also use our advanced search to 
                                          show products that ONLY have reduced prices!")%>%
                                bs_append(title = "How do I return a product that I purchased?", 
                                          content = "Please visit our Return Policy page")%>%
                                bs_append(title = "Can I pick up Online orders in-store?", 
                                          content = "Yes!  We offer 'in-store' pickup for purchases from our website.")%>%
                                bs_append(title = "Do you accept Paypal for purchases?", 
                                          content = "Yes, Some stores accept PayPal as a form of payment.  The decision to 
                                          accept PayPal is defined by each individual franchise location."))
                   )
                 )
               )
    )
  ),
  tags$footer("MMRJ Music Pvt. Ltd.",br(), "Singapore", br(), "Trademark 2018", 
              style="height:60px; background:#eee; position:relative; left:0; bottom:0;
              right:0; margin-right:20px; margin-left:20px; text-align:center;")
  
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  output$slickr <- renderSlickR({
    imgs <- list.files("www/promos", pattern=".jpg", full.names = TRUE)
    slickR(imgs)
  })
}
# Run the application
shinyApp(ui = ui, server = server)