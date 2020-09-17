#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Author: Liu Zhe
# Matric Number: G1700201C
# Date: 12/11/2017
#
# Introduction:
# This webpage is coded R Shiny, for a virtual "NTU Online Match Making" company
# 
# The overall website is designed in "navBar" layout
# 1st tab: "Our Service", "sideBar" layout
# 2nd tab: "Give Me Your Info", 2-column layout
# 3rd tab: "Meet the Developers", "Navlist" layout
#

# install.packages("shinythemes")
# this step is not necessary if you already have this package

library(shiny)

# install.packages("shinythemes")
# this step is not necessary if you already have this package
library(shinythemes)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("yeti"),
  fluidPage(
    navbarPage(
      
      # below is 1st tab
      title = "NTU Match Making Company",
      tabPanel("Our Service",
               
               titlePanel(h1("NTU Match Making Company", style="color:green;font-family:Rockwell")),
               titlePanel(h3("If you are the one...")),
               hr(),
               sidebarLayout(
                 sidebarPanel(
                   h3("Life is short",style="font-family:Elephant"),
                   h3("Love is long",style="font-family:Elephant"),
                   h3("NTU students are...",style="font-family:Elephant"),
                   wellPanel(
                     h4("Handsome",style="color:navy;font-family:'Lucida Calligraphy'",align="center"),
                     h4("Pretty",style="color:navy;font-family:'Lucida Calligraphy'",align="center"),
                     h4("and",style="font-family:'Lucida Calligraphy'",align="center"),
                     h4("Young",style="color:navy;font-family:'Lucida Calligraphy'",align="center")
                   ),
                   width = 4
                 ),
                 mainPanel(
                   h2("We provide an online match making platform, exclusively for", tags$u("NTU students"),style="font-family:Georgia"),
                   br(),
                   tags$img (src = "logo_ntu_new.png", width = 450, height = 150),
                   br(),
                   h3("Click" , tags$em("Give Me Your Info", style="color:navy"), "tab to find out more...",style="font-family:Georgia")
                 )
               )
      ),
      
      # below is 2nd tab
      tabPanel("Give Me Your Info",
               titlePanel(h1("NTU Match Making Company", style="color:green;font-family:Rockwell")),
               titlePanel(h4("Send below info to zliu025@e.ntu.edu.sg...")),
               h4("and we will find you a MATCH"),
               hr(),
               fluidRow(
                 column(5, 
                        wellPanel(h4("Step 1. Personal Information", style="font-family:Elephant;color:navy"),style = "padding: 1px", align="center"),
                        wellPanel(h4("e.g. Gender, Age, Height & Weight", style="font-family:Georgia")),
                        wellPanel(h4("Compulsory:", style="font-family:Georgia;color:red"),h4("Matriculation Number (so that we know you're from NTU)",style="font-family:Georgia"))
                 ),
                 column(7,
                        wellPanel(h4("Step 2. Answer 3 Questions", style="font-family:Elephant;color:navy"),style = "padding: 1px", align="center"),
                        wellPanel(h4("Q1. Which subject in NTU do you like the most, and why?",style="font-family:Georgia")),
                        wellPanel(h4("Q2. Which subject in NTU do you hate the most, and why?",style="font-family:Georgia")),
                        wellPanel(h4("Q3. Do you want a partner who likes the subject that you like, or a partner who likes the subject that you hate?",style="font-family:Georgia"))
                 )
               )),
      
      # below is 3rd tab
      tabPanel("Meet the Developers",
               titlePanel(h1("NTU Match Making Company", style="color:green;font-family:Rockwell")),
               titlePanel(h3("Who are we?")),
               hr(),
               navlistPanel(
                 "UI Developer",
                 tabPanel("Questionnaire Design",
                          h1("Designer: Zhe Liu", style="font-family:Elephant;color:navy"),
                          h3("If you feel the questionnaire needs improvement, key in your proposed new question below: ",
                             style="color:black;font-family:'Copper Black'"),
                          textInput("newQuestion","Your Question", "e.g. What is your school in NTU?"),
                          actionButton("do","Submission Temporarily Unavailable"),
                          h4("Submission service is currently unavailable, please wait till I completely learn it from FE8828",
                             style="color:black;font-family:'Copper Black'")
                 ),
                 tabPanel("Website Design",
                          h1("Designer: Liu Zhe", style="font-family:Elephant;color:navy"),
                          h3("If you are interested in joining our team, drop me an email with your resume: zliu025@e.ntu.edu.sg",
                             style="color:black;font-family:'Copper Black'")
                 ),
                 "Business Development",
                 tabPanel("Match-Making Executive",
                          h1("Executive: Zack Liu", style="font-family:Elephant;color:navy"),
                          tags$img(src="business.jpg", width="60%", height="60%"))
                 
               )
      )
    )
  )
  
)