library(tidyverse)
library(conflicted)
library(readxl)
library(fOptions)
conflict_prefer("lag", "dplyr")
conflict_prefer("filter", "dplyr")

# 2.1 Data cleaning

goog_calls <- read_excel("E:/Dropbox/MFE/FE8828/2020/Assignment-2020/FE8828-Andrea Athanasia Tan Li Ling/goog option chain.xlsx",
col_types = c("date", "skip", "skip",
"numeric", "numeric", "skip", "numeric",
"numeric", "skip", "skip", "skip",
"skip", "skip", "skip"))
goog_calls$`Exp. Date` = as.character(as.Date(goog_calls$`Exp. Date`, format = "%Y-%m-%d"))
goog_calls <- mutate(goog_calls, OptionType = "c",Underlying = 1458.42, Today = as.Date("2020-10-02"))
goog_c <- goog_calls[, c(1,5,4,6,2,3,7,8)]
goog_c <- na.omit(goog_c)

goog_puts <- read_excel("E:/Dropbox/MFE/FE8828/2020/Assignment-2020/FE8828-Andrea Athanasia Tan Li Ling/goog option chain.xlsx",
                         col_types = c("date", "skip", "skip",
"skip", "skip", "skip", "skip", "numeric",
"skip", "skip", "numeric", "numeric",
"skip", "numeric"))
goog_puts$`Exp. Date` = as.character(as.Date(goog_puts$`Exp. Date`, format = "%Y-%m-%d"))
goog_puts <- mutate(goog_puts, OptionType = "p", Underlying = 1458.42, Today = as.Date("2020-10-02"))
goog_p <- goog_puts[, c(1,2,5,6,3,4,7,8)]

goog_opt <- rbind(goog_c,goog_p)
`2.1 Data` <- goog_opt
view(`2.1 Data`)#to open in new window

# 2.2 Valuation
goog_val <- mutate(goog_opt, Value = goog_opt$`Open Int.`*(goog_opt$Bid + goog_opt$Ask) / 2)

calls <- goog_val %>% filter(OptionType == "c") 
call_val <- summarise(calls, call_valuation=sum(Value))
call_val

puts <- goog_val %>% filter(OptionType == "p") 
put_val <- summarise(puts, put_valuation=sum(Value))
put_val

total_val <- summarise(goog_val, total_valuation=sum(Value))
total_val

`2.2 Valuation` <- bind_cols(call_val,put_val,total_val)
view(`2.2 Valuation`)#to open in new window

# 2.3 Open interest of ITM calls and puts
itmcalls <- goog_opt %>% filter(OptionType == "c" & Strike<Underlying) 
callint <- summarise(itmcalls, `ITM Calls Open Int`=sum(`Open Int.`))
itmputs <- goog_opt %>% filter(OptionType == "p" & Strike>Underlying) 
putint <- summarise(itmputs, `ITM Puts Open Int`=sum(`Open Int.`))
totalint <- sum(callint,putint)
#OR
allitm <- goog_opt %>% filter((OptionType == "c" & Strike<Underlying)|(OptionType == "p" & Strike>Underlying))
allint <- summarise(allitm, `Total Open Int`=sum(`Open Int.`))
`2.3 Open Interest` <- bind_cols(callint,putint,allint)
view(`2.3 Open Interest`) #to open in new window

## OTM
itmcalls <- goog_opt %>% filter(OptionType == "c" & Strike>Underlying) 
callint <- summarise(itmcalls, `ITM Calls Open Int`=sum(`Open Int.`))
itmputs <- goog_opt %>% filter(OptionType == "p" & Strike<Underlying) 
putint <- summarise(itmputs, `ITM Puts Open Int`=sum(`Open Int.`))
totalint <- sum(callint,putint)
callint
putint
totalint

# 2.4 Volatility Curve
goog_opt2 <- goog_opt %>%  
  mutate(avgprice = ifelse(((OptionType == "p" & Strike<Underlying)|(OptionType == "c" & Strike>Underlying)),((Bid+Ask)/2),NA))
goog_opt2 <- na.omit(goog_opt2)
goog_opt2

Volcurve <- goog_opt2 %>% rowwise() %>% mutate(
  vol = GBSVolatility(price = avgprice, TypeFlag = OptionType, S = Underlying, X = Strike, Time = as.numeric((as.Date(`Exp. Date`)-as.Date(Today)))/365, r = 0.03, b = 0)
) %>% ungroup()
Volcurve

plot(Volcurve$Strike, Volcurve$vol,
     main = "Volatility Curve",
     ylab = "Implied volatility",
     xlab = "Strike price")
# results indicate more of a volatility smirk

# Print in console
`2.1 Data`
`2.2 Valuation`
`2.3 Open Interest`