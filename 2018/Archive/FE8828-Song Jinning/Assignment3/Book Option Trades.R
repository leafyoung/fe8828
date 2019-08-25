library(tidyverse)
library(dplyr)
library(fOptions)

df <- read.csv("E:/Dropbox/Docs/MFE/FE8828/2018/Assignment/FE8828-Song Jinning/Assignment3/nasdaq_data.csv", header = TRUE) 
colnames(df) <- c('| Expiry Date','| Strike', '| Open Interest', '| Underlying', '| Call/Put', '| Bid', '| Ask')
df2 <- mutate(df, valuation = (`| Open Interest`*(`| Bid`+`| Ask`)/2))
c_p <- group_by(df2,`| Call/Put`) %>% summarise(total_valuation=sum(valuation))
cp <- summarise(df2, total_valuation=sum(valuation))
c_p
cp

# YY: This is check is not necessary.
# When option is in the money/out-of-money, buyer may choose to sell it to option dealer to settle it earlier.
# This is still Open interest.
# Simply:
sum(df$`| Open Interest`)

df3 <- mutate(df2, check=ifelse(`| Strike`<`| Underlying`,1,0))
c_OpenInt <- dplyr::filter(df3, `| Call/Put`=="c")  %>% summarise(s=sum(ifelse(df3$check==1,`| Open Interest`,0)))
p_OpenInt <- dplyr::filter(df3, `| Call/Put`=="p")  %>% summarise(s=sum(ifelse(df3$check==0,`| Open Interest`,0)))
total_OpenInt <- c_OpenInt + p_OpenInt
c_OpenInt
p_OpenInt
total_OpenInt


df4 <- mutate(df3, price=(`| Bid`+`| Ask`)/2)
# as.numeric((as.Date("2018-12-14") - as.Date("2018-11-14")))/365 = 0.08219178
df5 <- group_by(df4, `| Strike`) %>% 
  dplyr::filter((`| Call/Put` == "c" & `| Strike` >= `| Underlying`) | (`| Call/Put` == "p" & `| Strike` <= `| Underlying`)) %>% 
  rowwise() %>%
  # YY: misplaced Underlying and Strike
  mutate(vol=GBSVolatility(price, `| Call/Put`, `| Underlying`, `| Strike`, 0.08219178, r = 0.03, b = 0))

plot(df5$`| Strike`,df5$vol)

View(df5)
