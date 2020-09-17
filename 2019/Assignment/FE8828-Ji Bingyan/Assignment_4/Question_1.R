library(readxl)
library(fOptions)
library(tidyverse)
library(ggplot2)
call <- read_excel("C:/Users/AAA/Desktop/Handouts and notes/Web Application/Class_4/call.xlsx", 
                   col_types = c("text", "text", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric"))

put <- read_excel("C:/Users/AAA/Desktop/Handouts and notes/Web Application/Class_4/put.xlsx", 
                  col_types = c("text", "text", "numeric", 
                                "numeric", "numeric", "numeric", 
                                "numeric", "numeric", "numeric", 
                                "numeric", "numeric"))
call <- call %>%
    mutate(Call_Put = "Call", Expiry = as.Date("2019-12-20"), Underlying = 1234.03) %>%
    select(Expiry, Strike, `Open Interest`, Underlying, Call_Put, Bid, Ask) %>%
    mutate(Value = `Open Interest`*(Bid + Ask)/2) 
put <- put %>%
    mutate(Call_Put = "Put", Expiry = as.Date("2019-12-20"), Underlying = 1234.03)%>%
    select(Expiry, Strike, `Open Interest`, Underlying, Call_Put, Bid, Ask) %>%
    mutate(Value = `Open Interest`*(Bid + Ask)/2)

option <- bind_rows(call, put)
# total value for call and put
group_by(option, Call_Put) %>% 
    summarise(sum(Value)) %>%
    ungroup() 
# total value for all the options
option %>%
    summarise(sum(Value))
# total open interest
option %>%
    dplyr::filter((Call_Put == "Call" & Strike < Underlying) | (Call_Put == "Put" & Strike > Underlying)) %>%
    summarise(sum(`Open Interest`))
# volatility smile
option <- mutate(rowwise(option), 
                 vol = GBSVolatility(Ask, ifelse(Call_Put == "Call", "c", "p"), 
                                     Underlying, Strike, 
                                     as.numeric(as.Date(Expiry) - as.Date("2019-09-24"))/365, 
                                     r = 0.03, b = 0))
bind_rows(
    dplyr::filter(option, Call_Put == "Put", Strike < Underlying, Bid != 0, Ask != 0),
    dplyr::filter(option, Call_Put == "Call", Strike > Underlying, Bid != 0, Ask != 0)
) %>%
    arrange(Strike) %>%
    ggplot(.) + geom_point(aes(x = Strike, y = vol)) + labs(title = "Volatility Plot")

