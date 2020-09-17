# Author:Bai Haoyu
# Matric Number: G1900411H
# Date: 13 Oct 2019

# Q1:Book option trades

library(dplyr)
library(lubridate)
library(ggplot2)
library(fOptions)
library(readxl)

Call <- read_excel("~/Desktop/Call.xlsx", 
                   col_types = c("numeric", "numeric", "numeric", 
                                       "numeric", "numeric", "numeric", 
                                       "numeric", "numeric"))

Put <- read_excel("~/Desktop/Put.xlsx", col_types = c("numeric", 
                                                      "numeric", "numeric", "numeric", "numeric", 
                                                      "numeric", "numeric", "numeric"))

Call <- mutate(Call, Call_Put = "Call", Expiry = as.Date("2019-12-20"), Underlying = 1234.03)
Put <- mutate(Put, Call_Put = "Put", Expiry = as.Date("2019-12-20"), Underlying = 1234.03)


# 1.2 Count the total valuation of 1) call alone, 2) put alone, 3) call and put.
Call1 <- mutate(Call, Value = `Open Interest` * (Bid + Ask)/2)
Put1 <- mutate(Put, Value = `Open Interest` * (Bid + Ask)/2)
# 1) call alone
call_alone <- summarise(Call1, total_valuation_call=sum(Value))
call_alone
# 2) put alone
put_alone <- summarise(Put1, total_valuation_put=sum(Value))
put_alone
# 3) call and put
both <- call_alone+put_alone
both

# 1.3 Find those in the money and get their total Open Interest.
In_The_Money_Call <- dplyr::filter(mutate(Call, Money = Underlying - Strike), Money > 0)
In_The_Money_Put <- dplyr::filter(mutate(Put, Money = Strike - Underlying), Money > 0)
callinterests <- sum(In_The_Money_Call$`Open Interest`)
putinterests <- sum(In_The_Money_Put$`Open Interest`)
# get their total Open Interest
callinterests+putinterests

# 1.4. Plot the volatility curve, strike v.s. vol.
# An OTM call option will have a strike price that is higher than the market price of the underlying asset. 
# An OTM put option has a strike price that is lower than the market price of the underlying asset.
Call2 <- dplyr::filter(Call, Bid > 0)
Call3 <- dplyr::filter(Call2, Ask > 0)
Put2 <- dplyr::filter(Put, Bid > 0)
Put3 <- dplyr::filter(Put2, Ask > 0)
Out_The_Money_Call <- dplyr::filter(mutate(Call3, Money2 = Underlying - Strike), Money2 < 0)
Out_The_Money_Call <- mutate(Out_The_Money_Call, Type="c")
Out_The_Money_Put <- dplyr::filter(mutate(Put3, Money2 = Strike - Underlying), Money2 < 0)
Out_The_Money_Put <- mutate(Out_The_Money_Put, Type="p")
Out_The_Money_Options <- bind_rows(Out_The_Money_Call, Out_The_Money_Put)
Out_The_Money_Options <- mutate(Out_The_Money_Options,Extraction = as.Date("2019-9-16"))
Out_The_Money_Options <- mutate(Out_The_Money_Options, Time=as.numeric(as.Date(Expiry, format="%d-%b-%y")-as.Date(Extraction, format="%d-%b-%y"))/365)
Out_The_Money_Options <- select(Out_The_Money_Options, Strike, `Last Price`, Type, Underlying, Time, Ask)
Out_The_Money_Options <- rowwise(Out_The_Money_Options)
for_plot <- mutate(Out_The_Money_Options, Volotility=GBSVolatility(price=`Last Price`, Type, Underlying, Strike, Time, r = 0.03, b = 0))
# for_plot <- mutate(Out_The_Money_Options, Volotility=GBSVolatility(price=Ask, Type, Underlying, Strike, Time, r = 0.03, b = 0))
ggplot(for_plot) + 
  geom_point(data=for_plot, aes(Strike, Volotility), color="red") +
  geom_smooth(data=for_plot, aes(x = Strike, y = Volotility), color="black", method = "loess", se = FALSE)

