library(conflicted)
library(shiny)
library(tidyr)
library(dplyr)
library(plyr)
library(ggplot2)
library(reactable)
conflict_prefer("summarise", "dplyr")
conflict_prefer("mutate", "dplyr")
conflict_prefer("filter", "dplyr")
conflict_prefer("arrange", "dplyr")

wd <- ('E:/Dropbox/MFE/FE8828/2020/Assignment-2020/Group/GG-AllisonLau/Q1')

load(paste0(wd,"/accounts.rda"))
load(paste0(wd,"/exchange_rates.rda"))
load(paste0(wd,"/transactions.rda"))

ui <- fluidPage(
    
    titlePanel("Transactions"),
    sidebarLayout(
        sidebarPanel(width = 3,
                     helpText("Transaction tools aggregates the randomly generated transaction data of 10 clients.
                              The Client View shows the cumulative deposit and credit amount of selected month;
                              while the Bank View tab includes the total deposit and credit amount of all clients.")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Client View", 
                         selectInput("selected_account_name", "Select Account",
                                     choices = accounts$name),
                         selectInput("selected_month", "Select Month",
                                     choices = c("July","August","September")),
                         h2("Chart of Balance"),
                         plotOutput("client_plot"),
                         h2("Transaction History"),
                         reactableOutput("client_table"),
                         h2("Summary"),
                         reactableOutput("client_summary_table")),
                tabPanel("Bank View", 
                         selectInput("selected_month_bank", "Select Month",
                                     choices = c("July","August","September")),
                         h2("Chart"),
                         plotOutput("bank_plot"),
                         h2("PnL Table"),
                         reactableOutput("bank_table"),
                         h2("Risk Table"),
                         reactableOutput("risk_table"))
            )
        )
    )
)

server <- function(input, output) {
    
    selected_account_id <- reactive({
        as.character(accounts[accounts$name == input$selected_account_name, "account_id"])
    })
    
    output$client_plot <- renderPlot({
        transactions %>% 
            mutate(month = months(date)) %>% 
            filter(account_id == selected_account_id(),
                   month == input$selected_month) %>% 
            dplyr::rename(DepositBalance = cum_deposit,
                          CreditBalance = cum_credit) %>% 
            select(date, DepositBalance, CreditBalance) %>% 
            pivot_longer(-date) %>% 
            ggplot() +
            geom_line(aes(date, value, color = name)) +
            theme_minimal() +
            labs(x = "Date", y = "Balance", color = "Type")
    })
    
    output$client_table <- renderReactable({
        transactions %>% 
            mutate(month = months(date)) %>% 
            filter(account_id == selected_account_id(),
                   month == input$selected_month,) %>% 
            mutate(AmountSGD = ifelse(type!="deposit", deposit+credit, deposit)) %>% 
            select(Date = date,
                   TransactionType = type,
                   Currency = currency,
                   Amount = spend,
                   AmountSGD,
                   DepositBalance = cum_deposit,
                   CreditBalance = cum_credit) %>% 
            mutate_if(is.numeric, function(x) round(x, digits = 2)) %>% 
            mutate(TransactionType = str_to_sentence(TransactionType)) %>% 
            filter(AmountSGD != 0) %>% 
            reactable(columns = list(
                Date = colDef(footer = "Month-End Balance"),
                DepositBalance = colDef(name = "Deposit Balance",
                                        footer = function(values) sprintf("$%.2f", tail(values, 1))),
                CreditBalance = colDef(name = "Credit Balance",
                                       footer = function(values) sprintf("$%.2f", tail(values, 1))),
                AmountSGD = colDef(name = "Amount (in SGD)")
            ),
            defaultColDef = colDef(footerStyle = list(fontWeight = "bold")),
            highlight = T)
    })
    
    output$client_summary_table <- renderReactable({
        transactions %>% 
            mutate(month = months(date)) %>% 
            filter(account_id == selected_account_id(),
                   month == input$selected_month) %>% 
            mutate(AmountSGD = ifelse(type!="deposit", deposit+credit, deposit)) %>% 
            group_by(type) %>% 
            summarise(Amount = sum(AmountSGD)) %>% 
            mutate_if(is.numeric, function(x) round(x, digits = 2)) %>% 
            reactable(highlight = T)
    })
    
    output$bank_plot <- renderPlot({
        transactions %>% 
            mutate(month = months(date)) %>% 
            filter(month == input$selected_month_bank) %>% 
            mutate(AmountSGD = ifelse(type!="deposit", deposit+credit, deposit)) %>% 
            arrange(date) %>% 
            mutate(AggregateDeposit = cumsum(deposit)) %>% 
            mutate(AggregateCredits = cumsum(credit)) %>% 
            select(date, AggregateDeposit, AggregateCredits) %>% 
            group_by(date) %>% 
            slice_tail(n = 1) %>% 
            pivot_longer(-date) %>% 
            ggplot() +
            geom_line(aes(date, value, color = name)) +
            theme_minimal() +
            labs(x = "Date", y = "Balance", color = "Type")
    })
    
    output$bank_plot <- renderPlot({
        transactions %>% 
            filter(type != "interest") %>% 
            mutate(month = months(date)) %>% 
            filter(month == input$selected_month_bank) %>% 
            mutate(AmountSGD = ifelse(type!="deposit", deposit+credit, deposit)) %>%
            mutate(pnl = case_when(type %in% c("withdraw","spend") & currency != "SGD" ~ AmountSGD*(0.2/1.2),
                                   type %in% c("withdraw","spend") & currency == "SGD" ~ AmountSGD*(0.1/1.1),
                                   T ~ 0)) %>% 
            arrange(date) %>% 
            mutate(TotalDeposit = cumsum(deposit),
                   TotalCredits = cumsum(credit)) %>% 
            select(date, TotalDeposit, TotalCredits) %>% 
            group_by(date) %>% 
            slice_tail(n = 1) %>% 
            ungroup() %>% 
            pivot_longer(-date) %>% 
            ggplot() +
            geom_line(aes(date, value, color = name)) +
            theme_minimal() +
            labs(x = "Date", y = "Balance", color = "Type")
    })
    
    output$bank_table <- renderReactable({
        transactions %>% 
            filter(type != "interest") %>% 
            mutate(month = months(date)) %>% 
            filter(month == input$selected_month_bank) %>% 
            mutate(AmountSGD = ifelse(type!="deposit", deposit+credit, deposit)) %>%
            mutate(pnl = case_when(type %in% c("withdraw","spend") & currency != "SGD" ~ AmountSGD*(0.2/1.2),
                                   type %in% c("withdraw","spend") & currency == "SGD" ~ AmountSGD*(0.1/1.1),
                                   T ~ 0)) %>% 
            arrange(date) %>% 
            mutate(TotalDeposit = cumsum(deposit),
                   TotalCredits = cumsum(credit),
                   TotalPnl= cumsum(-pnl)) %>% 
            select(date, TotalDeposit, TotalCredits, TotalPnl) %>% 
            group_by(date) %>% 
            slice_tail(n = 1) %>% 
            ungroup() %>% 
            mutate_if(is.numeric, function(x) round(x, digits = 2)) %>% 
            reactable(highlight = T,
                      columns = list(
                          date = colDef(name = "Date"),
                          TotalDeposit = colDef(name = "Total Deposit"),
                          TotalCredits = colDef(name = "Total Credits"),
                          TotalPnl = colDef(name = "PnL from Client Spending")
                      ))
    })
    
    output$risk_table <- renderReactable({
        transactions %>% 
            mutate(month = months(date)) %>% 
            filter(month == input$selected_month_bank) %>% 
            arrange(date) %>% 
            group_by(account_id) %>% 
            slice_tail(n = 1) %>% 
            ungroup() %>% 
            left_join(accounts, by = "account_id") %>% 
            select(ClientName = name.y, Deposit = cum_deposit, Credit = cum_credit) %>% 
            arrange(-Credit) %>% 
            mutate_if(is.numeric, function(x) round(x, digits = 2)) %>% 
            reactable(highlight = T)
    })
    
    
}


shinyApp(ui = ui, server = server)
