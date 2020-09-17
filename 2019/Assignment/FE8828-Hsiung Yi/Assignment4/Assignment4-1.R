library(readxl)
library(tidyverse)
library(fOptions)
library(dplyr)

##Web3 Exercise2
#1.1
Call <- read_excel("C:/Users/Bear/Documents/R/option.xlsx", sheet = "Call", 
                   col_types = c("text", "text", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric"))
Put <- read_excel("C:/Users/Bear/Documents/R/option.xlsx", sheet = "Put", 
                   col_types = c("text", "text", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric"))

Call <- mutate(Call,
               Call_Put = "c",
               Expiry = as.Date("2019-12-20"),
               Underlying = 1234.03,
               Value = `Open Interest` * ((Bid+Ask)/2),
               ITM = ifelse(Underlying > Strike, 1, 0))


Put <- mutate(Put,
               Call_Put = "p",
               Expiry = as.Date("2019-12-20"),
               Underlying = 1234.03,
               Value = `Open Interest` * ((Bid+Ask)/2),
               ITM = ifelse(Underlying < Strike, 1, 0))
colnames(Call)
Option <- bind_rows(Call, Put)
Option <- select(Option, Expiry, Strike, `Open Interest`, Underlying, Call_Put, Bid, Ask)

#1.2
Option <- mutate(rowwise(Option),
                 Value = `Open Interest` * (Bid + Ask) / 2)

sum(Call$Value)
sum(Put$Value)
sum(Option$Value)

#1.3
group_by(Option, Call_Put) %>% summarize(sum(`Open Interest`))

#1.4
Option_Plot <- Option %>% 
               mutate(Vol = ifelse((Strike < Underlying & `Call_Put` == "p") | 
                                   (Strike > Underlying & `Call_Put` == "c"),0, NA))

Option_Plot <- rowwise(Option_Plot) %>%
          dplyr::filter(!is.na(Vol), Bid!=0, Ask!=0)%>%
          mutate(Vol=GBSVolatility(Ask, Call_Put, Underlying, Strike,
                     as.numeric((as.Date("2019-12-20") - as.Date("2019-09-16")))/365, 
                     r = 0.03, b = 0))  

ggplot(Option_Plot, aes(x= Strike, y=Vol))+
  geom_point() +
  geom_smooth()
