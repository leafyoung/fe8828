library(shiny)

ui <- fluidPage(
   
  navbarPage(title = "Technology",
             tabPanel("Product",
                      titlePanel(p("Next Generation Biometric Card",style="color:navy")),
                                
                      headerPanel(
                        column(8,offset=0,
                       tags$img(height=400,
                               width=1280,
                               src="https://www.freewebheaders.com/wordpress/wp-content/gallery/high-tech-designs/hi-tech-concepts-on-blue-background-header.jpg")
                               )
                       ),
                      
                      navlistPanel("",
                                   tabPanel("How it works",
                                            tags$p(),
                                            p("A cardholder enrolls their card by simply registering with their financial institution. Upon registration, the fingerprint
                                              is converted into an encrypted digital template that is stored on the card. The card is now biometrically activated
                                              with the cardholder's fingerprint template and ready to be used at any EMV card terminal globally."),
                                            p("When shopping and paying in-store, the biometric card works like any other chip card. The cardholder simply dips
                                              the card into a retailer's terminal while placing their finger on the embedded sensor. The fingerprint is verified
                                              against the template and - if the biometrics match - the cardholder is successfully authenticated and the
                                              transaction can then be approved with the card never leaving the consumer's hand."),
                                            tags$p(),
                                            fluidRow(column(3, offset=1, tags$img(height=400,
                                                                         width=600,
                                                                         src="https://securecdn.pymnts.com/wp-content/uploads/2017/04/Mastercard-Biometric-Card.jpg")))
                                            ),
                                   tabPanel("Benefits",
                                            h2("Enhanced Security"),
                                            tags$li("Registration with financial institution"),
                                            tags$li("Conversion of fingerprint into an encrypted digital template that is stored on the card"),
                                            tags$p(),
                                            h2("Convenience"),
                                            tags$li("Usage at any EMV card terminal globally")
                                            ),
                                    tabPanel("FAQs",
                                             tags$p(),
                                           p(tags$strong("Q1: I have heard that hackers can fool fingerprint sensors by transposing fingerprints onto silicon or other materials.
                                              Can this be done with the biometric card?")),
                                           p("It is not easy to place a 'fake' fingerprint onto the fingerprint sensor. Since the cards will be used in a card present
                                              environment the store clerk will be able to notice any potential criminal activity."),
                                           tags$p(),
                                           tags$p(),
                                           p(tags$strong("Q2: Are biometrics really more secure than PINs and signatures?")),
                                           p("Our cardholders have peace of mind knowing that payment security is in the DNA of our brand-so of course all our
                                            products are designed with security top of mind. And as a technology company, we're always looking at the most
                                             advanced technology to enhance the security of our products and services. The value of the biometric card is that it
                                             combines chip technology with a piece of who you are, building an additional layer of security with something that is
                                             not knowledge based.")
                                            )
                                    )
             ),
             
             tabPanel("About us",
                      titlePanel("Extraordinary People"),
                      fluidRow(
                        tags$p(),
                          column(3,offset=1,
                                 wellPanel(h3("CEO"),
                                           tags$img(height=200,
                                                    width=200,
                                                    src="https://wpclipart.com/people/male/men_5/man_smiling_retro.png"))
                          ),
                          column(3,offset=0,
                                 wellPanel(h3("CFO"),
                                           tags$p(),
                                           tags$img(height=200,
                                                    width=200,
                                                    src="http://shmector.com/_ph/4/477340182.png"))
                          ),  
                         column(3,offset=0,
                                wellPanel(h3("COO"),
                                          tags$p(),
                                          tags$img(height=200,
                                                    width=200,
                                                    src="https://cdn2.iconfinder.com/data/icons/lil-faces/241/lil-face-1-512.png"))
                         )
                      )
                      ),
             navbarMenu(title="Contact Us",
                        tabPanel("Address","Platform 9&3/4"),
                        tabPanel("Phone", "+999")
                        )
    )
)

server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

