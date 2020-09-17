library(readxl)
library(tidyverse)
library(fOptions)

call <- read_excel("C:/Users/Administrator/Desktop/book.xlsx", 
                    sheet = "book1", col_types = c("text", 
                    "text", "numeric", "numeric", "numeric", 
                    "numeric", "numeric", "numeric", 
                    "numeric", "numeric", "numeric"))
call <- mutate(call, value = (call$`Open Interest`) * (call$Bid + call$Ask) / 2)
total_val_call <- sum(call$value)
put <- read_excel("C:/Users/Administrator/Desktop/book.xlsx", 
                    sheet = "book2", col_types = c("text", 
                    "text", "numeric", "numeric", "numeric", 
                    "numeric", "numeric", "numeric", 
                    "numeric", "numeric", "numeric"))

put <- mutate(put, value = (put$`Open Interest`) * (put$Bid + put$Ask) / 2)
put$value[is.na(put$value)] <- 0
total_val_put <- sum(put$value)
total_val <- total_val_call + total_val_put
call_in <- dplyr::filter(call, call$Strike<236.12)
put_in <- dplyr::filter(put, put$Strike>236.12)

in_the_money_option <- bind_rows(call_in, put_in)
in_the_money_option$`Open Interest`[is.na(in_the_money_option$`Open Interest`)] <- 0
total_open_interest <- sum(in_the_money_option$`Open Interest`)
OTMput <- dplyr::filter(put,put$Strike<236.12)

vol <- rep(0,57)
for (i in 1:42){
  vol[i] <- GBSVolatility(OTMput$`Last Price`[i], "p", 236.21,OTMput$Strike[i],
                           as.numeric((as.Date("2019-10-18") -
                                         as.Date("2019-10-13")))/365, r = 0.03, b = 0)
}
OTMcall <- dplyr::filter(call,call$Strike>236.12)

for (i in 43:57){
  vol[i] <- GBSVolatility(OTMcall$`Last Price`[i-42], "c", 236.21,OTMcall$Strike[i-42],
                          as.numeric((as.Date("2019-10-18") -
                                        as.Date("2019-10-13")))/365, r = 0.03, b = 0)
}
OTM_option <- bind_rows(OTMput,OTMcall)
plot(OTM_option$Strike,vol)







            