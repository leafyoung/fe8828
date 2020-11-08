#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(bizdays)
library(ggplot2)
library(alphavantager)
library(tibble)
#library(tidyverse)
library(dplyr)

av_api_key("XTJXSALAN94R88N8")

      #### create 2 pages, 1st page is for bond schedule, 2nd page for data downloader
ui <- fluidPage(

    titlePanel("Assignment 2"),
    navbarPage(title ="",
               
       tabPanel(strong("Bond Schedule"),
                
            sidebarLayout(
                sidebarPanel(
                       
                    dateInput("start_date","Start Date","2020-09-25"),
                    numericInput("T","Tenor In Years (Must Be Integer)",10),
                    numericInput("coupon","Coupon Rate",0.04),
                    selectInput("freq","Coupon Frequency",c("Annual" = 12, `Semi Annual` = 6, "Quarter" = 4, "Tri-monthly"=3,"Bi-monthly"=2, "Monthly" = 1)),
                    numericInput("ytm","Yield To Maturity",0.01),
                    hr(),
            
                    h4("NPV Value (Face Value =$100)"),
                    verbatimTextOutput("NPV1"),
                ),
                
                mainPanel(

                       dataTableOutput("p2"),
                       plotOutput("CFPlot", width = "900px", height = "300px")       

                )
            )               

                
        ),
               #page for data downloader
       tabPanel(strong("Data Downloader"),
         fluidRow(
            column(4,h4("Please Key In The Stock Code"),
               textInput("code","Code (max 5 per minute)",value="AAPL"),
               br(),
               uiOutput("fail",width = "200px", height = "200px")
            ),
            
            column(8, align="center",
               h4(textOutput("stock"),align = "center"),
               
               plotOutput("Price_h" )
               
               
            )
            
            
         )

        )
    

    )
)
# Define server logic for both bond schedule and data downloader
server <- function(input, output) {

    #     #generate dates of payment
   Bdate <- function(start_date,T,freq)
   {

      paydates <-  seq(as.Date(start_date)+months(freq),as.Date(start_date)+
                           years(T),,T*12/freq)
      adj_paydates <- paydates
      for(i in 1: length(paydates))
      {
          adj_paydates[i] <- adjust.next(paydates[i],"weekends")
      }
      adj_paydates
   }

       #generates cash flow
   CF <- function(coupon,T,freq)
   {
       cash_f <- c(rep(coupon*100*freq/12,T*12/freq-1),(coupon*100*freq/12+100))
       cash_f
   }
       #Calculate discount cash flow
   DCF <- function(coupon,T,freq,ytm)
   {
       dcf <- CF(coupon,T,freq)/(1+ytm*freq/12)**seq_along(CF(coupon,T,freq))
       dcf
   }

   npv <- function(coupon,T,freq,ytm)
   {
       dcf <- CF(coupon,T,freq)/(1+ytm*freq/12)**seq_along(CF(coupon,T,freq))
       npv <- sum(dcf)
       npv
   }

        #create interactive print for npv
   output$NPV1 <- renderPrint({
   npv(input$coupon,input$T,as.numeric(input$freq),input$ytm)
   })

   output$p2 <- renderDataTable(
       data.frame(
           Date =  Bdate(input$start_date,input$T,as.numeric(input$freq)),
           Payment =  CF(input$coupon,input$T,as.numeric(input$freq)),
           Discounted_Payment =  DCF(input$coupon,input$T,as.numeric(input$freq),input$ytm)
       ),
       options = list(pageLength = 5)
   )


   output$CFPlot <- renderPlot({

       plot_line <- data.frame(Dates = Bdate(input$start_date,input$T,as.numeric(input$freq)),Cash_Flow = CF(input$coupon,input$T,as.numeric(input$freq)))
       CFPlot <- ggplot(plot_line, aes(x = Dates, y = Cash_Flow, group=1))+geom_line()+geom_point()
       CFPlot
   })
   
#################################
   
   #server logic for data downloader. Save data as RDS and plot the data.
   
   output$stock <- renderText({
      paste("100-Day Price History For",input$code)
      
   })
   
   output$Price_h <- renderPlot({

      Price_h <- tryCatch(
         {
            sdata <- av_get(as.character(input$code),av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
         },error=function(e){
            Price_h <- "NA"
            Price_h
         }
      )
      if(as.character(Price_h)!="NA")
      {
         s_plot <- sdata%>%select(timestamp,adjusted_close)
         # s_plot <- s_plot%>%slice(1:120)
         colnames(s_plot) <- c("Time","Adjusted_Close")
         Price_h <- ggplot(s_plot, aes(x = Time, y = Adjusted_Close, group=1))+geom_line()+geom_point()
         Price_h
      }
   })
   
   output$fail <- renderUI(
      {
         Price_h <- tryCatch(
            {
               sdata <- av_get(as.character(input$code),av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
            },error=function(e){
               Price_h <- "NA"
            }
         )
         if(as.character(Price_h)=="NA"){
            tags$image(src="cannot find code.png",alt=" ",width = "200px", height = "150px")
         }else{
            h3(" ")
         }
         
      }

   )
   
   
   
   
   # output$fail <- renderImage(
   #    # {
   #    #    Price_h1 <- tryCatch(
   #    #       {
   #    #          sdata <- av_get(as.character(input$code),av_fun = "TIME_SERIES_DAILY_ADJUSTED",outputsize="compact")
   #    #       },error=function(e){
   #    #          Price_h1 <- "NA"
   #    #       }
   #    #    )
   #    # 
   #    #    if(as.character(Price_h1)=="NA"){
   #    #       outfile <- tempfile(fileext='.png')
   #    #       
   #    #       # Generate a png
   #    #       png(outfile, width=400, height=400)
   #    #       hist(rnorm(1))
   #    #       dev.off()
   #    #       
   #    #       # Return a list
   #    #       list(src = outfile,
   #    #            alt = "This is alternate text")
   #    #            
   #    #    }},deleteFile = TRUE
   # 
   # )
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)
