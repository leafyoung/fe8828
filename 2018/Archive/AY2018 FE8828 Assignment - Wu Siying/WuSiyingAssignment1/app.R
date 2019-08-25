library(shiny)
library(ggplot2)
#Wu Siying G1800345C

ui<-fluidPage(
  
  titlePanel("Welcome to SY Audio Store!"),
  
  navbarPage(title = "SY Audio Store",
             
    tabPanel(title = "Headphones",
      fluidRow(
        column(3,
            h3("Are you looking for a pair of headphone that is: "), 
            
            checkboxInput(inputId = "portability", label = "portable"),
            checkboxInput(inputId = "fashion", label = "fashionable"),
            checkboxInput(inputId = "soundQuality", label = "of ultimate sound quality"),
            checkboxInput(inputId = "value", label = "of great value"),
            br(),
            h4("Recommended headphones for you:"),
            
            conditionalPanel(condition = "input.portability == 1",
                             h5("- MDR-1A enables you to enjoy music on-the-go!")),
            conditionalPanel(condition = "input.fashion == 1",
                             h5("- Beats Solo makes you look great when wearing your headphone!")),
            conditionalPanel(condition = "input.soundQuality == 1",
                          h5("- HD800 brings ultimate enjoyment to your ears!")),
            conditionalPanel(condition = "input.value == 1",
                          h5("- Valore Melo-tune headset sounds great if you are on a budget!"))
            ),
        
      column(7, 
             tabsetPanel(id = "headphones", type = "tabs",
                         tabPanel(title = "SONY MDR-1A", 
                                  h1("MDR-1A"),
                                  img(src ='Capture1A.jpg', width = "80%"),
                                  
                                  tags$ol("MDR1A Description",tags$li("Enjoy fine acoustics from a large driver and earcups that seal comfortably around your ears."),
                                          tags$li("Hear deep lows and euphoric highs with a full range of sound up to 100kHz."),
                                          tags$li("Play music loud and clear from any home system or portable device with high sensitivity of 105dB/mW.")),
                                  
                                  h5("Price: SGD 429.00"),
                                  
                                  checkboxInput("MDR1ACheckbox",label = "I am interested in this headphone!"),
                                  a("Link to purchase", href="https://www.sony.com.sg/electronics/headband-headphones/mdr-1a-headphones")),
                         
                         tabPanel(title = "SENNHEISER HD800", 
                                  h1("SENNHEISER HD800"),
                                  
                                  img(src ='HD800.jpg', width = "80%"),
                                  
                                  tags$ul("HD800 Description", tags$li("Reference class wired stereo headphones"),
                                          tags$li("Open, around-the-ear, dynamic stereo headphones"),
                                          tags$li("Natural hearing experience - realistic and natural sound field with minimal resonance")
                                          ),
                                  h5("Price: SGD 1790.00"),
                                  checkboxInput("HD800Checkbox",label = "I am interested in this headphone!"),
                                  a("Link to purchase", href="https://en-sg.sennheiser.com/high-resolution-headphones-3d-audio-hd-800-s")),
                  
                        tabPanel(title = "Beats Solo", 
                                 h1("Beats Solo"),
                                 img(src ='BEATS.JPG', width = "80%"),
                                 h5("With up to 40 hours of battery life, Beats Solo3 Wireless is your perfect everyday headphone. Get the most out of your music with an award-winning, emotionally charged Beats listening experience."),
                                 h5("Price: SGD 398.00"),
                                 checkboxInput("BeatsCheckbox",label = "I am interested in this headphone!"),
                                 a("Link to purchase", href="https://www.beatsbydre.com/sg/headphones/solo3-wireless")),
                       
                         tabPanel(id = "valore1", title = "Valore", 
                                 h1("Valore"),
                                 img(src ='Valore.jpg', width = "80%"),
                                 h5("Say hello to a well-fitting headset. Featuring a highly-optimised, ventilated headband and super soft ear cushions, put the music on and enjoy comfortably for hours at a go."),
                                 h5("Price: SGD 36.90"),
                                 checkboxInput(inputId = "ValoreCheckbox",label = "I am interested in this headphone!"),
                                 a("Link to purchase", href="https://www.hachi.tech/intelligent-living/audio/headphones/valore-melo-tune-music-headphone-hs0014-blue--6926934832781"))
               )),
                                          
      column(2,
            br(),br(),br(),br(),br(),br(),br(),br(),
            h1("Total Price in SGD"),
            h1(uiOutput("total")),
            h5("(Select the checkbox below each item at the bottom of the tab to calculate the total price.)")
            ))),
#)  ),
  
    tabPanel(title = "Music Players",
           navlistPanel(#position = "right", 
                         #sidebarPanel(
                           tabPanel(title = "Sony NW-A50 Series", 
                                    h1("Sony NW-A50 Series"),
                                    img(src ='NWA50.JPG', width = "200px"),
                                    
                                    tags$ol("NW-A50 Description",tags$li("Experience the natural sound and intense detail of DSD audio formats, thanks to the NW-A50 Series' high-quality PCM conversion."),
                                            tags$li("Bring even heavily-compressed audio formats back to a full fidelity experience with our advanced DSEE HX processor, which uses AI to accurately analyse song type, instrumentation and musical genres. "),
                                            tags$li("Enjoy all the subtleties in your music with S-Master HXT which delivers High-Resolution Audio in maximum quality, with reduced distortion and noise.")),
                                    
                                    h5("Price: SGD 299.00"),
                                    a("Link to purchase", href="https://www.sony.com.sg/electronics/walkman/nw-a50-series")),
                           
                           tabPanel(title = "Sony NW-WM1Z", 
                                    h1("Sony NW-WM1Z"),
                                    img(src ='WM1Z.JPG', width = "400px"),
                                    
                                    tags$ol("NW-WM1Z Description",tags$li("Elevating the high-resolution sound experience from one you listen to, to one you can feel."),
                                            tags$li("Delivering every note as the artist intended with High-Resolution Audio"),
                                            tags$li("Operating the NW-WM1Z Walkman will become second nature thanks to the device's intuitive usability and real life-optimised features. ")),
                                    
                                    h5("Price: SGD 3,999.00"),
                                    a("Link to purchase", href="https://www.sony.com.sg/electronics/walkman/nw-wm1z"))
                         )),
  
    navbarMenu(title = "About",
             tabPanel(title = "About SY Audio Store", 
                      h1("About SY Audio Store"), 
                      h4("SY Audio Store gives you recommendations on the best headphones and audio equipments available in the market and offers you the best price. The shop owner, Siying, is an audiophile who is currently studying in NTU.")),
             tabPanel(title = "About the website", h1("About the Website"), h4("The website is prepared for FE8828 Programming Web Applications in Finance by Wu Siying (G1800345C). "),h4("Pictures and product descriptions are taken from the Internet and repective company websites."))
  )
  ))
#Calculator<- tabPanel("a calculator", h1("You are interested in the following items and they are worth"))


server <- function (input, output){
  output$total <- renderText({input$ValoreCheckbox * 36.9 + 
    input$BeatsCheckbox*398 + 
    input$HD800Checkbox * 1790 + 
    input$MDR1ACheckbox*429
  })
}

shinyApp(ui=ui, server=server)