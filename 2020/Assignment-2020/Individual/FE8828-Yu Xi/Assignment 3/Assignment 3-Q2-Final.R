library(conflicted) 
library(dplyr)
library(foptions)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")


#2.1 Cleaning the data
library(readxl)
data1 <- read_excel("/Users/yuxi/Desktop/FE8828 R/Assignment 3/Book option trades.xlsx")
data1<-mutate(data1,optionTypeC="c",optionTypeP="p",Underlying=1458.42,Today=as.Date("2020-10-02"))
data1<-mutate(data1,ExpDate = "Dec-18")
dataCall=select(data1,'ExpDate',Strike,`Open Int....7`,optionTypeC,Bid...4,Ask...5,Underlying,Today)
dataPut=select(data1,'ExpDate',Strike,`Open Int....14`,optionTypeP,Bid...11,Ask...12,Underlying,Today)

#2.2 Total Valuation of Call alone
x1=(as.numeric(dataCall$Bid...4)+as.numeric(dataCall$Ask...5))/2
y1=as.numeric(dataCall$`Open Int....7`)
totalValCall=x1*y1


#Total Valuation of Put alone
x2=(as.numeric(dataPut$Bid...11)+as.numeric(dataPut$Ask...12))/2
y2=as.numeric(dataPut$`Open Int....14`)
totalValPut=x2*y2

#Total Valuation of Call and Put
totalValCallPut=totalValCall+totalValPut

#2.3 Find those in the money
#Calls
dataCall2<-dataCall[dataCall$Strike<dataCall$Underlying,]
totOpenIntC=sum(as.numeric(dataCall2$`Open Int....7`),na.rm = TRUE)

#Puts
dataPut2<-dataPut[dataPut$Strike>dataPut$Underlying,]
totOpenIntP=sum(as.numeric(dataPut2$`Open Int....14`),na.rm = TRUE)

#2.4 Volatility Calculation & Plotting
#Assume r=0.03,b=0
data1$Last...2=as.numeric(data1$Last...2)
data1$Last...9=as.numeric(data1$Last...9)
data1[complete.cases(data1),]

data2<-mutate(data1,vPrice=0)%>%
  mutate(data1, vPrice=ifelse(Strike<Underlying,x2,x1))

with(data2,mapply(GBSVolatility,vPrice,"c",1452.48,Strike,(as.Date("2020-12-18")-as.Date("2020-09-29"))/365,0.03,0))
a<-with(data2,mapply(GBSVolatility,vPrice,"c",1452.48,Strike,(as.Date("2020-12-18")-as.Date("2020-09-29"))/365,0.03,0))
plot(a,data2$Strike)

