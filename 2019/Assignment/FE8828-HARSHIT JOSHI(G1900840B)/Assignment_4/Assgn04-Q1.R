library(readxl)
library(fOptions)
library(dplyr)
library(tidyverse)

book <- read_excel("C:\\Users\\1987h\\Downloads\\NTU MFE study material\\mini term 2\\Web applications\\lecture04\\session 4\\Book1.xlsx",
                   col_types = c( "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric","numeric","text"))

book <- mutate(book,
                Expiry = as.Date("2019-12-20"),
                Underlying = 1234.03)

df1 <- mutate(book, Value = `OI` * (Bid + Ask)/2)

df_call <- df1 %>% filter(call_put == "call")
df_put <- df1 %>% filter(call_put == "put")


#######1.2-total valuation####

cat(paste("Total call value is: ", sum(df_call$Value, na.rm=T)))
cat(paste("Total put value is: ", sum(df_put$Value, na.rm=T)))
cat(paste("Total portfolio value is: ", sum(df1$Value, na.rm=T)))

####1.3-open interest of in the money options####

call_oi<-sum((df_call%>%
      filter(Underlying>Strike))$OI, na.rm=TRUE)

put_oi<-sum((df_put%>%
                filter(Underlying<Strike))$OI, na.rm=TRUE)

cat(paste("Net Open interest of in the money call options: ", call_oi))
cat(paste("Net Open interest of in the money put options: ", put_oi))

#####1.4-

iv<-c()
sp<-c()

for(i in 1:nrow(df_put))
{
  row<-df_put[i,]
  if((row$call_put=="put")&(row$Strike<row$Underlying))
  {
    v<-GBSVolatility(row$`Last Price`, "p", row$Underlying, row$Strike,as.numeric((as.Date("2019-12-20"))-(as.Date("2019-09-16")))/365 ,r=0.03, b=0)
    
    iv<-c(iv, v)
    sp<-c(sp, row$Strike)
  }
  
}

for(i in 1:nrow(df_call))
{
  row<-df_call[i,]
  if((row$call_put=="call")&(row$Strike>row$Underlying))
  {
    v<-GBSVolatility(row$`Last Price`, "c", row$Underlying, row$Strike,as.numeric((as.Date("2019-12-20"))-(as.Date("2019-09-16")))/365 ,r=0.03, b=0)
    iv<-c(iv, v)
    sp<-c(sp, row$Strike)
  }
  
}

plot(sp, iv, xlab="Strike prices", ylab="Implied Volatility", main="Volatility smile",col="blue")
fit<-lm(iv~poly(sp,2,raw=TRUE))
xxx<-seq(600, 2000, length=90)
lines(xxx, predict(fit, data.frame(x=xxx)), col="orange")

