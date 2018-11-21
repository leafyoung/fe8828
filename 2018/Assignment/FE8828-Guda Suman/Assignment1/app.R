library(shinythemes)
library(shiny)
ui <- fluidPage(theme = shinytheme("superhero"),
  fluidPage(
    navbarPage(title = "GENX KNOWLEDGE ACQUISITION HUB",
               tabPanel("Products",
                            titlePanel("WELCOME TO GENX KNOWLEDGE ACQUISITION HUB"),
                            navlistPanel(
                              "VIEW TEXTBOOKS",
                              tabPanel("MATHEMATICS",
                                       a("Click here for Best Maths Books in each Section of Mathematics",href="https://mathblog.com/mathematics-books/"),
                                       img(src='calculus.jpg',width="27%",align="right"),
                                       h2("Calculus Books"),
                                       h3("The Calculus Lifesaver: All the Tools You Need to Excel at Calculus"),
                                       h4("by Adrian Banner"),
                                       h3("Calculus Made Easy"),
                                       h4("by Silvanus P. Thompson"),
                                       img(src='numbertheory.png',width="45%",align="right"),
                                       h2("Number Theory Books"),
                                       h3("Elementary Number Theory"),
                                       h4("by Gareth A. Jones and Josephine M. Jones"),
                                       h3("An Introduction to the Theory of Numbers"),
                                       h4("by G. H. Hardy, Edward M. Wright and Andrew Wiles"),
                                       img(src='statistics.jpg',width="45%",align="right"),
                                       h2("Statistics Books"),
                                       h3("Statistics in Plain English, Third Edition"),
                                       h4("by Timothy C. Urdan"),
                                       h3("Introductory Statistics"),
                                       h4("by Neil A. Weiss")),
                              tabPanel("SCIENCE",
                                       a("Cleck here for Best Science Books ",href="https://www.bookbub.com/blog/2018/08/14/best-science-books-2018"),
                                       img(src='science.png',width="50%",height="5%",align="top"),
                                       img(src='science0.jpg',width="40%",align="right"),
                                       h2("Enlightment now"),
                                       h3("By Steven Pinker"),
                                       img(src='science1.jpg',width="20%",align="right"),
                                       h5("If you think the world is coming to an end, think again: people are living longer, healthier, freer, and happier lives, and while our problems are formidable, the solutions lie in the Enlightenment ideal of using reason and science."),
                                       h2("Lost in Math"),
                                       h3("By Sabine Hossenfelder"),
                                       h5("A contrarian argues that modern physicists' obsession with beauty has given us wonderful math but bad science"),
                                       img(src='science3.jpg',width="20%",align="right"),
                                       h2("The Future of Humanity"),
                                       h3("By Michio Kaku"),
                                       h5("traverses the frontiers of astrophysics, artificial intelligence, and technology to offer a stunning vision of man's future in space, from settling Mars to traveling to distant galaxies.")),
                              tabPanel("LANGUAGES",
                                       a("Click here for Best Tips To Learn Language",href="https://www.babbel.com/en/magazine/10-tips-from-an-expert/"),
                                       img(src='language.png',width="80%",height="5%",align="top"),
                                       h2("CHINESE/MANDARIN"),
                                       h3("Integrated Chinese"),
                                       h5("This book has a good command of the rules of pinyin. It gives you a solid foundation on the phonetics of the Chinese language. I like this one and I'm sure most of you will, too. You'll understand the pronunciation of each character and the difference in the tones used. There are dialogues and grammar explanation in every lesson. This way, you'll be familiarized with the practical side of the lessons. What's nice about this book is that it's available in both traditional and simplified Chinese so you can definitely take your pick."),
                                       h3("Chinese Made Easier"),
                                       h5("This is another textbook that is leaning towards the practical uses of the Chinese language. All the vocabulary included can be used in your everyday conversations. If you're looking for a book that will fit your needs when travelling to China then, this one's for you. It contains the basic words and sentences used in self-introductions, time, dates, directions, transportation and dining out.")),
                              "NOVELS",
                              tabPanel("PHILOSOPHY",
                                       a("Click here for Best philosophical Books",href="https://www.thereadinglists.com/best-philosophy-books-for-beginners/"),
                                       h1("Paulo Coelho"),
                                       img(src='paulocoelho.jpg',width="40%"),
                                       img(src='paulocoelho1.png',width="25%",align="right"),
                                      h2("Ayn Rand"),
                              img(src='aynrand.png',width="40%"),
                              img(src='aynrand1.jpeg',width="35%",align="right"),
                              h2("Friedrich Nietzsche"),
                              img(src='nietzsche.jpg',width="30%"),
                              img(src='nietzsche1.jpg',width="50%",align="right")
               ),
                              tabPanel("SCIENCE FICTION",
                                       a("Click here for Best SCIENCE FICTION BOOKS",href="https://www.unboundworlds.com/2018/08/100-best-sci-fi-books/"),
                                       h3("BEST DEFINITE READ SCIFI BOOKS"),
                                       img(src='scifi1.jpg',width="35%"),
                                       img(src='scifi2.jpg',width="35%",align="right"),
                                       
                                       img(src='scifi3.jpg',width="35%"),
                                       img(src='scifi4.jpg',width="35%",align="right"),
                                       h4("Includes Lords of Rings"),
                                       img(src='scifi5.jpg',width="35%"),
                                       img(src='scifi6.jpg',width="35%",align="right")),
                              tabPanel("THRILLER/MYSTERY FICTION",
                                       a("Click here for BEST THRILLER BOOKS",href="https://www.bookbub.com/blog/2018/03/13/best-mystery-thriller-books-spring-2018"),
                                       h3("BEST DEFINITE READ MYSTERY/SUSPENSE THRILLERBOOKS"),
                                       img(src='mystery6.jpg',width="35%"),
                                       img(src='mystery2.jpg',width="35%",align="right"),
                                       
                                       img(src='mystery3.jpg',width="35%"),
                                       img(src='mystery5.jpg',width="35%",align="right"),
                                       h4("Mentioning only few best books"),
                                       img(src='mystery4.jpg',width="35%"),
                                       img(src='mystery1.jpg',width="35%",align="right")),
                              "LITERATURE",
                              tabPanel("CHINESE LITERATURE",
                                       img(src="chineseliterature.jpg",width="40%",align="down"),
                                       a("Click here to glance HISTORY OF CHINESE LITERATURE", href="https://www.chinahighlights.com/travelguide/culture/history-of-chinese-literature.htm")),
                              tabPanel("POETRY",
                                       a("Click here for best poetry quotes",href="https://www.brainyquote.com/topics/poetry"),
                                       img(src="poetry1.jpg",width="20%",align="right"),
                                       h2("The Odyssey"),
                                       h4("By Homer"),
                                       
                                       h2("PERFECT"),
                                       h3("By Ellen Hopkins"),
                                       img(src="perfect3.jpg",width="30%"),
                                       h2("The Realm of Possibility"),
                                       h3("David Levithan"),
                                       img(src="poetry3.jpg",width="30%")
                                       ),
               
                              
                              tabPanel("DRAMA",
                                       h2("The Odyssey"),
                                       h3("By Homer,1948"),
                                       h2("PERFECT"),
                                       h3("By Ellen Hopkins"),
                                       h2("The Realm of Possibility"),
                                       h3("David Levithan")),
                              tabPanel("PROSE",
                                       h2("The Odyssey"),
                                       h3("By Homer,1948"),
                                       h2("PERFECT"),
                                       h3("By Ellen Hopkins"),
                                       h2("The Realm of Possibility"),
                                       h3("David Levithan"))
                            ),
                        titlePanel("Thansk for visiting"),
                        ("Our upcoming products would be displayed soon")),
               tabPanel("About us",
                        sidebarLayout(
                          sidebarPanel("ANY OF THESE QUESTIONS CONTEMPLATES YOU? ACCESS OUR KNOWLEDGE HUB"),
                          mainPanel(img(src = 'about.jpg',width="35%",align="right"),
                            h4(" Are you facing this issues Insufficient storage space to store the books bought?"),
                                    h4("Are Certain books expensive or unavailable in the market, hence not accessible to you?"),
                                    h4("You do not like to spend money on books which you might not like?"),
                                    h4(" Are you interested in motivating your kith and ken to inculcate a habit of reading without having to spend big money on buying books?"),
                                    h4("Do you want books in your preferred language which are not easily available locally?"),
                                    h4("You have a book, do you want to earn some quick bucks by renting it out?")
                                    )
                        ),
                        sidebarLayout(
                          sidebarPanel("BENEFITS TO USER"),
                          mainPanel(h4("In addition to accessing some of the best books at minimal rates, users in our knowledge hub are entitled to folowing perks"),
                                    img(src = 'benefits.jpg',align="right"),
                                    h4("Ease of sharing of books"),
                                    h4("Follow which books your friends are reading"),
                                    h4("Earn money and help others by sharing your spare books."),
                                    h4("Track the books you're reading, read, and want to read")
                                    )
                        ),
                        sidebarLayout(
                          sidebarPanel("MISSION"),
                          mainPanel(h4("Why to buy when we can borrow & Save Earth by Saving Trees"),
                                    h4("We won't have a society if we destroy the environment"),
                                    h4("We strongly feel it's our collective and individual repsonsibility- To Preserve and Tend to the World in whihc we Live. "),
                                    img(src='mission.png',width="20%"),
                                    img(src='mission1.jpg',align="right",width="55%"),
                      
                          titlePanel("DO YOU KNOW?"),
                        h4("On an average, we can save 1 tree just by sharing approx. 30 books.")
                        ))),
               tabPanel("CONTACT",
                        titlePanel("LOCATIONS"),
                        fluidRow(
                          column(3,
                                 h3("SINGAPORE OFFICE"),
                                 img(src = 'office1.jpg', width = "100%"),
                                 h5("Address: 21 Bukit Batok Crescent #15-75 Wcega Tower, 658065"),
                                 h5("Phone: +65 6272 0820"),
                                 h3("TOKYO OFFICE"),
                                 img(src = 'office4.jpg', width = "100%"),
                                 h5("Address: Japan, ???105-0001 Tokyo, Minato, Toranomon, 2 Chome???1???"),
                                 h5("Phone: +81 3-5561-7921")
                                 
                          ),
                          column(3,
                                 h3("NEW YORK OFFICE"),
                                 img(src = 'office2.jpg', width = "100%"),
                                 h5("55 E 52nd St, New York, NY 10022, USA"),
                                 h5("PHONE +1 212-446-7000"),
                                 h3("SYDNEY OFFICE"),
                                 img(src = 'office5.jpg', width = "100%"),
                                 h5("Address: 135 King St, Sydney NSW 2000, Australia"),
                                 h5("Phone: +61 2 9249 3709")
                                 
                          ),
                          column(3, 
                                 h3("LONDON OFFICE"),
                                 img(src = 'office3.jpg', width = "100%"),
                                 
                                 h5("Address: Lincoln House, 296 - 302 High Holborn, London WC1V 7JH, UK"),
                                 h5("Phone: +44 870 888 8888"),
                                 h3("MUMBAI OFFICE"),
                                 img(src = 'office6.jpg', width = "100%"),
                                 h5("Address: B Wing, 1st Floor, Shah Industrial Estate, Saki Vihar Road, Andheri (E), Mumbai, Maharashtra 400072, India"),
                                 h5("Phone: +91 22 6671 5303")
                                 
                          ),
                          column(3,
                                 h3("KUWAIT OFFICE"),
                                 img(src = 'office7.jpg', width = "100%"),
                                 h5("Address: Al-Shuhada St, Al Kuwayt, Kuwait"),
                                 h5("Phone: +965 2299 7799"),
                                 h3("SYDNEY OFFICE"),
                                 img(src = 'office8.jpg', width = "100%"),
                                 h5("Address: Grand Millennium Plaza, 11/F, 181 Queen's Road Central, Sheung Wan, Hong Kong"),
                                 h5("Phone: +852 2360 9278")
                                 
                          )
                        )),
               navbarMenu(title = "Career ",
                          tabPanel("LOCATION", "Thanks for visiting us.We operate from several locations primarily Central Europe,UK,USA,Soth East Asia,India,Western Africa,Gulf,Austarlia,Russia,South Korea,Japan.","Further location wise details will be updated soon,",
                                   img(src='globaloffices.jpg',align="right",width="40%")),
                      
                          tabPanel("JOB ROLES ", "Yet to update roles in your loactaion.Thanks for coming.We will update you soon",
                                   img(src='jobroles.jpg',align="right",width="40%"))
               )
    )
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
}
# Run the application
shinyApp(ui = ui, server = server)

