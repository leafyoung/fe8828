#this is question 1.1
library(readxl)
library(tidyverse)
alphabet <- read_excel("C:/Users/xlj19/Desktop/alphabet.xlsx", 
                       sheet = "call", col_types = c("text", 
                       "skip", "numeric", "numeric", "numeric", 
                       "numeric", "skip", "skip", "numeric", 
                       "numeric", "numeric"))

alphabet1 <- read_excel("C:/Users/xlj19/Desktop/alphabet.xlsx", 
                       sheet = "put", col_types = c("text", 
                       "skip", "numeric", "numeric", "numeric", 
                       "numeric", "skip", "skip", "numeric", 
                       "numeric", "numeric"))

alphabet$"Call/Put" <- "Call"
alphabet1$"Call/Put" <- "Put"
option <- rbind(alphabet, alphabet1)
option$`Contract Name` <- NULL
option$`Last Price` <- NULL
option$Volume <- NULL
option$`Implied Volatility` <- NULL
option$"Expiry Date" <- as.Date("2019-12-20")
option$"Underlying" <- 1215.71
option <- option[, c(6, 1, 4, 7, 5, 2, 3)]

#this is question 1.2
option <- mutate(option, Valuation = option$`Open Interest` * (option$Bid + option$Ask)/2)
total_value <- group_by(option, `Call/Put`) %>%
  summarise(., sum(Valuation))
total_value <- rbind(total_value, c("Total", sum(as.numeric(total_value$`sum(Valuation)`))))

#this is question 1.3
itmc <- option %>%
  filter(., `Call/Put` == "Call") %>%
  filter(., Strike < Underlying)
itm <- option %>%
  filter(., `Call/Put` == "Put") %>%
  filter(., Strike > Underlying) %>%
  rbind(., itmc) %>% summarise(., sum(`Open Interest`))

#this is question 1.4
option <- rbind(alphabet, alphabet1)
option[c(1, 3, 4, 5, 7, 8)] <- list(NULL)
vcc <- option %>%
  filter(., `Call/Put` == "Call") %>%
  filter(., Strike < Underlying)
vc <- option %>%
  filter(., `Call/Put` == "Put") %>%
  filter(., Strike > Underlying) %>%
  rbind(., vcc)
vc <- vc[complete.cases(vc),]
plot(vc$Strike, vc$Volume)