# Whenever you run the all codes, it generates a completely new random transaction 
# data and save them.

library(tidyverse)

# Creates accounts data with initial deposit and credit amount
accounts <- tibble(
  account_id = factor(1:10),
  name       = c("Andy","Betty","Cam","Daphne",
                 "Ellie","Fred","George",
                 "Herbert","Jen","Kelly"),
  deposit    = runif(10, 1000, 2000),
  credit     = 2000,
  date       = as.Date("2020-07-01"),
  type       = "deposit",
  currency   = "SGD"
)

# Imports the Exchange rates and clean it
exchange_rates <- read_csv("Exchange Rates.csv", skip = 4) %>% 
  magrittr::set_colnames(c("year","month","day","USD","CNY")) %>% 
  drop_na(CNY) %>% 
  fill(year, month) %>% 
  mutate(date = as.Date(paste0(year, "-", month, "-", day), format = "%Y-%B-%d")) %>% 
  mutate(SGD = 1,
         CNY = 100/CNY) 

# Create random deposit records for each clients, 1 or 2 times in each month 
income <- exchange_rates %>% 
  left_join(expand_grid(account_id = accounts$account_id, month = c("Jul","Aug","Sep")), by = "month") %>% 
  nest(data = c(-account_id,-month)) %>% 
  mutate(deposit = map2(data, sample(1:2, 30, replace = T), sample_n)) %>% 
  unnest(deposit) %>% 
  select(account_id, date) %>% 
  mutate(deposit = runif(row_number(), 1000, 2000),
         credit = 0,
         type = "deposit",
         currency = "SGD")

# Create random amounts of credit and withdraw records for each clients, 1000 times
outcome <- exchange_rates %>% 
  left_join(expand_grid(account_id = accounts$account_id, date = exchange_rates$date), by = "date") %>% 
  nest(data = -account_id) %>% 
  mutate(spend = map2(data, sample(1:1000, 10, replace = T), function(x, y) sample_n(x, y, replace = T))) %>% 
  unnest(spend) %>% 
  select(account_id, date, USD, CNY) %>% 
  mutate(spend = -rlnorm(row_number(),0,3)) %>% 
  mutate(currency = sample(c("SGD","CNY","USD"), n(), replace = TRUE)) %>% 
  mutate(type = sample(c("spend","withdraw"), n(), replace = TRUE)) %>% 
  mutate(credit = case_when(currency == "SGD" & type == "spend" ~ spend*1.01,
                            currency == "USD" & type == "spend" ~ spend*USD*1.02,
                            currency == "CNY" & type == "spend" ~ spend*CNY*1.02,
                            T ~ 0)) %>% 
  mutate(deposit = case_when(currency == "SGD" & type == "withdraw" ~ spend,
                             currency == "USD" & type == "withdraw" ~ spend,
                             currency == "CNY" & type == "withdraw" ~ spend,
                             T ~ 0))



# Merge initial account data, income and outcome data
actions <- plyr::rbind.fill(accounts, income, outcome) %>% 
  arrange(date) %>% 
  mutate(account_id = factor(account_id))

# For loop to clean the spend/withdraws that cause negative balance
account_list <- list()
for (a in 1:10) {
  a = as.character(a)
  account_list[[a]] <- filter(actions, account_id == a)
  for(i in 1:nrow(account_list[[a]])) {
    cum_deposit = sum(account_list[[a]][1:i,"deposit"])
    cum_credit  = sum(account_list[[a]][1:i,"credit"])
    if(cum_deposit < 0) {
      account_list[[a]][i,"deposit"] = 0
      account_list[[a]][i,"spend"] = 0
    } 
    if(cum_credit < 0) {
      account_list[[a]][i,"credit"] = 0
      account_list[[a]][i,"spend"] = 0
    } 
  }
}

# Special cumulative sum function (if there is end-date, also adds interest rate)
cum_summer <- function(x, action_date) {
  end_month = as.Date(c("2020-09-30","2020-08-31","2020-07-30"))
  interest_rate = 0.5/12
  y = x[1]
  for(i in 2:length(x)) {
    if(action_date[i] %in% end_month) {
      y[i] = (y[i-1] + x[i])*(1+interest_rate)
    } else {
      y[i] = y[i-1] + x[i]
    }
  }
  return(y)
}

# Merge all accounts data 
transactions <- bind_rows(account_list) %>% 
  group_by(account_id) %>% 
  mutate(cum_deposit = cum_summer(deposit,date),
         cum_credit = cumsum(credit)) %>% 
  ungroup()

# Add interest rate data
transactions <- transactions %>% 
  filter(date %in% as.Date(c("2020-09-30","2020-08-31","2020-07-30"))) %>% 
  group_by(account_id, date) %>% 
  slice_tail(n = 1) %>% 
  ungroup() %>% 
  mutate(currency = "SGD",
         type = "interest",
         spend = cum_deposit*(1-1/(12.5/12)),
         deposit = cum_deposit*(1-1/(12.5/12))) %>%
  rbind(transactions) %>% 
  arrange(account_id, date, type)

# Saving all datasets
save(accounts, file = "accounts.rda")
save(exchange_rates, file = "exchange_rates.rda")
save(transactions, file = "transactions.rda")

