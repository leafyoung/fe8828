library(shiny)

ui <- fluidPage(
    navbarPage(title = "Alibaba Group",
               tabPanel("Official Website", 
                        titlePanel("Welcome to Alibaba!"),
                        a("Click here to enter our website", href="https://www.alibabagroup.com/cn/global/home")),
               tabPanel("About Us",
                        fluidPage(titlePanel("About Alibaba"),
                                  "To make it easy to do business anywhere"),
                        img(src = "alibaba_logo.png"),
                        p("Alibaba Group Holding Limited, also known as Alibaba Group and as Alibaba.com, 
                          is a Chinese multinational technology company specializing in e-commerce, retail, Internet, and technology. 
                          Founded on 4 April 1999, in Hangzhou, Zhejiang, the company provides consumer-to-consumer (C2C), 
                          business-to-consumer (B2C), and business-to-business (B2B) sales services via web portals, 
                          as well as electronic payment services, shopping search engines and cloud computing services. 
                          It owns and operates a diverse portfolio of companies around the world in numerous business sectors.")),
               navbarMenu(title = "Products",
                          tabPanel("Taobao", a("Click here to enter Taobao", href="https://world.taobao.com/")),
                          tabPanel("Alipay", a("Click here to enter Alipay", href="https://www.alipay.com/")),
                          tabPanel("ELEME Takeout", a("Click here to enter ELEME Takeout", href="https://www.ele.me/")),
                          tabPanel("Cainiao Logistics", a("Click here to enter Cainiao", href="https://www.cainiao.com/")),
                          tabPanel("FreshHema", a("Click here to enter FreshHema", href="https://www.freshhema.com/"))
               )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)


