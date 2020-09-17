library(tidyverse)
library(readxl)
library(ggplot2)
library(dplyr)
library(fOptions)
#1.1 copy data
google_option <- read_excel("/Users/lienwen/Desktop/option_google.xlsx", 
                            col_types = c("text","text","numeric","numeric","numeric", 
                                          "numeric","numeric","numeric","numeric","numeric","numeric"))


#1.2 Valuation
#call
data_call<- google_option %>% dplyr::filter(Type == "c") %>% rowwise() %>% summarise(`Open interest` * (Bid + Ask) / 2)
data_call<-na.omit(data_call)
call_value <- sum(data_call)
cat(paste0("call_value: ",call_value,"\n"))
#put
data_put<- google_option %>% dplyr::filter(Type == "p") %>% rowwise() %>% summarise(`Open interest` * (Bid + Ask) / 2)
data_put<- na.omit(data_put)
put_value <- sum(data_put)
cat(paste0("put_value: ",put_value,"\n"))
#call&put
total_value<-put_value+call_value
cat(paste0("total_value: ",total_value,"\n"))

#1.3 Total open interest of ITM
#2019-10-13
Underlying=1215.45
ITM<-google_option %>% dplyr::filter(Type=="c"&Strike<Underlying | Type=="p"&Strike>Underlying)
sum_O_I<-sum(na.omit(ITM$`Open interest`))
cat(paste0("Total open interest of ITM: ",sum_O_I,"\n"))

#1.4 Volatility curve
data_plot<-google_option %>% 
  dplyr::filter(Strike < Underlying & Type=="p" | Strike > Underlying & Type=="c") %>%
  mutate(price=(Bid+Ask)/2) %>%
  rowwise() %>%
  mutate(Vol = GBSVolatility(price,
                             TypeFlag = Type, 
                             S = Underlying, 
                             X = Strike, 
                             Time=as.numeric(as.Date("2019-12-20")-as.Date("2019-10-13"))/365, 
                             r=0.03,# risk-free rate=0.03
                             b=0))
ggplot(data_plot, aes(Strike, Vol)) + geom_point() + geom_smooth(color = "red")
