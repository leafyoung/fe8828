library(readxl)
library(tidyverse)
library(ggplot2)
library(fOptions)
library(lubridate)

Book <- read.csv("C:/temp/Google.csv", na.strings="--")
Call_option <- Book
#Call option only
Call_opt <- Call_option %>%
  select(Exp..Date,Strike,Bid,Ask,Open.Int.)  %>% 
  mutate(Book,
                OptionType = "c",
               # Expiry = as.Date("2020-12-18"),
                Underlying = 1515.22,
                Today=as.Date("2020-10-11")) %>% 
  select(Exp.Date =Exp..Date,Strike,Open_Int.=Open.Int.,OptionType,Bid,Ask,Underlying,Today) 

#Exp. Date | Strike | Open Int. | OptionType | Bid | Ask | Underlying | Today
colnames(Call_opt)

#Put option only
Put_option <- Book
#rlang::last_error()
Put_opt <- Put_option %>% 
  {
    mutate(Put_option,
           
           Open_Int.= Open.Int..1,
           Bid=Bid.1,
           Ask=Ask.1 )  
  } %>% 
  select(.,Exp..Date,Strike,Bid,Ask,Open.Int.)  %>% 
  mutate(Call_option,
         OptionType = "p",
         # Expiry = as.Date("2020-12-18"),
         Underlying = 1515.22,
         Today=as.Date("2020-10-11")) %>% 
  select(.,Exp.Date =Exp..Date,Strike,Open_Int.=Open.Int.,OptionType,Bid,Ask,Underlying,Today)  
colnames(Put_opt)

#total option
df <- bind_rows(Call_opt, Put_opt)
df
colnames(df)


#2.2
#Valuation for call
Val_call <- Call_opt  %>% 
  mutate(Call_opt, 
        Total_Valuation=  (Open_Int.) * (Bid + Ask)/2) 
Val_call

#Valuation for put
Val_put <- Put_opt  %>% 
  mutate(Put_opt, 
         Total_Valuation=  (Open_Int.) * (Bid + Ask)/2) 
Val_put

#Valuation for total
Val_total <- df  %>% 
  mutate(df, 
         Total_Valuation=  (Open_Int.) * (Bid + Ask)/2) 
cat(paste0("This total Valuation is ", Val_total,  "\n"))

#2.3 open interest for in the money
data1 <- Call_opt %>% dplyr::filter( Strike < Underlying) %>% 
  rowwise() %>% summarise(na.omit(`Open_Int.`))  
data2 <- Put_opt %>% dplyr::filter( Strike > Underlying) %>% 
  rowwise() %>% summarise(na.omit(`Open_Int.`))
data1
data2
OpenInterest_InTheMoney <- sum(data1)+sum(data2)
cat(paste0("This total OpenInterest_InTheMoney is ",OpenInterest_InTheMoney,  "\n")) 

#2.4 Volatility Curve
strike <- c()
vol <- c()
data3 <- Call_opt %>% dplyr::filter( Strike > Underlying) 
data4 <- Put_opt %>% dplyr::filter( Strike < Underlying)
data3
data4

for(i in 1:nrow(data3)) {
  strike[i] <- data3$Strike[i]
  vol[i] <- GBSVolatility((data3$Bid[i] + data3$Ask[i]) / 2, "c", 
                          1515.22, data3$Strike[i],
                          as.numeric(as.Date("2020-12-18")-as.Date("2020-10-11"))/365,
                          r = 0.03, b = 0)
} 

for(i in 1:nrow(data4)) {
  strike[i+nrow(data3)] <- data4$Strike[i]
  vol[i+nrow(data3)] <- GBSVolatility((data4$Bid[i] + data4$Ask[i]) / 2, "p", 
                                      1515.22, data4$Strike[i],
                                      as.numeric(as.Date("2020-12-18")-as.Date("2020-10-11"))/365,
                                      r = 0.03, b = 0)
}
strike
vol
curve<-data.frame(strike, vol)
ggplot(curve, aes(strike, vol)) + geom_point() + geom_smooth(color = "blue")


