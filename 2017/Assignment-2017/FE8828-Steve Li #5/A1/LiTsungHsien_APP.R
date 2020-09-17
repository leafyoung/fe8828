require(shiny)

myUi<-fluidPage(
  fluidPage(
  titlePanel(p("Divorce Consultant. Co",style="color:blue")),
  navbarPage(title="",
             tabPanel("Who We Are",
                      titlePanel("We help you to have divorce ceremony, and get ready for better future"),
                      sidebarPanel(tags$img(src="Divorce1.jpg",height=530,
                                              width=350
                                              )
                      
                      ),
                      p("The Divorce Consultant. Co is build by a group of financial engineer, data scientist
                        ,atheletes and party expert who enjoys life. By having teammember with
                        diverse background, we are going to deliver the world-class divorce consultant
                        service which help you to recover from the divorce and head to the new life. 
                        We promice your ex-wife/husband will be jealous to your new-born.  "),
                      strong("We deliver the best Single Again party"),
                             p("from party to divorce cocktail, to the follow up package, we will help to to 
                             prepare better future without him/her. Follow-up services include personal
                             fittness trainer, Yugo teacher half-year to build your good body shape 
                             and confidence. After you are ready, we will match your new dating mate by
                             using our new mathmatical algorithm base on BrownMotion and Stochastic 
                             calculus. This new algorithm calculate the different randon variable 
                             individuals and increase the probability to find future soul mate."),
                             br(),
                      tags$img(src="Party.jpg",height=350,
                               width=800
                      )
                             
                            ),
             
                             
  navbarMenu(title="Our Product", tabPanel("Divorce Ceremony&Party",fluidPage(
                                titlePanel("Divorce Ceremony&Party"),
                                navlistPanel(
                                
                                  tabPanel("Divorce Ceremony",
                                           h3("Divorce Ceremony is also a milestone in your life."),
                                           p("A Divorce Ceremony mindfully unbinds the emotional ties of a relationship 
                              in a way impersonal legal paperwork simply cannot possibly address. This unbinding of 
                              emotional ties supports individuals to embrace the future with hope and to step forward 
                              into a new chapter of their lives.A Divorce Ceremony can be a transformational part of 
                              the healing process, helping to acknowledge the good parts of the marriage and not to 
                              reject it outright. It’s important to remember that an ended marriage does not mean that 
                              the entire relationship was a failure. In virtually every marriage, no matter how 
                              dysfunctional,lie lessons and blessings."),
                                
                                tags$img(src="DivorceC.jpg",height=450,
                                         width=800
                                )
                                ),
                                
                                tabPanel("Single Again Party",
                                         h3("Let have party to celebrate your reborn."),
                                         p("Single Again Party help you to say goodbye to the past, and inform your 
                                           friends and relative to be single again. We will help you to design varoius
                                           party including boat party, swimmming party, BBQ party and Alcohol party.
                                           It is worthwhile to celebrate to be single again."),
                                         
                                         tags$img(src="Party1.jpg",height=450,
                                                  width=800
                                         )
                                )
                                )
                                )),
             
             tabPanel("Weight Training",fluidPage(
               titlePanel("Weight Training"),
               navlistPanel(
                 
                 tabPanel("Introduction",
                          h3("Let's help you to recover from divorce, and get six packs"),
                          p("By having weight training, we will have you to get back your good shape and 
                            become attractive again. All of us must know that there are many benefits to 
                            weight training.Studies have found exercise to have both physiological and 
                            psychological benefits. A Harvard study once found that ten weeks of strength 
                            training reduced clinical depression symptoms more successfully than counseling. 
                            Not happy? Then train. Need an instant mental and mood boost? Then train! The 
                            science is simple! You can get supper sexual, attractive and positive by weight training."),
                          
                          tags$img(src="Coach.jpg",height=450,
                                   width=800
                          )
                          )
                 )
             )),
                             tabPanel("Yoga",fluidPage(
                             titlePanel("Yoga"),
                             navlistPanel(
                              
                          tabPanel("Introduction",
                          h3("By Yoga training, you will be more attractive"),
                          p("Yoga is considered to be a low-impact activity that can provide the same benefits as 
                             any well-designed exercise program, increasing general health and stamina, reducing 
                             stress, and improving those conditions brought about by sedentary lifestyles. It is 
                            particularly promoted as a physical therapy routine, and as a regimen to strengthen 
                            and balance all parts of the body Yoga postures help to keep the body strong, toned 
                            and healthy. Because of this, they can help us achieve our weight and body shape goals, 
                            particularly the more dynamic styles of yoga. This can help give us a stronger body 
                            image and increased self-confidence – both of which can result in an increased libido.")),
                          
                          tags$img(src="Yoga.jpg",height=450,
                                   width=450
                          )
                          
                          )
                          )),
             
             tabPanel("Dating Arrangement",fluidPage(
               titlePanel("Dating Arrangement"),
               navlistPanel(
                 
                 tabPanel("Let's arrange a date",
                          h3("Let's help you get a new wife/husband "),
                          p("We provide an online dating website serving 25 countries and in more than 8 language
                            In 2016, we successfully math 5,000 couple, and half of them get married again."),
                          
                          tags$img(src="Date2.jpg",height=450,
                                   width=800
                          )
                 ),
               
              
                 
                 tabPanel("Strong ever Algorithm",
                          h3("How the algorithm works"),
                          p("The matching algorithm is built by the theory of Brown motion, Randon Walk, and
                            Stochastic process combined with the data science technique such as deep-learning
                            and numerical method from Carnegine Mellon University. Our algothrithm analyze the numeraious 
                            difference in people as random variable. The algorithm can optimize the probability 
                            to get most suitable future partner in the database and produce the optimal blue model"),
                          
                          tags$img(src="brown1.jpg",height=450,
                                   width=800
                          )
                          )
               
             )))
             
             ),
  
  
                      
  
  navbarMenu(title="Contact", tabPanel("Contact Detail",fluidPage(
    titlePanel("Contact Detail"),
    navlistPanel(
      
      tabPanel("Address&Phone",
               h3("Please do not hesitate to contact us"),
               p("Address: No 66 Nanyang Cresecnt. Tanjong Hall"),
               p("Phone: 65 92449999"),
               p("Emial: divorce_consultant@gmail.com"),
               
               tags$img(src="Northhill.jpg",height=450,
                        width=800
               )
               )))
  
  
  ))
  )))
                             
                             
                             myServer <- function(input, output){}
                             shinyApp(ui = myUi, server=myServer)
                             
                             