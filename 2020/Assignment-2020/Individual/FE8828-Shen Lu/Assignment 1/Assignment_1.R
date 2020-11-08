#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
        navbarPage(title = "Cat, Fun & Care",
                   tabPanel("Home",
                            fluidPage(titlePanel(h1("Cat Boarding & Grooming.", align = "center")),
                                      h4(""),
                                      wellPanel(fluidRow(column(6,
                                                                wellPanel(img(src="cat playing.jpg", width = "100%"),
                                                                          h4(""),
                                                                          h4("When cat boarding with Cat, Fun & Care, your cats will receive individualized care, enrichment and the best cat boarding Singapore has to offer to ensure your kitten or cat gets nothing but the best!")
                                                                          )
                                                                ),
                                                         column(6,
                                                                wellPanel(h4("---- Cat boarding services include personalized, kitten and cat enrichment activities, professional supervision, full attention overnight boarding with a Cat Behaviorist. Receive your personalized Cat Report Cards and pictures of your feline. While in our care, your cat receives calming classical music designed for felines, cat trees, high shelves, fun hiding spots, and a private room."),
                                                                          h3(""),
                                                                          h4("---- We offer kittens and cats a plethora of new cat toys and enrichment devices to enhance and to enrich their environment. Custom lighting catered to each cat, climate-controlled, fresh air ocean breeze and bright sunlit filled home. High perched window ledges, climbing places, with vertical space and shelving to accommodate bird watching, nature and cat entertainment.")
                                                                         )
                                                               )
                                                         )
                                                ),
                                      wellPanel(fluidRow(column(6,
                                                                 wellPanel(div(img(src="cat boarding.jpg", width = "70%"),style="text-align: center;"),
                                                                           h4(""),
                                                                           h4("Boarding", align = "center")
                                                                          )
                                                                 ),
                                                          column(6,
                                                                 wellPanel(div(img(src="cat grooming.jpeg", width = "70%"),style="text-align: center;"),
                                                                           h4(""),
                                                                           h4("Grooming", align = "center")
                                                                           )
                                                                 )
                                                          )
                                               ),
                                      mainPanel(h2("Cat Boarding Service"),
                                                h3(""),
                                                h3("Cat Boarding Hours:"),
                                                h4("Monday - Sunday = 10:00am - 4:00pm"),
                                                h5("(Pick up/Drop off)"),
                                                h3(""),
                                                h4("Weekday (Monday - Thursday) Rates: $40"),
                                                h5("(per night, per cat)"),
                                                h3(""),
                                                h4("Weekend (Friday - Sunday) Rates: $60"),
                                                h5("(per night, per cat)")
                                                )
                                      )
                            ),
                   tabPanel("Grooming Services",
                            fluidPage(titlePanel(h1("Feline Spa", align = "center")),
                                      sidebarPanel(h3("Cat, Fun& Care offers extensive salon services for your cat."),
                                                   h3(""),
                                                   tags$ul(tags$li(h4("We provide a quiet and calming environment in which to be pampered. Spa treatments are by appointment to allow us to focus on each cat's individual needs."))),
                                                   h3(""),
                                                   a(h4("New Groom Client Form and Questionnaire Here"), href = "http://www.californiacatcenter.com/online-forms"),
                                                   div(img(src = "After grooming.jpg", width = "80%"), style="text-align: center;")
                                                   ),
                                      mainPanel(wellPanel(
                                                          wellPanel(h2("Lion Cut", align = "center"),
                                                                    h2(""),
                                                                    fluidRow(column(5,
                                                                                    wellPanel(img(src = "Lion Cut.jpg", width = "100%"))),
                                                                             column(7,
                                                                                    wellPanel(h4("Hotter days are on the way and your kitty companion is likely already shedding his or her coat. If your kitty seems hot, or is tangled/matted and you'd like to help make them more comfortable as the summer approaches, a lion cut may be just what the doctor ordered!")))
                                                                            ),
                                                                    h3(""),
                                                                    fluidRow(column(3,
                                                                                    wellPanel(h4("Lion Cut", align = "center"), h4("$85", align = "center"))),
                                                                             column(3,
                                                                                    wellPanel(h4("Kitten Clip", align = "center"), h4("$70", align = "center"))),
                                                                             column(3,
                                                                                    wellPanel(h4("Shed Control", align = "center"), h4("$20", align = "center"))),
                                                                             column(3,
                                                                                    wellPanel(h4("Flea Control", align = "center"), h4("$20-25", align = "center")))
                                                                            ),
                                                                    fluidRow(column(3,
                                                                                    wellPanel(h4("Bath & Brush: Long-Hair", align = "center"), h4("$45", align = "center"))),
                                                                             column(3,
                                                                                    wellPanel(h4("Bath & Brush: Medium-Hair", align = "center"), h4("$35", align = "center"))),
                                                                             column(3,
                                                                                    wellPanel(h4("Bath & Brush: Short-Hair", align = "center"), h4("$25", align = "center"))),
                                                                             column(3,
                                                                                    wellPanel(h4("Soft Claws (Includes Nail Trim)", align = "center"), h4("$28", align = "center")))
                                                                            )
                                                                    )
                                                          )
                                                )
                                      )
                            ),
                   tabPanel("More Information",
                            titlePanel(h1("Cat Boarding & Grooming", align = "center")),
                            navlistPanel("More About the Boarding & Reservation",
                                         tabPanel("Our Cat Condos Amenities",
                                                  h2("Our Cat Condos Amenities"),
                                                  h4(""),
                                                  tags$ul(
                                                    tags$li(h4("Spacious area")),
                                                    tags$li(h4("Fresh water daily")),
                                                    tags$li(h4("Daily housekeeping")),
                                                    tags$li(h4("We provide Purina Brand dry cat food or if you wish you may supply your own")),
                                                    tags$li(h4("Relaxing music-filled atmosphere"))
                                                    )
                                                  ),
                                         tabPanel("I've made a booking. What next?",
                                                  h2("I've made a booking. What next?"),
                                                  h4("Once you have made a booking, we'll email your cat's full itinerary and any additional details."),
                                                  h4(""),
                                                  h3("Are any documents required before checking in my cat?"),
                                                  h4("At Cat, Fun & Care we want to protect your pet's health. We require that all pet's boarding with us have the following vaccinations preferably two weeks prior to boarding. A copy of your pet's vaccination records from a veterinarian is required upon check in:"),
                                                  h4(""),
                                                  tags$ol(
                                                          tags$li(h4("Current Rabies (within 12 months or 36 months)")),
                                                          tags$li(h4("Current Vaccination Certificate - our friendly staff can let you know what vaccinations your pets need")),
                                                          tags$li(h4("FVRCP: Also known as Feline Distemper, requires a composite vaccine that protects against a set of viruses; Feline Panleukopenia (Feline Distemper), Feline viral Rinotracheitis, Feline Calicivirus and Feline Chlamydiosis. Recommended for both indoor and outdoor cats and given according to your Vet's protocol.")),
                                                          tags$li(h4("Rabies Protects against a fatal viral disease that affects the central nervous system of all mammals-including humans. It is transmitted through bite wounds or scratches. Symptoms appear within 2-24 weeks, and after the onset of symptoms, death normally occurs within 2-7 days.")),
                                                          ),
                                                  p("All Shots must be current and we must have copies for your file of all shot records prior to boarding your pet.")
                                                  ),
                                         "Contact Information",
                                         tabPanel("Contact Information",
                                                  h2("Contact Information ---- Cat, Fun & Care"),
                                                  h4(""),
                                                  h3("If you'd like to set up a time to speak with us, we offer a Phone Consultation service. This is necessary, to make sure our service is viable, smooth, streamlined, and professional."),
                                                  h3(""),
                                                  tags$ul(
                                                    tags$li(h4("Address: 99 Jurong West Avenue, #06-08, Singapore")),
                                                    tags$li(h4("Phone: +65 1123 5813")),
                                                    tags$li(h4("Email: inquiries@point27.com"))
                                                         )
                                                  ),
                                         tabPanel("Working hours",
                                                  h2("Working hours"),
                                                  p("(barring holidays)"),
                                                  h3(""),
                                                  tags$ul(
                                                    tags$li(h4("Monday - Friday: 7:00 AM - 7:00 PM")),
                                                    tags$li(h4("Saturday - Sunday: 10:00 AM - 4:00 PM"))
                                                          )
                                                  )
                                        )
                            )
                )
)
    

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
