library(shiny)

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GH-Xiang Guangpei/Q1')

load(paste0(wd,"/Bank Data.rda")) #Bank Data.rda under same directory
name_list <- df_Account[,'Name']

ui <- fluidPage(

    titlePanel("Bank Report"),
    mainPanel(
      fluidRow(
        column(4,selectInput("client_name", "Client Name: ",name_list)),
        column(4,selectInput("month", "Month: ",c("July","August","September"))),
        column(4,actionButton("go", "Go"))),
      fluidRow(
        wellPanel(tags$h4(tags$strong("Deposit Balance Sheet(SGD)")),
                  tableOutput("deposit_sheet")),
        wellPanel(tags$h4(tags$strong("Credit Balance Sheet(SGD)")),
                  tableOutput("credit_sheet")),
        wellPanel(tags$h4(tags$strong("Transaction Balance Sheet")),
                  tableOutput("transaction_sheet")),
        wellPanel(tags$h4(tags$strong("Month-End Summary")),
                  tableOutput("summary_sheet"))
      )
  )
)


server <- function(input, output) {
    
    reactive <- eventReactive(input$go, {
      client_name <- as.character(input$client_name)
      AccountNo <- df_Account[which(df_Account$Name==client_name),'AccountNo']
      return(AccountNo)
    })
    #-----------------deposit----------------#
    output$deposit_sheet <- renderTable({
      AccountNo <- reactive()
      deposit_sheet <- as.data.frame(df_deposit[which(df_deposit$AccountNo==AccountNo),])
      print(deposit_sheet)
      month <- input$month
      if(month == "July"){
        balance <- deposit_sheet[which(deposit_sheet$index >= 1 & deposit_sheet$index <= 21),'Balance']
        index <- deposit_sheet[which(deposit_sheet$index>=1 & deposit_sheet$index<=21),'index']
        balance <- as.vector(balance)
        index <- as.vector(index)
        print(index)
        dates <- c()
        for(j in 1:length(index) ){
          j <- as.numeric(j)
          j<- index[j]
          date <- date_list[j]
          dates <- c(dates,date)
        }
        df <-  data.frame('Balance' = balance,
                          'Date' = dates)
        df
        print(df)
      }
      else if(month == "August"){
        balance <- deposit_sheet[which(deposit_sheet$index >= 22 & deposit_sheet$index <= 42),'Balance']
        index <- deposit_sheet[which(deposit_sheet$index>=22 & deposit_sheet$index<=42),'index']
        balance <- as.vector(balance)
        index <- as.vector(index)
        print(index)
        dates <- c()
        for(j in 1:length(index) ){
          j <- as.numeric(j)
          j<- index[j]
          date <- date_list[j]
          dates <- c(dates,date)
        }
        df <-  data.frame('Balance' = balance,
                          'Date' = dates)
        df
      }
      else {
        balance <- deposit_sheet[which(deposit_sheet$index >= 43 & deposit_sheet$index <= 62),'Balance']
        index <- deposit_sheet[which(deposit_sheet$index>=43 & deposit_sheet$index<=62),'index']
        balance <- as.vector(balance)
        index <- as.vector(index)
        print(index)
        dates <- c()
        for(j in 1:length(index) ){
          j <- as.numeric(j)
          j<- index[j]
          date <- date_list[j]
          dates <- c(dates,date)
        }
        df <-  data.frame('Balance' = balance,
                          'Date' = dates)
        df
      }
  })
    #-----------------credit-----------------#
    output$credit_sheet <- renderTable({
      AccountNo <- reactive()
      credit_sheet <- as.data.frame(df_credit[which(df_credit$AccountNo==AccountNo),])
      print(credit_sheet)
      month <- input$month
      if(month == "July"){
        balance <- credit_sheet[which(credit_sheet$index >= 1 & credit_sheet$index <= 21),'Balance']
        index <- credit_sheet[which(credit_sheet$index >= 1 & credit_sheet$index <= 21),'index']
        balance <- as.vector(balance)
        index <- as.vector(index)
        print(index)
        dates <- c()
        for(j in 1:length(index) ){
          j <- as.numeric(j)
          j<- index[j]
          date <- date_list[j]
          dates <- c(dates,date)
        }
        df <-  data.frame('Balance' = balance,
                          'Date' = dates)
        df
      }
      else if(month == "August"){
        balance <- credit_sheet[which(credit_sheet$index >= 22 & credit_sheet$index <= 42),'Balance']
        index <- credit_sheet[which(credit_sheet$index >= 22 & credit_sheet$index <= 42),'index']
        balance <- as.vector(balance)
        index <- as.vector(index)
        print(index)
        dates <- c()
        for(j in 1:length(index) ){
          j <- as.numeric(j)
          j<- index[j]
          date <- date_list[j]
          dates <- c(dates,date)
        }
        df <-  data.frame('Balance' = balance,
                          'Date' = dates)
        df
      }
      else {
        balance <- credit_sheet[which(credit_sheet$index >= 43 & credit_sheet$index <= 62),'Balance']
        index <- credit_sheet[which(credit_sheet$index >= 43 & credit_sheet$index <= 62),'index']
        balance <- as.vector(balance)
        index <- as.vector(index)
        print(index)
        dates <- c()
        for(j in 1:length(index) ){
          j <- as.numeric(j)
          j<- index[j]
          date <- date_list[j]
          dates <- c(dates,date)
        }
        df <-  data.frame('Balance' = sum,
                          'Date' = dates)
        df
      }
    })
    #-----------------summary-----------------#
    output$summary_sheet <- renderTable({
      AccountNo <- reactive()
      deposit_sheet <- as.data.frame(df_deposit[which(df_deposit$AccountNo==AccountNo),])
      credit_sheet <- as.data.frame(df_credit[which(df_credit$AccountNo==AccountNo),])
      print(deposit_sheet)
      month <- input$month
      if(month == "July"){
        c <- credit_sheet[which(credit_sheet$index >= 1 & credit_sheet$index <= 21),]
        d <- deposit_sheet[which(deposit_sheet$index >= 1 & deposit_sheet$index <= 21),]
      }
      else if(month == "August"){
        c <- credit_sheet[which(credit_sheet$index >= 22 & credit_sheet$index <= 42),'index']
        d <- deposit_sheet[which(deposit_sheet$index >= 22 & deposit_sheet$index <= 42),'index']
      }
      else{
        c <- credit_sheet[which(credit_sheet$index >= 43 & credit_sheet$index <= 62),'index']
        d <- deposit_sheet[which(deposit_sheet$index >= 43 & deposit_sheet$index <= 62),'index']
      }
      c <- nrow(c)
      d <- nrow(d)
      d <- as.numeric(d)
      c <- as.numeric(c)
      deposit <- deposit_sheet[d,'Balance']
      credit <- credit_sheet[c,'Balance']
      df <-  data.frame("Deposit Balance" = deposit,
                        "Credit Balance" = credit)
      df
    })
    
    #----------------transaction--------------#
    output$transaction_sheet <- renderTable({
      AccountNo <- reactive()
      x <- as.data.frame(df_transaction[which(df_transaction$AccountNo==AccountNo),])
      month <- input$month
      if(month == "July"){
        df <- x[which(x$index >= 1 & x$index <= 21),]
      }
      else if(month == "August"){
        df <- x[which(x$index >= 22 & x$index <= 42),]
      }
      else {
        df <- x[which(x$index >= 43 & x$index <= 62),]
     }
      df <- df[,c('Date','TransactionType','Currency','Amount','SGD_Amount','Balance')]
      df <- transform(df,CreditBalance=Balance)
      df <- rename(df, c("DepositBalance"="Balance"))
      for(j in 1:nrow(df)){
        if (df[j,'TransactionType']=="Spend"){df[j,'DepositBalance'] <- "-"}
        else{df[j,'CreditBalance'] <- "-"}
      }
      print("!!!!!")
      print(df)
      df
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
