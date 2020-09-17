library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(plotly)

# load data
load(file="account_df.rda")
load("fx_df.rda")
load(file="transac_df.rda")

# Transactions were randomly generated without constraints, so we will impose the deposit and credit constraints now

# Assumptions
## FX rates used for each transaction follows the last available rate 
##   FX rates pulled are rates as at 12nn, so transactions on 1 July before 12nn follows rates as at 28 June 12nn
## FX conversion fees are borne by consumers while SGD spending commissions are borne by merchants 
##   i.e. consumers have to pay 2% FX conversions fees imposed by bank, but not the 1% SGD spending commission fee. 
## At the end of each month, bank will issue credit bill to customers
## Credit bills are paid by customers 5 days after bill is issued, using their deposit balance
## Customers will ensure their deposit balance stay above credit bill, so that they can pay the credit bill at the end of the month
## Customers will receive interest payment from bank at the end of each month
## Customers will not spend beyond credit limit (of 2000)

AutoTrigger <- function(AccountNo) {
  
  i <- AccountNo
  temp_df <- transac_df %>%
    dplyr::filter(AccountNo==i)
  
  dt_vec <- as.POSIXct(c("2019-07-31 23:59:59", "2019-08-05 23:59:59",
                         "2019-08-31 23:59:59", "2019-09-05 23:59:59",
                         "2019-09-30 23:59:59", "2019-10-05 23:59:59"))
  int_credit_df <- data.frame(TransactionNo = (nrow(temp_df)+1):(nrow(temp_df)+6),
                              DateTime = dt_vec,
                              AccountNo = i,
                              TransactionType = c("Interest Payment from Bank", "Payment of Credit Bills"),
                              Amount = NA,
                              Currency = "SGD")
  int_credit_df <- int_credit_df[-nrow(int_credit_df),]
  temp_df <- rbind(temp_df, int_credit_df)
  temp_df <- temp_df %>%
    dplyr::arrange(DateTime)
  
  temp_df$DepositBal_End <- NA
  temp_df$CreditBal_End <- NA
  init_row <- rep(NA, ncol(temp_df))
  temp_df <- rbind(init_row, temp_df)
  temp_df$DepositBal_End[1] <- account_df$Deposit_SGD[which(account_df$AccountNo==i)]
  temp_df$CreditBal_End[1] <- 0
  temp_df$Credit_Limit_SGD <- account_df$Credit_Limit_SGD[which(account_df$AccountNo==i)]
  temp_df$SGD_per_USD <- as.numeric(sapply(1:nrow(temp_df),
                                           function(e){
                                             return(tail(fx_df %>% dplyr::filter(DateTime < temp_df$DateTime[e]), 1)$SGD_per_USD)
                                           }))
  temp_df$SGD_per_CNY <- as.numeric(sapply(1:nrow(temp_df),
                                           function(e){
                                             return(tail(fx_df %>% dplyr::filter(DateTime < temp_df$DateTime[e]), 1)$SGD_per_CNY)
                                           }))
  temp_df$Amount_SGD <- ifelse(temp_df$Currency == "SGD", 
                               temp_df$Amount,
                               ifelse(temp_df$Currency == "CNY",
                                      temp_df$Amount * temp_df$SGD_per_CNY,
                                      ifelse(temp_df$Currency == "USD",
                                             temp_df$Amount * temp_df$SGD_per_USD,
                                             NA)))
  temp_df$Conversion_Fee <- ifelse(temp_df$Currency != "SGD",
                                   0.02*temp_df$Amount_SGD,
                                   0)
  temp_df$Commission_Fee <- ifelse(temp_df$Currency == "SGD", 
                                   ifelse(temp_df$TransactionType == "Spend",
                                          0.01*temp_df$Amount,
                                          0),
                                   0)
  
  curr <- 2
  while (curr <= nrow(temp_df)) {
    
    bef <- curr - 1
    
    if (temp_df$TransactionType[curr] == "Deposit") {
      
      temp_df$DepositBal_End[curr] <- temp_df$DepositBal_End[bef] + temp_df$Amount_SGD[curr] - temp_df$Conversion_Fee[curr]
      temp_df$CreditBal_End[curr] <- temp_df$CreditBal_End[bef]
      
    } else if (temp_df$TransactionType[curr] == "Withdraw") {
      
      temp_df$DepositBal_End[curr] <- temp_df$DepositBal_End[bef] - temp_df$Amount_SGD[curr] - temp_df$Conversion_Fee[curr]
      temp_df$CreditBal_End[curr] <- temp_df$CreditBal_End[bef]
      
    } else if (temp_df$TransactionType[curr] == "Spend") {
      
      temp_df$DepositBal_End[curr] <- temp_df$DepositBal_End[bef]
      temp_df$CreditBal_End[curr] <- temp_df$CreditBal_End[bef] + temp_df$Amount_SGD[curr] + temp_df$Conversion_Fee[curr]
      
    } else if (temp_df$TransactionType[curr] == "Interest Payment from Bank") {
      
      temp_df$DepositBal_End[curr] <- temp_df$DepositBal_End[bef] * (1+0.005)^(1/12)
      temp_df$CreditBal_End[curr] <- temp_df$CreditBal_End[bef]
      temp_df$Amount[curr] <- temp_df$DepositBal_End[bef] * ((1+0.005)^(1/12)-1)
      temp_df$Amount_SGD[curr] <- temp_df$Amount[curr]
      
    } else if (temp_df$TransactionType[curr] == "Payment of Credit Bills") {
      
      temp_df$DepositBal_End[curr] <- temp_df$DepositBal_End[bef] - temp_df$CreditBal_End[bef]
      temp_df$CreditBal_End[curr] <- 0
      temp_df$Amount[curr] <- temp_df$CreditBal_End[bef]
      temp_df$Amount_SGD[curr] <- temp_df$Amount[curr]
      
    } else {stop("Invalid Transaction Type")}
    
    if (temp_df$DepositBal_End[curr] < 0 || 
        (temp_df$CreditBal_End[curr] > temp_df$Credit_Limit_SGD[curr]) ||
        (temp_df$DepositBal_End[curr] < temp_df$CreditBal_End[curr])) {
      
      temp_df <- temp_df[-curr,]
      
      
    } else {
      curr <- curr + 1    
      
    }
    
  }
  
  temp_df <- temp_df[-1,]
  temp_df$TransactionNo <- 1:nrow(temp_df)
  
  return(temp_df)

}

auto_trigger_df <- dplyr::bind_rows(lapply(account_df$AccountNo, AutoTrigger))


##### RShiny #####
ui <- dashboardPage(
  dashboardHeader(title = "Bank Viewer"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Client", tabName = "Client", icon = icon("user-friends")),
      menuItem("Bank", tabName = "Bank", icon = icon("bank")),
      menuItem("Assumptions", tabName = "Assumptions", icon = icon("info"))
      )
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Client",
              fluidPage(
                tags$head(
                  tags$style(HTML("hr {border-top: 1px dashed #000000;}"))
                ),
                fluidRow(
                  column(width=12,
                         flowLayout(
                           numericInput("SelectAcctNo", "Select Account Number:",
                                        1, 1, 10, 1),  
                           selectInput("SelectMth", "Select Month:",
                                       paste(month.abb[7:9], "2019"))
                           ),
                         tags$i(h5(uiOutput("CheckClientName")))
                         )
                  ),
                tags$br(),
                fluidRow(
                  column(width=3,
                         actionButton("AutoTrigger", "Generate Report"))
                  ),
                hr(),
                fluidRow(
                  column(width=12,
                         h1(textOutput("ClientName")),
                         h3(textOutput("Month")))
                  ),
                fluidRow(
                  column(width=12,
                         tags$i(tags$u(h3(textOutput("Bal_Plot_header")))),
                         plotlyOutput("Bal_Plot"))
                ),
                fluidRow(
                  column(width=12,
                         tags$i(tags$u(h3(textOutput("Hist_DF_header")))),
                         tags$br(),
                         dataTableOutput("Hist_DF"),
                         h3(textOutput("MonthEndBal")))
                  ),
                fluidRow(
                  column(width=12,
                         tags$i(tags$u(h3(textOutput("Summary_DF_header")))),
                         tags$br(),
                         dataTableOutput("Summary_DF"))
                )
                )
              ),
      tabItem(tabName = "Bank", 
              fluidPage(
                tags$head(
                  tags$style(HTML("hr {border-top: 1px dashed #000000;}"))
                ),
                fluidRow(
                  column(width=12,
                         selectInput("SelectMthBank", "Select Month:",
                                     paste(month.abb[7:9], "2019")),
                         actionButton("BankReport", "Generate Report"))
                ),
                hr(),
                fluidRow(
                  column(width=12,
                         h3(textOutput("MonthBank")))
                ),
                fluidRow(
                  column(width=12,
                         tags$i(tags$u(h3(textOutput("AggBal_Plot_header")))),
                         plotlyOutput("AggBal_Plot"))
                ),
                fluidRow(
                  column(width=12,
                         tags$i(tags$u(h3(textOutput("PNL_DF_header")))),
                         tags$br(),
                         dataTableOutput("PNL_DF"))
                ),
                fluidRow(
                  column(width=12,
                         tags$i(tags$u(h3(textOutput("Risk_DF_header")))),
                         tags$br(),
                         dataTableOutput("Risk_DF"))
                )
                )
              ),
      tabItem(tabName = "Assumptions", 
              fluidPage(
                tags$head(
                  tags$style(HTML("hr {border-top: 1px dashed #000000;}"))
                ),
                fluidRow(
                  column(width=12,
                         h4("1. FX rates used for each transaction follows the last available rate"),
                         tags$i(h5("-- (FX rates pulled are rates as at 12nn, so transactions on 1 July before 12nn follows rates as at 28 June 12nn)")),
                         h4("2. FX conversion fees are borne by consumers while SGD spending commissions are borne by merchants"),
                         tags$i(h5("-- (i.e. consumers have to pay 2% FX conversions fees imposed by bank, but not the 1% SGD spending commission fee)")),
                         h4("3. At the end of each month, bank will issue credit bill to customers"),
                         h4("4. Credit bills are paid by customers 5 days after bill is issued, using their deposit balance"),
                         h4("5. Customers will ensure their deposit balance stay above credit bill, so that they can pay the credit bill"),
                         h4("6. Customers will receive interest payment from bank at the end of each month"),
                         h4("7. Customers will not spend beyond credit limit (of 2000)")
                         )
                ),
                hr()
              )
      )
      )
    )
)

server <- function(input, output) {
  
  output$CheckClientName <- renderUI({HTML(paste("Owner of Account: ", "<b>",
                                         as.character(account_df$Name[which(account_df$AccountNo==input$SelectAcctNo)]),
                                         "</b>"))})
  
  observeEvent(input$AutoTrigger, 
               {
                 mth_input <- isolate(input$SelectMth)
                 output$Month <- renderText({mth_input})
                 
                 acct_input <- isolate(input$SelectAcctNo)
                 output$ClientName <- renderText({as.character(account_df$Name[which(account_df$AccountNo==acct_input)])})
                 
                 hist_df <- auto_trigger_df %>%
                   dplyr::filter(AccountNo==acct_input, 
                                 month(DateTime)==which(month.abb==substr(mth_input, 1, 3))) %>%
                   dplyr::select(DateTime, TransactionType, Currency, Amount, Amount_SGD,
                                 DepositBal_End, CreditBal_End)
                 
                 colnames(hist_df) <- c("Date/Time", "Transaction Type", "Currency", "Amount", 
                                        "Amount (in SGD)", "Deposit Balance", "Credit Balance")
                 hist_df <- hist_df %>% 
                   dplyr::mutate_if(is.numeric, round, 2)
                 
                 output$Bal_Plot_header <- renderText({paste("Movement of Deposit/Credit Balance in", mth_input)})
                 bal_plot <- plot_ly(hist_df, x=~`Date/Time`) %>%
                   add_trace(y=~`Deposit Balance`, name = "Deposit Balance", type = 'scatter', mode = 'lines') %>%
                   add_trace(y=~`Credit Balance`, name = "Credit Balance", type = 'scatter', mode = 'lines') %>%
                   layout(
                     yaxis=list(title="Deposit/Credit Balance"),
                     xaxis=list(title="Date/Time",
                                type='date',
                                tickformat="%d %b"),
                     plot_bgcolor='transparent',
                     paper_bgcolor='transparent')
                 output$Bal_Plot <- renderPlotly({bal_plot})
                 
                 output$Hist_DF_header <- renderText({"Transaction History"})
                 output$Hist_DF <- renderDataTable({hist_df}, 
                                                   options = list(pageLength = 10, searching=F))
                 output$MonthEndBal <- renderText({paste0("Month-End Balance | Deposit: $", hist_df$`Deposit Balance`[nrow(hist_df)],
                                                         " | Credit: $",hist_df$`Credit Balance`[nrow(hist_df)])})
                 
                 output$Summary_DF_header <- renderText({"Summary"})
                 summary_df <- auto_trigger_df %>%
                   dplyr::group_by(TransactionType) %>%
                   dplyr::summarise(Amount=sum(Amount_SGD))
                 summary_df <- summary_df %>% 
                   dplyr::mutate_if(is.numeric, round, 2)
                 
                 colnames(summary_df) <- c("Transaction Type", "Amount")
                 output$Summary_DF <- renderDataTable({summary_df},
                                                      options = list(searching=F, paging=F))
               })
  
  
  observeEvent(input$BankReport, 
               {
                 mthbank_input <- isolate(input$SelectMthBank)
                 output$MonthBank <- renderText({mthbank_input})
                 
                 month_df <- auto_trigger_df %>%
                   dplyr::filter(month(DateTime)==which(month.abb==substr(mthbank_input, 1, 3))) 
                 month_df$Date <- as.Date(as.character(month_df$DateTime))
                 
                 agg_list <- lapply(account_df$AccountNo, 
                                    function(e) {
                                      df <- month_df %>% 
                                        dplyr::filter(AccountNo == e) %>%
                                        dplyr::group_by(Date) %>%
                                        dplyr::summarise(EoD_Deposit_Bal = DepositBal_End[n()],
                                                         EoD_Credit_Bal = CreditBal_End[n()],
                                                         EoD_FX_Earned = sum(Conversion_Fee),
                                                         EoD_Comms_Earned = sum(Commission_Fee))
                                      colnames(df)[2:ncol(df)] <- paste0(colnames(df)[2:ncol(df)], "_", e)
                                      return(df)
                                    })
                 
                 agg_df <- agg_list[[1]]
                 for (listnum in 2:length(agg_list)){
                   agg_df <- dplyr::full_join(agg_df, agg_list[[listnum]], by = "Date")
                 }
                 agg_df <- agg_df[order(agg_df$Date),]
                 agg_df$EoD_Deposit_Bal <- rowSums(agg_df[grepl("EoD_Deposit_Bal", colnames(agg_df))], na.rm=T)
                 agg_df$EoD_Credit_Bal <- rowSums(agg_df[grepl("EoD_Credit_Bal", colnames(agg_df))], na.rm=T)
                 agg_df$EoD_FX_Earned <- rowSums(agg_df[grepl("EoD_FX_Earned", colnames(agg_df))], na.rm=T)
                 agg_df$EoD_Comms_Earned <- rowSums(agg_df[grepl("EoD_Comms_Earned", colnames(agg_df))], na.rm=T)
                 agg_df <- agg_df %>% dplyr::select(Date, EoD_Deposit_Bal, EoD_Credit_Bal, EoD_FX_Earned, EoD_Comms_Earned)
                 agg_df <- agg_df %>% 
                   dplyr::mutate_if(is.numeric, round, 2)
                 
                 output$AggBal_Plot_header <- renderText({paste("Movement of Aggregated Deposit/Credit Balance in", mthbank_input)})
                 aggbal_plot <- plot_ly(agg_df, x=~Date) %>%
                   add_trace(y=~EoD_Deposit_Bal, name = "Aggregated Deposit Balance", type = 'scatter', mode = 'lines') %>%
                   add_trace(y=~EoD_Credit_Bal, name = "Aggregated Credit Balance", type = 'scatter', mode = 'lines') %>%
                   layout(
                     yaxis=list(title="Aggregated Deposit/Credit Balance"),
                     xaxis=list(title="Date",
                                type='date',
                                tickformat="%d %b"),
                     plot_bgcolor='transparent',
                     paper_bgcolor='transparent')
                 output$AggBal_Plot <- renderPlotly({aggbal_plot})
                 
                 
                 output$PNL_DF_header <- renderText({"Daily PnL History"})
                 agg_df$Total_Earned <- agg_df$EoD_FX_Earned + agg_df$EoD_Comms_Earned
                 colnames(agg_df) <- c("Date", "Total Deposit", "Total Credit", 
                                       "PnL from FX Conversion", "PnL from Client Spending", "Total PnL")

                 output$PNL_DF <- renderDataTable({agg_df}, 
                                                  options = list(pageLength = 10, searching=F))
                 
                 risk_df <- data.frame(Name = account_df$Name,
                                       AccountNo = account_df$AccountNo,
                                       Deposit = NA,
                                       Credit = NA)
                 risk_df$Deposit = as.numeric(sapply(account_df$AccountNo, 
                                                     function(e) {
                                                       vec <- agg_list[[e]][, 2]
                                                       vec <- na.omit(vec)
                                                       num <- vec[nrow(vec), 1]
                                                       return(num)
                                                       }))
                 risk_df$Credit = as.numeric(sapply(account_df$AccountNo, 
                                                    function(e) {
                                                      vec <- agg_list[[e]][, 3]
                                                      vec <- na.omit(vec)
                                                      num <- vec[nrow(vec), 1]
                                                      return(num)
                                                      }))
                 risk_df$NetDeposit <- risk_df$Deposit - risk_df$Credit
                 risk_df <- risk_df[order(risk_df$NetDeposit),]
                 risk_df$NetDeposit <- NULL
                 risk_df$AccountNo <- NULL
                 risk_df <- risk_df %>% 
                   dplyr::mutate_if(is.numeric, round, 2)
                 colnames(risk_df)[1] <- "Client Name"
                 
                 output$Risk_DF_header <- renderText({"End-of-Month Risk Table"})
                 output$Risk_DF <- renderDataTable({risk_df},
                                                   options = list(paging = F, searching=F))
                 
               })
  
}

shinyApp(ui = ui, server = server)
