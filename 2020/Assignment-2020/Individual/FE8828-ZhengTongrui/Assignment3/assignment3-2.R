library(lubridate)
library(dplyr)
library(bizdays)
library(fOptions)
library(ggplot2)
##load data first
##data cleaning
colnames(Nasdaq)
Nasdaq$`Open Int....7`<-as.integer(Nasdaq$`Open Int....7`)
df1<-select(Nasdaq,"Exp. Date","Strike","Open Int....7","Bid...4","Ask...5") %>% mutate(OptionType="c") %>% mutate(Underlying=1458.42) %>% mutate (Today=as.Date("2020-10-02"))
df2<-select(Nasdaq,"Exp. Date","Strike","Open Int....14","Bid...11","Ask...12") %>% mutate(OptionType="p")  %>% mutate(Underlying=1458.42) %>% mutate (Today=as.Date("2020-10-02"))
df<-bind_rows(df1,df2)

colnames(df)
df$`Open Int.`[which(is.na(df$"Open Int."))]<-0

df<-mutate(df,value=df$`Open Int.`*(Bid+Ask)/2)
##2.2calculate total value
df3<-dplyr::filter(df,OptionType=="c")%>% rename(valuec=value)
valuec<-sum(df3$valuec)
df4<-filter(df,OptionType=="p")%>% rename(valuep=value) 
valuep<-sum(df4$valuep)
df5<-left_join(df3,df4,by="Strike")%>% mutate(total_value=valuec+valuep) %>% select("Exp. Date.x","Strike",total_value)
cpvalue<-valuec+valuep

##2.3calculate in the money
df31<-mutate(df3,flag=ifelse(Strike<Underlying,1,0))
df3_in_the_money<- dplyr::filter(df31,flag==1) %>% dplyr::filter(OptionType=="c")
df3_sum<-sum(df3_in_the_money$`Open Int.`)
df41<-mutate(df4,flag=ifelse(Strike>Underlying,1,0))
df4_in_the_money<- dplyr::filter(df41,flag==1) %>% dplyr::filter(OptionType=="p")
df4_sum<-sum(df4_in_the_money$`Open Int.`)

##2.4plot
colnames(df)
df_vol<-df %>% rowwise() %>% mutate(volatility=GBSVolatility((Bid+Ask)/2,OptionType,Underlying,Strike,as.numeric((as.Date("2020-12-18")-as.Date("2020-10-02")))/365,r=0.03,b=0)) %>% ungroup()
data<-select(df_vol,Strike,OptionType,volatility,Underlying)
df3_notin_the_money<-mutate(data,flag=ifelse(Strike<Underlying,1,0))%>% dplyr::filter(flag==0) %>% dplyr::filter(OptionType=="c")%>% select(Strike,volatility)
df4_notin_the_money<-mutate(data,flag=ifelse(Strike>1458.42,1,0))%>% dplyr::filter(flag==0) %>% dplyr::filter(OptionType=="p")%>% select(Strike,volatility)
df8<-bind_rows(df4_notin_the_money,df3_notin_the_money) %>% select(Strike,volatility) %>% arrange(Strike)

ggplot(data=df8) +
  geom_line(aes(Strike,volatility))



                            