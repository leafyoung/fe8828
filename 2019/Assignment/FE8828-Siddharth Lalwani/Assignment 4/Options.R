library(dplyr)
library(tidyverse)
library(readxl)
library(fOptions)

df <- read_excel("E:/R Assignments/lec4/Book1.xlsx", 
                         col_types = c("text", "text", "numeric", 
                                                 "numeric", "numeric", "numeric", 
                                                 "numeric", "text", "text", "numeric", 
                                                 "numeric", "text"))
#View(df)
df2<- mutate(df,Expiry="2019-12-20",Underlying=1234.03)
#View(df2)
#df2.
#df2[c('Expiry','Strike','Open.interest','Underlying')]
df2<- mutate(df2,Value =`Open interest`*(Bid + Ask)/2)
#View(df2)
#df2$Value
#1.2 Call alone
df2_call<-df2[df2$`Call/Put`=="Call",]
#View(df2_call)
cat(paste0("Total valuation of call alone is ",sum(df2_call$Value)))

#1.2 Put alone
df2_put<-df2[df2$`Call/Put`=="Put",]
#View(df2_put)
cat(paste0("Total valuation of put alone is ",sum(df2_put$Value)))

#1.2 Put and Call
cat(paste0("Total valuation of put and call is ",sum(df2$Value)))

#1.3 Open interest Of In the Money
df2_in <- df2[(df2$Strike<df2$Underlying & df2$`Call/Put`=='Call')|(df2$Strike>df2$Underlying & df2$`Call/Put`=='Put'),]
#View(df2_in)
cat(paste0("Total Open Interest for In the money options is ",sum(df2_in$`Open interest`)))

#1.4 Volatility Curve
df2_out <- df2[(df2$Strike>df2$Underlying & df2$`Call/Put`=='Call')|(df2$Strike<df2$Underlying & df2$`Call/Put`=='Put'),]
df2_out <- mutate(df2_out,type = ifelse(`Call/Put`=='Call','c','p'))

# YY: Need to use rowwise for GBSVolatility function
df2_out <- mutate(df2_out,Volatility = GBSVolatility(`Last price`, type, Strike, Underlying,
                                                     as.numeric((as.Date(Expiry) -
                                                                   as.Date(`Last trade date`)))/365, r = 0.03, b = 0))
#GBSVolatility(256.50, "c", 1135.67, 880.00,
#              as.numeric((as.Date("2019-12-20") -
#                            as.Date("2019-09-16")))/365, r = 0.03, b = 0)
Volatility=c()
for (i in 1:16){
Volatility<- c(Volatility,GBSVolatility(df2_out$`Last price`[i], df2_out$type[i], df2_out$Strike[i], df2_out$Underlying[i],
              as.numeric((as.Date(df2_out$Expiry[i]) -
                            as.Date(df2_out$`Last trade date`[i])))/365, r = 0.03, b = 0))
}
Volatility
plot(Volatility)
length(df2_out)
