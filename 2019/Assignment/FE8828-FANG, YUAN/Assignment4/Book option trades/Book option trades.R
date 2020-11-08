## Read data
library(readxl)
library(tidyverse)
library(fOptions)

setwd('E:/Dropbox/MFE/FE8828/2019/assignment/FE8828-FANG, YUAN/Assignment4/Book option trades')

Call <- read_excel("Call.xlsx", col_types = c("numeric", "numeric", 
                                              "numeric", "numeric", "numeric", "numeric", 
                                              "numeric", "numeric"))
Put <- read_excel("Put.xlsx", col_types = c("numeric", "numeric", 
                                            "numeric", "numeric", "numeric", "numeric", 
                                            "numeric", "numeric"))
Call <- Call %>%
  mutate(`Call/Put` = "c", `Expiry Date`= as.Date("2019-12-20"), Underlying = 1234.03) %>%
  select(`Expiry Date`, Strike, `Open Interest`, Underlying, `Call/Put`, Bid, Ask)
Put <- Put %>%
  mutate(`Call/Put` = "p", `Expiry Date`= as.Date("2019-12-20"), Underlying = 1234.03) %>%
  select(`Expiry Date`, Strike, `Open Interest`, Underlying, `Call/Put`, Bid, Ask)

## Count the total value
df <- bind_rows(Call,Put) %>% 
  mutate(Value = `Open Interest` * (Bid + Ask)/2)
sum(df[df$`Call/Put` == "c", ]$Value) # Total value of call
sum(df[df$`Call/Put` == "p", ]$Value) # Total value of put
sum(df$Value) # Total value of call and put

## Find those in the money and get their total interest
df %>% 
  dplyr::filter((`Call/Put` == "c" & Strike < Underlying) | 
                  (`Call/Put` == "p" & Strike > Underlying)) %>% 
  summarise(total_open_interest = sum(`Open Interest`))

## Plot the volatility curve
df %>% 
  dplyr::filter(Bid != 0 & Ask != 0) %>% 
  mutate(Volatility = 
           ifelse((Strike < Underlying & `Call/Put` == "p") | (Strike > Underlying & `Call/Put` == "c"),0,NA)) %>% 
  dplyr::filter(!is.na(Volatility)) %>% 
  rowwise() %>% 
  mutate(Volatility = GBSVolatility(Ask, `Call/Put`, Underlying, Strike,
                                    as.numeric((`Expiry Date`-as.Date("2019-09-16")))/365, 
                                    r = 0.03, b = 0)) %>% 
  ggplot(aes(Strike, Volatility)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE)
