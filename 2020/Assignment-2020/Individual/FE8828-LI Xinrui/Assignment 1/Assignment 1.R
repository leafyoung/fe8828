library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    h1("Atlas Co."),
    tabsetPanel(
      tabPanel("||"," "),
      tabPanel("About us", "Atlas Co. is a bio-tech company established in 2000......."), 
      tabPanel("Join us", "Please send your CV and cover letter to 1234567@atlas.com"), 
      navbarMenu(title = "Product",
                 tabPanel("medical apparatues", "x-ray machines"),
                 tabPanel("vaccines", "HIV / influenza vaccines"),
                 tabPanel("medical supplies", "masks/goggles/protection suits")
      ),
      navbarMenu(title = "Contact us",
                 tabPanel("Phones", "+86 88886666"),
                 tabPanel("Email", "1234567@atlas.com"),
                 tabPanel("Address", "170 Jurong Street, Singapore")
      )
    ),
    sidebarLayout(position="right",
      sidebarPanel(
        h3("COVID-19 Especially"),
        wellPanel(
          h3("Masks",cex=0.5),
          actionButton("goButton", "Buy"),
          h3("Goggles"),
          actionButton("goButton", "Buy"),
          h3("Protection suits"),
          actionButton("goButton", "Buy")
        )
      ),
      mainPanel(img(src = "https://news.cgtn.com/news/3441444e31516a4e35597a4e356b444f7851444f31457a6333566d54/img/f54b71d7070d4ad6875ba012c2711bb6/f54b71d7070d4ad6875ba012c2711bb6.jpg",width="130%")
      )
    ),
    fluidRow(
      column(4,wellPanel(h1("New breakthrough"),
                         tags$h3("Vaccines for COVID-19 is on the way, going through stage 3 trial in a number of countries including Brazil, India and Russia. We are looking forward to launch the vaccines in the first quarter of 2021.",
                         a("Click here to see more.",href="http://www.gdqynews.com/health/jibing/20200924/400907.html")))
    ),
      column(4,wellPanel(h1("Our Laboratory"),
                       tags$h3("Our laboratories have world' leading facilities, in cooperation with a number of universities to make contributions to humanity.",
                               a("Click here to see more.",href="https://www.baidu.com/link?url=-H4gOEHkCUzX6aXIcwiyK--6ERHIBAJBFIeBmLN4FEhuJJfp992UaYC2DQG2b4M4&wd=&eqid=936040a80006df8a000000065f6f6f90")))
    ),
      column(4,wellPanel(h1("Our research highlights"),
                       tags$h3("+2020 outstanding bio-tech companies in Asia
                               +SCI outstanding research institution award
                               +2019 Singaporean most university-friendly enterprises",
                               a("Click here to see more.",href="https://www.baidu.com/link?url=-H4gOEHkCUzX6aXIcwiyK--6ERHIBAJBFIeBmLN4FEhuJJfp992UaYC2DQG2b4M4&wd=&eqid=936040a80006df8a000000065f6f6f90")))
    )
    ),
    navlistPanel(
      "Our research team",
      tabPanel("Professor Xiao Ming", 
             h1("Professor Xiao Ming"),
             mainPanel(img(src = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601149885137&di=4ae384f886c0b7a0cdc7989b830c68cb&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190309%2F6b75598f51014bccada1a1f2b3ada1b0.jpeg",width="75%")),
             p("Professor Xiao Ming, a distinguished medical leader who has dedicated his career to improving treatments for diabetes and kidney disease, is Dean of the Lee Kong Chian School of Medicine (LKCMedicine).Professor Xiao Ming is formerly the Head of Medical School at the University of Melbourne in Australia, and has 30 years’ experience in research, teaching and medical leadership.")),
      tabPanel("Professor Xiao Hong",
             h1("Professor Xiao Hong"),
             mainPanel(img(src = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601150401856&di=7a4262b6d0506346cd8d974d04068850&imgtype=0&src=http%3A%2F%2Ftiebapic.baidu.com%2Fforum%2Fw%3D580%2Fsign%3Daf8b6f822edbb6fd255be52e3925aba6%2F8850a48b87d6277f607ee9413f381f30e924fc29.jpg",width="60%")),
             p("Prof Xiao Hong graduated in Medicine from the Johann Wolfgang Goethe-University in Frankfurt am Main, Germany in 1985. He joined the Department of Internal Medicine at the Johann Wolfgang Goethe-University Medical Centre in 1985 under Professor Schoeffling and Professor Usadel. He received the Board Certificate in Internal Medicine and the Board Certificate in Endocrinology and Diabetology, conferred by the Chamber of Physicians State Hesse, Germany, in 1992 and 1993 respectively.")),
      tabPanel("Professor Xiao Feng",
             h1("Professor Xiao Feng"),
             mainPanel(img(src = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601150381736&di=2b35e2d24ce749412ac6632afa8d7241&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3D9b615f79d22a283443a636036bb4c92e%2F8d8aff43ad4bd11388c8f8565cafa40f4bfb0568.jpg",width="65%")),
             p("Prof Xiao Feng received her PhD in animal social behaviour from Queen’s University Belfast in the United Kingdon (UK) (1993). She then trained and worked in industrial and clinical psychology, receiving her Masters in Occupational Psychology (1994; also Queen’s Belfast) and a Doctorate in Clinical Psychology from the University of Edinburgh, UK (2000). She then shifted focus to medical and education research, and medical education, splitting her time between clinical work in Liaison Psychiatry, research, teaching and management."))
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


