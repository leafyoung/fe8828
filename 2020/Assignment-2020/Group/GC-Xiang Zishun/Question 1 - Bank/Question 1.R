library(shiny)
library(tidyverse)
library(conflicted)
library(ggplot2)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")


# Set working directory here
# wd <- "D:/Assignment Web"

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GC-Xiang Zishun/Question 1 - Bank')
#wd <- getwd()

# Load auto-generated data
load(paste0(wd, "/Account.rda"))
load(paste0(wd, "/Conversion.rda"))
load(paste0(wd, "/Transaction.rda"))

# Data preprocessing for Client View

for (acc in clients$AccountNo) {
    
    accountNo <- clients$AccountNo[acc]
    runningDeposit <- clients$StartDeposit[acc]
    runningCredit <- clients$StartCredit[acc]
    
    transactions %>%
        filter(AccountNo == accountNo) %>%
        mutate("Deposit Balance" = runningDeposit) %>%
        mutate("Credit Balance" = runningCredit) %>%
        mutate(Conversion = 1) -> intermediate
    
    for (row in 1:nrow(intermediate)) {
        
        intermediate[row, "Conversion"] <- case_when(
            intermediate[row, "Currency"] == "SGD" ~ 1,
            intermediate[row, "Currency"] == "USD" ~ conversion$Conversion[conversion$Currency == "USD" & conversion$Date == intermediate[[row, "Date"]]],
            intermediate[row, "Currency"] == "CNY" ~ conversion$Conversion[conversion$Currency == "CNY" & conversion$Date == intermediate[[row, "Date"]]]
        )
        
    }
    
    
    intermediate %>%
        mutate("Amount (in SGD)" = Amount * Conversion) -> intermediate
    
    
    for (row in 1:nrow(intermediate)) {
        
        if(intermediate[row, "TransactionType"] == "Deposit")
        {
            runningDeposit = runningDeposit + intermediate[row, "Amount (in SGD)"]
            intermediate[row,"Deposit Balance"] <- runningDeposit
            intermediate[row,"Credit Balance"] <- runningCredit
            
        }
        else if(intermediate[row, "TransactionType"] == "Spend")
        {
            
            runningCredit = runningCredit - intermediate[row, "Amount (in SGD)"]
            intermediate[row,"Deposit Balance"] <- runningDeposit
            intermediate[row,"Credit Balance"] <- runningCredit
            
        }
        else if(intermediate[row, "TransactionType"] == "Withdraw")
        {
            runningDeposit = runningDeposit - intermediate[row, "Amount (in SGD)"]
            intermediate[row,"Deposit Balance"] <- runningDeposit
            intermediate[row,"Credit Balance"] <- runningCredit
            
        }
        else if(intermediate[row, "TransactionType"] == "Interest")
        {
            runningDeposit = runningDeposit + intermediate[row, "Amount (in SGD)"]
            intermediate[row,"Deposit Balance"] <- runningDeposit
            intermediate[row,"Credit Balance"] <- runningCredit
        }
        
    }
    
    assign(paste0("t", acc), intermediate)
    
}

transactions <- bind_rows(t1,t2,t3,t4,t5,t6,t7,t8,t9,t10)



# Data preprocessing for Bank View

aggregatedInitialDeposit = sum(clients$StartDeposit)

transactions %>%
    arrange(Date) %>%
    mutate(`Aggregated Credit` = cumsum(ifelse(TransactionType == "Spend", `Amount (in SGD)`,0))) %>%
    mutate(`Aggregated Deposit` = aggregatedInitialDeposit+
               cumsum(ifelse(TransactionType == "Deposit", `Amount (in SGD)`,0)) +
               cumsum(ifelse(TransactionType == "Interest", `Amount (in SGD)`,0))+
               cumsum(ifelse(TransactionType == "Withdraw", -`Amount (in SGD)`,0))) -> aggregateTotal

transactions %>%
    mutate(TransactionFees = 0) %>%
    mutate(InterestPaid = 0) -> bankIntermediate

for (row in 1:nrow(bankIntermediate)) {
    
    if(bankIntermediate[row, "TransactionType"] == "Spend")
    {
        multiplier <- case_when(
            bankIntermediate[row, "Currency"] == "SGD" ~ 1.01,
            bankIntermediate[row, "Currency"] == "USD" ~ 1.02,
            bankIntermediate[row, "Currency"] == "CNY" ~ 1.02
        )
        
        bankIntermediate[row, "TransactionFees"] = bankIntermediate[row, "Amount (in SGD)"] / multiplier
        
    }
    else if(bankIntermediate[row, "TransactionType"] == "Interest")
    {
        bankIntermediate[row, "InterestPaid"] = bankIntermediate[row, "Amount (in SGD)"]
    }
    
}



ui <- fluidPage(

    
    titlePanel("Bank"),
    
    hr(),

    sidebarLayout(
        
        sidebarPanel(
            
            selectInput(inputId = "viewType",
                        label = "View",
                        choices = c("Choose view" = "", "Client view", "Bank view")),
            
            uiOutput("client"),
            uiOutput("clientMonth"),
            
            uiOutput("bankMonth"),
            
            width = 3
            
        ),

        
        mainPanel(
            
            h2(strong(textOutput("info1"))),
            h3(strong(textOutput("info2"))),
            HTML('<br>'),
            
            strong(textOutput("heading1")),
            plotOutput("chart1"),
            HTML('<br>'),
            
            strong(textOutput("heading2")),
            tableOutput("table2"),
            HTML('<br>'),
            
            strong(textOutput("heading3")),
            tableOutput("table3")
            
        )
    )
)


server <- function(input, output, session) {
    
    observeEvent(input$viewType, {
        
        output$info1 <- NULL
        output$info2 <- NULL
        output$heading1 <- NULL
        output$chart1 <- NULL
        output$heading2 <- NULL
        output$table2 <- NULL
        output$heading3 <- NULL
        output$table3 <- NULL
        
        if(input$viewType != "")
        {
            if(input$viewType == "Client view")
            {
                output$client <- renderUI({
                    
                    output$bankMonth <- renderUI({})
                    
                    selectInput(inputId = "client",
                                label = "Client Name",
                                choices = c("Select client" = "", clients$Name))
                    
                })
            }
            else if(input$viewType == "Bank view")
            {
                output$bankMonth <- renderUI({
                    
                    output$client <- renderUI({})
                    output$clientMonth <- renderUI({})
                    
                    selectInput(inputId = "bankMonth",
                                label = "Month",
                                choices = c("Select Month" = "", "July", "August", "September"))
                })
            }
        }
        
    })
    
    observeEvent(input$client, {
        
        output$info1 <- NULL
        output$info2 <- NULL
        output$heading1 <- NULL
        output$chart1 <- NULL
        output$heading2 <- NULL
        output$table2 <- NULL
        output$heading3 <- NULL
        output$table3 <- NULL
        
        if(input$client != "")
        {
            output$clientMonth <- renderUI({
                
                selectInput(inputId = "clientMonth",
                            label = "Month",
                            choices = c("Select Month" = "", "July", "August", "September"))
                
            })
            
        }
        
    })
    
    observeEvent(input$clientMonth, {
        
        if(input$clientMonth != "")
        {
            client <- isolate(input$client)
            clientMonth <- isolate(input$clientMonth)
            
            output$info1 <- renderText(client)
            output$info2 <- renderText(clientMonth)
            
            
            # Client View Chart 1
            
            output$heading1 <- renderText("Chart showing Deposit and Credit balance")
            
            startDate <- case_when(
                clientMonth == "July" ~ as.Date("2020/07/01"),
                clientMonth == "August" ~ as.Date("2020/08/01"),
                clientMonth == "September" ~ as.Date("2020/09/01")
            )
            
            endDate <- case_when(
                clientMonth == "July" ~ as.Date("2020/07/31"),
                clientMonth == "August" ~ as.Date("2020/08/31"),
                clientMonth == "September" ~ as.Date("2020/09/30")
            )
            
            transactions %>%
                filter(AccountNo == clients$AccountNo[clients$Name == client]) %>%
                filter(Date >= startDate & Date <= endDate) %>%
                select(Date, TransactionType, Currency, Amount, "Amount (in SGD)", "Deposit Balance", "Credit Balance") -> intermediate
            
            output$chart1 <- renderPlot({

                ggplot(pivot_longer(intermediate, col = ends_with("Balance"),
                                    names_to = "Balance", values_to = "Balance Amount")) +
                    geom_line(aes(Date, `Balance Amount`, colour = Balance), size = 1.5) +
                    theme(axis.title=element_text(size = 12, face = "bold"),
                          legend.title=element_text(size = 12), 
                          legend.text=element_text(size = 12))

            })
            
            
            
            # Client View Table 2

            output$heading2 <- renderText("Transaction history")

            intermediate %>%
                mutate(Date = as.character(Date)) -> history

            output$table2 <- renderTable(history)
            
            
            
            # Client View Table 3

            output$heading3 <- renderText("Summary")

            history %>%
                group_by(TransactionType) %>%
                summarise(Amount = sum(`Amount (in SGD)`)) %>%
                ungroup() -> summary

            output$table3 <- renderTable(summary)
            
        }
        
    })
    
    observeEvent(input$bankMonth, {
        
        if(input$bankMonth != "")
        {
            bankMonth <- isolate(input$bankMonth)
            
            output$info2 <- renderText(bankMonth)
            
            
            # Bank View Chart 1
            
            output$heading1 <- renderText("Chart showing aggregated total deposit and credit")
            
            startDate <- case_when(
                bankMonth == "July" ~ as.Date("2020/07/01"),
                bankMonth == "August" ~ as.Date("2020/08/01"),
                bankMonth == "September" ~ as.Date("2020/09/01")
            )
            
            endDate <- case_when(
                bankMonth == "July" ~ as.Date("2020/07/31"),
                bankMonth == "August" ~ as.Date("2020/08/31"),
                bankMonth == "September" ~ as.Date("2020/09/30")
            )
            
            aggregateTotal %>%
                filter(Date >= startDate & Date <= endDate) %>%
                group_by(Date) %>%
                filter(row_number()==n()) %>%
                ungroup() %>%
                pivot_longer(cols = c("Aggregated Deposit", "Aggregated Credit"),
                             names_to = "Aggregated",
                             values_to = "Total")-> aggregateTotal
                
            output$chart1 <- renderPlot({
                
                ggplot(aggregateTotal) +
                    geom_line(aes(Date, Total, colour = `Aggregated`), size = 1.5) +
                    theme(axis.title=element_text(size = 12, face = "bold"),
                          legend.title=element_text(size = 12), 
                          legend.text=element_text(size = 12))
                
            })
            
            
            
            # Bank View Table 2
            
            output$heading2 <- renderText("Daily PnL Table")
            
            bankIntermediate %>%
                filter(Date >= startDate & Date <= endDate) %>%
                mutate(PnL = TransactionFees - InterestPaid) %>%
                group_by(Date) %>%
                summarise("PnL from Client Spending" = sum(PnL)) -> PnLClientSpending
            
            aggregateTotal %>%
                pivot_wider(names_from = "Aggregated",
                            values_from = "Total") %>%
                select(Date, "Total Deposit" = `Aggregated Deposit`, "Total Credit" = `Aggregated Credit`) -> PnLBalances
            
            PnLCombined <- left_join(PnLBalances, PnLClientSpending, by = "Date")
            
            PnLCombined %>%
                mutate(Date = as.character(Date)) -> PnLCombined
            
            output$table2 <- renderTable(PnLCombined)
            
            
            
            # Bank View Table 3
            
            output$heading3 <- renderText("Risk table (descending by largest Credit-Deposit)")
            
            transactions %>%
                filter(Date >= startDate & Date <= endDate) %>%
                group_by(AccountNo) %>%
                filter(row_number()==n()) -> riskNo

            riskName <- left_join(riskNo, clients, by = "AccountNo")

            riskName %>%
                mutate(Credit = (2000 - `Credit Balance`)) %>%
                mutate(Difference = Credit - `Deposit Balance`) %>%
                arrange(desc(Difference)) %>%
                ungroup %>%
                select(Name, Deposit = `Deposit Balance`, Credit)-> riskName
            
            output$table3 <- renderTable(riskName)
                
        }
        
    })
    
}


shinyApp(ui = ui, server = server)
