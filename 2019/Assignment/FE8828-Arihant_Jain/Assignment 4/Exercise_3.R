library("readxl")
library(fOptions)
library(tidyverse)

## data were fetcehd from Yahoo finance on 11th October 2019
underlying_price = 1208.67
raw_data_call<- read_excel("C:/Users/arihant.jain/Documents/Assignment_4/GOOG_option_Data.xlsx", 1) %>%
  mutate_all(.,as.character) %>%
  mutate(.,"Call/Put"="c") %>%
  mutate(.,"Underlying"=underlying_price) %>%
  mutate(.,"Expiry Date"="12/20/2019")
  

raw_data_put<-read_excel("C:/Users/arihant.jain/Documents/Assignment_4/GOOG_option_Data.xlsx", 2) %>%
  mutate_all(.,as.character) %>%
  mutate(.,"Call/Put"="p") %>%
  mutate(.,"Underlying"=underlying_price) %>%
  mutate(.,"Expiry Date"="12/20/2019")

## Part - 1
google_option_data <- bind_rows(raw_data_call,raw_data_put) %>%
  select("Expiry Date", "Strike", "Open Interest", "Underlying", "Call/Put", "Bid", "Ask") %>%
  mutate(Strike=as.numeric(Strike),`Open Interest`=as.double(`Open Interest`),Bid=as.double(Bid),Ask=as.double(Ask))


## Part - 2
google_option_data <- mutate(google_option_data,Valuation=`Open Interest`*0.5*(Bid+Ask))
sol_part_2 <-  group_by(google_option_data,`Call/Put`) %>%
  summarise(Valuation=sum(Valuation)) %>%
  ungroup %>%
  rbind(c("Call and Put",sum(.$Valuation)))
print(sol_part_2)

## Part - 3
sol_part_3 <- mutate(google_option_data,in_the_money_flag = ifelse((`Call/Put`=="c" & Strike <= underlying_price)|
  (`Call/Put`=="p" & Strike >= underlying_price),1,0)) %>%
  filter(in_the_money_flag==1) %>%
  summarise("Number of Options ITM"=n(),"Sum Open Interest"=sum(`Open Interest`))
print(sol_part_3)

## Part - 4
time_to_maturity = as.numeric(as.Date("2019-12-20")-as.Date("2019-10-11"))/365
google_option_data = google_option_data %>%
  rowwise() %>%
  mutate(implied_vol = 100*GBSVolatility(
    price = 0.5*(Bid+Ask),
    TypeFlag =`Call/Put`,
    S = underlying_price,
    X = Strike,
    Time = time_to_maturity, r = 0.03, b = 0.03)) %>%
  ungroup()

### put a filter of implied vol >10 to get rid of implied vol which is not so called "clean price prints"
google_option_data  %>%
  dplyr::filter((Strike<underlying_price & `Call/Put`=="p")|(Strike>underlying_price & `Call/Put`=="c")) %>%
  dplyr::filter(implied_vol>10) %>%
  arrange(desc(Strike)) %>%
  select(Strike,implied_vol) %>%
  plot(type="l",xlab="Strike Prices",ylab="Implied Volatilities") %>%
  abline(v=underlying_price, col="darkred")