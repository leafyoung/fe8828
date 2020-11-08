library(tidyverse)
library(lubridate)
library(bizdays)
library(ggplot2)
library(fOptions)
library(purrr)
Sys.setlocale(category = "LC_ALL", locale = "English") 


#---------------------------------------------#
#                   Q2.1                      #
#---------------------------------------------#
df <- read.csv("C:/Users/18519/OneDrive - Nanyang Technological University/FE8828-Tan Mengting/Assignment 4/data/asm4-option.csv",header=T,sep = ",")
# change "--"  => NA => 0
df[,"Change"] <- as.numeric(as.character(df[,"Change"]))
df[,"Volume"] <- as.numeric(as.character(df[,"Volume"]))
df[,"Open.Int."] <- as.numeric(as.character(df[,"Open.Int."]))
df[,"p.Change"] <- as.numeric(as.character(df[,"p.Change"]))
df[,"p.Volume"] <- as.numeric(as.character(df[,"p.Volume"]))
df[is.na(df)] = 0
df

# Today Oct 09
# Underlying Alphabet Inc. Class C Capital Stock
#--------------- call option ----------------#
c_df <- df[c(1,8,7,4,5)]
names(c_df) <- c("Exp. Date","Strike","Open Int.","Bid","Ask")
c_df <- transform(c_df,OptionType="c",
                  Underlying=1515.22,
                  Today="Oct 09")
#rearrange column order
c_df <- c_df[c(1,2,3,6,4,5,7,8)]
c_df 

#--------------- put  option ----------------#
p_df <- df[c(1,8,14,11,12)]
names(p_df) <- c("Exp. Date","Strike","Open Int.","Bid","Ask")
p_df <- transform(p_df,OptionType="p",
                  Underlying=1515.22,
                  Today="Oct 09")
#rearrange column order
p_df <- p_df[c(1,2,3,6,4,5,7,8)]
p_df 

#---------------------------------------------#
#                   Q2.2                      #
#---------------------------------------------#
# Single Valuation
c_df <- transform(c_df, valuation = Open.Int.  * (Bid + Ask) / 2)
p_df <- transform(p_df, valuation = Open.Int.  * (Bid + Ask) / 2)

book <- rbind(c_df,p_df)
book

# Total Valuation
df <- df[c(1,4,5,7,8,11,12,14)]
names(df) <- c("Exp. Date","cBid","cAsk","cOpenInt",
               "Strike",
               "pBid","pAsk","pOpenInt")
df <- mutate(df,Total_valuation = ( cOpenInt*(cBid + cAsk) / 2 + pOpenInt  * (pBid + pAsk) / 2 ))
df

#---------------------------------------------#
#                   Q2.3                      #
#---------------------------------------------#
# new_book for in money open interest
in_money_book <- mutate(book, Open.Int. = case_when(
                               Strike >= Underlying & OptionType =='c' ~ 0,
                               Strike <= Underlying & OptionType =='p' ~ 0,
                               TRUE ~ Open.Int.
            ))
in_money_book
total_open_interst <- sum(in_money_book[,'Open.Int.'])
cat("Total open interest in money: ", total_open_interst)

#---------------------------------------------#
#                   Q2.4                      #
#---------------------------------------------#
# Suppose price = (Bid + Ask)/2

c_df %>% 
rowwise() %>% 
mutate(
  price = (Bid + Ask)/2,
   vol = GBSVolatility(price, "c", Underlying, Strike,
                       as.numeric((as.Date("2020-12-18") - as.Date("2020-10-09")))/365,
                       r = 0.03, b = 0))%>%
  ungroup() -> c_df

  
p_df %>% 
  rowwise() %>% 
  mutate(
    price = (Bid + Ask)/2,
    vol = GBSVolatility(price, "p", Underlying, Strike,
                        as.numeric((as.Date("2020-12-18") - as.Date("2020-10-09")))/365,
                        r = 0.03, b = 0))%>%
  ungroup() -> p_df

c_df[,'vol']
p_df[,'vol']

ggplot(c_df, aes(x = Strike,y = vol)) + 
  geom_line(linetype="dotted")

ggplot(p_df, aes(x = Strike,y = vol)) + 
  geom_line(linetype="dotted")
  
              
