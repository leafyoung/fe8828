library(tidyverse)
library(lubridate)
library(purrr)
library(ggplot2)
library(gridExtra)
library(shiny)

set.seed(123)
#1
Account <- data.frame(AcountNo = c(1:10),Name = paste0("Client", c(1:10)))
initial_random_deposit <- data.frame(deposit=runif(10,1000,2000),credit=rep(0,10))
save(initial_random_deposit, file = "initial_random_deposit.RData")

#2
currency <- read.csv("C:\\Users\\AAA\\Documents\\WeChat Files\\jjjjjby\\FileStorage\\File\\2019-10\\Exchange Rates.csv", stringsAsFactors = F)
currency <- mutate(currency, End.of.Period = 2019)
for (i in 2:nrow(currency)){
    if (currency$X[i] == ""){
        currency$X[i] <- currency$X[i-1]
    }
}
currency <- mutate(currency, Date = paste0(End.of.Period, X, X.1)) %>%
    mutate(Date = ymd(Date)) 
currency <- currency[, (4:6)]
names(currency) <- c("SGD_to_USD", "SGD_to_CNY", "Date")
currency <- mutate(currency, SGD_to_CNY = SGD_to_CNY/100, weekdays = weekdays(Date))

dates <- data.frame(Date = seq(ymd("2019-07-01"), ymd("2019-09-30"), by = 1))
Currency <- full_join(dates, currency)
# find exchange rate for weekends. we use Friday's exchange rate for Saturday and Monday's rate for Sunday
for (i in 1:nrow(Currency)){  
    if (is.na(Currency$weekdays[i])){
        next
    }
    if (Currency$weekdays[i] == "Friday"){
        Currency$SGD_to_USD[i+1] <- Currency$SGD_to_USD[i]
        Currency$SGD_to_CNY[i+1] <- Currency$SGD_to_CNY[i]
        Currency$weekdays[i+1] <- "Saturday"
    }
    if (Currency$weekdays[i] == "Monday"){
        Currency$SGD_to_USD[i-1] <- Currency$SGD_to_USD[i]
        Currency$SGD_to_CNY[i-1] <- Currency$SGD_to_CNY[i]
        Currency$weekdays[i-1] <- "Sunday"
    }
}
#find exchange rate for holidays. use the rate at the day before holiday
for (i in 1:nrow(Currency)){ 
    if (is.na(Currency$weekdays[i])){
        Currency$SGD_to_USD[i] <- Currency$SGD_to_USD[i-1]
        Currency$SGD_to_CNY[i] <- Currency$SGD_to_CNY[i-1]
        Currency$weekdays[i] <- weekdays(currency$Date[i])
    }
}

save(Currency, file = "currency.RData")

#3
days <- ymd("2019-09-30") - ymd("2019-07-01") + 1 # number of days in this simulation
r <- 1.005^(1/365) - 1 # daily interest rate

# all the amount we generated in the following are after interest and transaction fees
get_deposit <- function(){
    deposit_currency <- sample(c("USD", "CNY", "SGD"), days, replace = T)
    # randomly sample 1 and 0, where 1 represents deposit. 
    deposit_times <- sample(c(1, 0), days, replace = T, prob = c(2/30, 1-2/30))
    deposit_amount <- map_dbl(deposit_times, ~.x * runif(1, 1000, 2000))
    deposit <- data.frame(date = seq(ymd("2019-07-01"), ymd("2019-09-30"), by = 1),
                          amount = deposit_amount * (1 + r), 
                          currency = deposit_currency,
                          interest = -deposit_amount*r) 
    # we set interest as negative so that it's eaiser to calculate bank PnL
    return(deposit)
}

get_spend <- function(){
    # randomly generate the times of spending for a customer in one day
    times <- sample(0:11,days,replace = T)
    # spend_amount is the total amount spent in one day
    spend_amount <- map_dbl(times, ~.x * rlnorm(1, mean = 2))
    spend_currency <- sample(c("CNY","USD","SGD"), days, replace = T)
    spend <- data.frame(date = seq(ymd("2019-07-01"), ymd("2019-09-30"), by = 1),
                        amount= spend_amount,
                        currency = spend_currency) %>%
        mutate(amount = ifelse(currency == "SGD", amount * 1.01, amount * 1.02),
               interest = ifelse(currency == "SGD", amount * 0.01, amount * 0.02))
    # interest here means the fees charged by bank. we name it as interest so it's eaiser to combine the data
    return(spend)
}

get_withdraw <- function(){
    times <- sample(0:11,days,replace=T)
    withdraw_amount <- map_dbl(times, ~.x * rlnorm(1, mean = 2))
    withdraw_currency <- sample(c("CNY","USD","SGD"),days,replace=T) 
    withdraw <- data.frame(date=seq(ymd("2019-07-01"), ymd("2019-09-30"), by = 1),
                           amount= withdraw_amount * (1+r),
                           currency=withdraw_currency,
                           interest = withdraw_amount*r)
    return(withdraw)
}

get_client <- function(t){
    client_deposit <- cbind(mutate(get_deposit(), TransactionType = "deposit",
                                   SGD_to_USD = Currency$SGD_to_USD, SGD_to_CNY = Currency$SGD_to_CNY))
    client_spend <- cbind(mutate(get_spend(), TransactionType = "spend",
                                 SGD_to_USD = Currency$SGD_to_USD, SGD_to_CNY = Currency$SGD_to_CNY))
    client_withdraw <- cbind(mutate(get_withdraw(), TransactionType = "withdraw",
                                    SGD_to_USD = Currency$SGD_to_USD, SGD_to_CNY = Currency$SGD_to_CNY))
    # combine all the data into one dataframe
    # we arrange the data so that deposit always appear first in each day
    # we also assume that deposit always happen before withdraw within oneday 
    client_data <- rbind(client_deposit, client_spend, client_withdraw) %>%
        arrange(date, TransactionType) %>% 
        mutate(currency = as.character(currency), balance = 0, credit = 0,
               transaction_status = "succeed", AccountNo = t, exchange_rate = 1)
    # select only relevant exchange rates
    for (i in 1:nrow(client_data)){
        if (client_data$currency[i] == "USD"){
            client_data$exchange_rate[i] <- client_data$SGD_to_USD[i]
        }
        if (client_data$currency[i] == "CNY"){
            client_data$exchange_rate[i] <- client_data$SGD_to_CNY[i]
        }
    }
    # initialize balance, interest and credit
    client_data$balance[1] <- (initial_random_deposit$deposit[t] + client_data$amount[1])*(1 + r)
    client_data$interest[1] <- -client_data$balance[1] * r

    for (j in 2:nrow(client_data)){
        if (client_data$TransactionType[j] == "deposit"){
            client_data$balance[j] <- client_data$balance[j - 1] + client_data$amount[j] * client_data$exchange_rate[j] - client_data$interest[j]
            # we assume that at the beginning of each month, the credit will be restored to 2000
            if(day(client_data$date[j]) == 1){
                client_data$credit[j] <- 0
            }else{
                client_data$credit[j] <- client_data$credit[j - 1]
            }
        }
        else if (client_data$TransactionType[j] == "spend"){
            if(client_data$amount[j] * client_data$exchange_rate[j] + client_data$interest[j] > 2000 - client_data$credit[j-1]){
                client_data$transaction_status[j] <- "fail"
                client_data$credit[j] <- client_data$credit[j - 1]
            }else{
                client_data$credit[j] <- client_data$credit[j - 1] + client_data$amount[j] * client_data$exchange_rate[j] + client_data$interest[j]
            }
            # spend only affects credit, thus the balance remains unchanged
            client_data$balance[j] <- client_data$balance[j-1]
        }else{
            if(client_data$amount[j] * client_data$exchange_rate[j] + client_data$interest[j] > client_data$balance[j - 1]){
                client_data$transaction_status[j] <- "fail"
                client_data$balance[j]=client_data$balance[j-1]
            }else{
                client_data$balance[j] <- client_data$balance[j - 1] - client_data$amount[j] * client_data$exchange_rate[j] - client_data$interest[j]
            }
            # withdray only affects balance, thus the credit remains unchanged
            client_data$credit[j] <- client_data$credit[j-1]
        }
    }
    return(client_data)
}
# combine the data from 10 clients
client_all <- get_client(1)
for (i in 2:10){
    client_all <- rbind(client_all, get_client(i))
}
client_all <- arrange(client_all, date, AccountNo)

Transcation_Chart <- function(client, month){
    client <- parse_number(client)
    client_month <- filter(client_all, AccountNo == client, month(date) == month)
    client_month_2 <- filter(client_month, TransactionType == "deposit")
    g1 <- ggplot(client_month) + geom_line(aes(x = date, y = credit)) + labs(title = "Credit", y = NULL, x = NULL)
    g2 <- ggplot(client_month_2) + geom_line(aes(x = date, y = amount)) + labs(title = "Deposit", y = NULL, x = NULL)
    g3 <- ggplot(client_month) + geom_line(aes(x = date, y = balance)) + labs(title = "Balance", y = NULL, x = NULL)
    grid.arrange(g1, g2, g3, nrow = 1)
}

Transaction_History <- function(client, month){
    client <- parse_number(client)
    client_month <- filter(client_all, AccountNo == client, month(date) == month, amount != 0)
    transaction_history <- mutate(client_month, Date = as.character(date), TransactionType = TransactionType, 
                                  Amount = amount, `Amount (in SGD)` = 0, `Deposit Balance` = balance,
                                  `Credit Balance` = credit)
    transaction_history <- select(transaction_history, Date, TransactionType, Amount,
                                  `Amount (in SGD)`, `Deposit Balance`, `Credit Balance`, `Transcation Status` = transaction_status)
    for (i in 1:nrow(client_month)){
        if (client_month$currency[i] == "USD"){
            transaction_history$`Amount (in SGD)`[i] <- client_month$amount[i] * client_month$SGD_to_USD[i]
        }else if(client_month$currency[i] == "CNY"){
            transaction_history$`Amount (in SGD)`[i] <- client_month$amount[i] * client_month$SGD_to_CNY[i]
        }else{
            transaction_history$`Amount (in SGD)`[i] <- client_month$amount[i]
        }
    }
    return(transaction_history)
}

Transaction_Summary <- function(client, month){
    client <- parse_number(client)
    filter(client_all, AccountNo == client, month(date) == month, amount != 0) %>%
        group_by(TransactionType) %>%
        summarise(Amount = sum(amount)) %>%
        return(.)
}

Bank_chart <- function(month){
    bank_month <- filter(client_all, month(date) == month, amount != 0, TransactionType == "withdraw")
    bank_summary <- group_by(bank_month, date) %>%
        summarise(Deposit = sum(balance), Credit = sum(credit)) 
    g1 <- ggplot(bank_summary, aes(x = date, y = Deposit)) + geom_line() + labs(title = "Deposit", x = NULL, y = NULL)
    g2 <- ggplot(bank_summary, aes(x = date, y = Credit)) + geom_line() + labs(title = "Credit", x = NULL, y = NULL)
    grid.arrange(g1, g2, nrow = 1)
}

Bank_pnl <- function(month){
    bank_month <- filter(client_all, month(date) == month, amount != 0, TransactionType == "withdraw") %>%
        mutate(date = as.character(date))
    bank_summary <- group_by(bank_month, date) %>%
        summarise(`Total Deposit` = sum(balance), `Total Credit` = sum(credit)) 
    bank_month_2 <- filter(client_all, month(date) == month, amount != 0) %>%
        mutate(date = as.character(date))
    bank_pnl <- group_by(bank_month_2, date) %>%
        summarise(`PnL from Client Spending` = sum(interest))
    return(full_join(bank_summary, bank_pnl))
}

Bank_risk_table <- function(month){
    end_month <- filter(client_all, month(date) == month, day(date) == days_in_month(month(date)), TransactionType == "withdraw")
    end_month <- mutate(end_month, C_D = credit - balance) %>%  # balance or deposit??
        arrange(desc(C_D))
    end_month$`Client Name` <- character(nrow(end_month))
    for (i in 1:nrow(end_month)){
        end_month$`Client Name`[i] <- as.character(Account$Name[which(Account$AcountNo == end_month$AccountNo[i])])
    }
    end_month <- select(end_month, `Client Name`, Deposit = balance, credit)
    return(end_month)
}

ui <- fluidPage(
    navbarPage(
        title = "Bank and Client data",
        tabPanel("Client",
                 fluidPage(
                     titlePanel("Client data"),
                     sidebarLayout(
                         sidebarPanel(
                             selectInput(inputId = "client_name",
                                         label = "Choose a client:",
                                         choices = paste0("client",c(1:10))
                             ),
                             selectInput(inputId = "month",
                                         label = "Choose a month:",
                                         choices = c(7:9)
                             )
                         ),
                         mainPanel(
                             plotOutput("Chart of client"),
                             br(), 
                             tableOutput("t1"),
                             br(), br(),
                             tableOutput("t2")
                         )
                     )
                 )),
        tabPanel("Bank",
                 fluidPage(
                     titlePanel("Bank data"),
                     sidebarLayout(
                         selectInput(inputId = "month2",
                                     label = "Choose a month for bank:",
                                     choices = c(7:9)),
                         
                         mainPanel(
                             plotOutput("Chart of bank"),
                             br(), 
                             tableOutput("t3"),
                             br(), br(),
                             tableOutput("t4")
                         )
                     ))
        )
    )
)

server <- function(input, output) {
    output$'Chart of client'<- renderPlot({ 
        plot(Transcation_Chart(input$client_name,input$month))
    })
    
    output$t1 <- renderTable({
        Transaction_History(input$client_name,input$month)
    })
    
    output$t2 <- renderTable({
        Transaction_Summary(input$client_name,input$month)
    })
    
    output$'Chart of bank' <- renderPlot({
        Bank_chart(input$month2)
    })
    
    output$t3 <- renderTable({
        Bank_pnl(input$month2)
    })
    
    output$t4 <- renderTable({
        Bank_risk_table(input$month2)
    })
}
shinyApp(ui = ui, server = server)