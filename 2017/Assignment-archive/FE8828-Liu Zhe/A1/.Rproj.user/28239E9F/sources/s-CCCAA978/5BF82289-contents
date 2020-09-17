
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage(title="Lockheed Technology",
  
  tabPanel("Home",
           fluidPage(
             titlePanel(img(src="ClarkV_131112_7708.jpg")),
           fluidRow(
             column(4,
                    h1("Innovative")),
             column(4,
                    h2("Futuristic")),
             column(4,
                    h3("Cutting Edge"))
           ))),
             
  navbarMenu(title="Products",
             tabPanel("Leopard 2A7+",
                      titlePanel("Leopard 2A7+"),
                      sidebarPanel("Leopard 2A7 has been designed for the German Military and is the most recent version of Leopard 2 design. 
                                    Talking about its qualities, Leopard 2A7 has additional armor and upgraded electronics. Leopard 2A7 is well protected against conventional and urban warfare threats such as RPG rounds and IEDs.
                                    Leopard 2A7 is MBT that is powered by a proven engine, developing 1,500 hp.Due to improved suspension component it has high mobility. Cross country performance is similar to Leopard 2 series tanks.
                                    Due to its powerful gun and advanced fire control system Leopard 2A7 has better accuracy and longer range of fire comparing with other tanks."),
                      img(src="Leopard-2A7-Germany-leak-photo.jpg")
                      ),
             tabPanel("Black Panther",
                     titlePanel("Black Panther"),
                     sidebarPanel("K2 Black Panther is one of the most advanced and expensive main battle tank of the world, designed for the Korean military.
                                   An Undisclosed type composite armor and explosive reactive armor modules are associated with K2 Black Panther. The K2 is also completed with active protection and countermeasures systems. Moreover it is much lighter MBT but its protection cover is very strong. This is the best military tanks in the world.
                                   Similar to that used on the Leopard 2A6 and 2A7, K2 Black panther is equipped with the latest German 120-mm gun. This tank has a very innovative fire control system without needing any input from a human operator it can spot, track and fire automatically at visible vehicle-size targets, even low-flying helicopters,. The K2 also uses advanced ammunitions.
                                   The Black Panther is built-in with a powerful diesel engine. It is fast and has a state-of-the-art hydro pneumatic suspension."),
                     img(src="K2-Black-Panther-South-Korea-leak-photo.jpg")
                      ),
             tabPanel("Challenger 2",
                      titlePanel("Challenger 2"),
                      sidebarPanel("Challenger 2 the MBT of United kingdom and a very capable tank. It has the latest Chobham shield and is one of the most protected MBTs in the world today. It offers very high level of shield against direct fire weaponries.
                                    The Challenger 2 is in facility with United Kingdom (386) and Oman (38).
                                    This British tank is equipped with a very accurate 120-mm rifled gun. Its gun is rifled as divergent to smoothbore guns used by all other modern MBTs. The maximum targeted range is over 5 km. Presently the Challenger holds the record for longest tank-to-tank kill.
                                    Challenger 2 has less powerful engine than of its Western rivals. Also it is not as profligate as other MBTs. However this tank is well-known for its automatic reliability."),
                      img(src="Challenger-2-United-Kingdom-leak-photo.jpg")
             ),
             tabPanel("Merkava MK4",
                      titlePanel("Merkava MK4"),
                      sidebarPanel("Merkava MK.4 the latest and most advanced MBT of Israel, which is a further advance to the Merkava Mk.3.
                                    The Merkava Mk.4 is one of the most protected best military tanks in the world. This MBT has a rare design with a front-mounted engine. This gives the crew additional protection and chance to survive if the tank is knocked-out. All Merkava series tanks have a hindmost compartment which ca be used to carry troops and cargo under shield. In unloaded condition Merkava MK.4 can carry up to 10 troops.
                                    The Israeli tank is equipped with original 120-mm smoothbore gun. The Merkava Mk.4 is armed with new fire control system that includes some very radical features. One of them is a high hit probability firing against low-flying helicopters using conventional weaponries."),
                      img(src="Merkava-Mk.4-Israel-leak-photo.jpg")
             ),
             tabPanel("T-90",
                      titlePanel("T-90"),
                      sidebarPanel("The T-90, only tank produced in quantity for Russia. It is not as refined as its Western rivals, however it uses verified technology and is cost operative. At present it is the most commercially successful main battle tank on the global market. Also it is one of the inexpensive among modern MBTs.
                                    The T-90 is not as accurate against long-range targets, however it can launch anti-tank guided missiles in the same manner as ordinary munitions.
                                    The T-90MS Tagil is a new version with new armor, new engine, new gun, improved turret, updated observation and aiming system."),
                      img(src="Nr.9-T-90-Russia-leak-photo.jpg")
             )),
             
  
  tabPanel("About us",
           navlistPanel(
             "Lockheed Technology",
             tabPanel("Mission",
                      h1("Headquartered in Singapore, Lockheed Technology is a global security company that is principally engaged in the research, design, development, manufacture, integration and sustainment of Amroured Tanks.")),
             tabPanel("History",
                      h2("On August 16, 2016, Chris Lockheed established the Lockheed Technology Company in Singapore. He started the company after building his first tank in his garage, where he took a leap of faith on his risky but innovative new tank design."))
           )),
  
  navbarMenu(title="Contact us",
             tabPanel("Address", "Address: 50 Nanyang Avenue, Block S4, Level B4, Singapore 639798"),
             tabPanel("Direct", "Direct: +65 6790.0000"),
             tabPanel("Email", "Email: Purchase_A_Tank@lockheedTechnology.com")
             )
)
)    

# Define server logic required to draw a histogram
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)

