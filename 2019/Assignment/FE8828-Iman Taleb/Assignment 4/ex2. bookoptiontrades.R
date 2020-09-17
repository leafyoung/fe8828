library(fOptions)
library(dplyr)
library(ggplot2)

#Valuation Calculation
callputs<-mutate(callputs,Value=`Open Interest`*(Bid+Ask)/2)

#Total Valuation of Calls and Puts alone
group_by(callputs,Type)%>%
  summarise(`Total Valuation`=sum(Value))

#Total Valuation of both calls and puts
summarise(callputs,Total=sum(Value))

#In the money
atm<-callputs %>%
  filter((Type=="c" & (Strike<Underlying))|(Type=="p" & (Strike>Underlying)))

#Total Open Interest
summarise(atm,`At The Money`=sum(`Open Interest`))

#Plot Strike vs Volatility
vol<-callputs %>%
  filter((Type=="c" & (Strike>Underlying))|(Type=="p" & (Strike<Underlying)))

# YY: need to use rowwise
vol<-mutate(vol,Volatility=GBSVolatility(Value,Type,Strike,Underlying,
                                                   as.numeric((as.Date("2019-12-20")-as.Date(Expiry)))/365,
                                                   r=0.03,b=0))
vol %>%
  ggplot(aes(x=Strike,y=Volatility))+
  geom_point()+
  geom_smooth()



