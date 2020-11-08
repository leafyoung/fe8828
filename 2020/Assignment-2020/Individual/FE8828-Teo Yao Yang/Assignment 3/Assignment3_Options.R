library(tidyverse)
library(ggplot2)
library(ggfortify)
library(gridExtra)
library(caTools)
library(broom)
library(reticulate)
library(summarytools)
library(fOptions)

#2.1
data <- read.csv("C://Users/teoya/Desktop/Web App/optiondata.csv", na.strings="--")
data <- data[-1,] # remove first row 
data <- data %>% replace(is.na(.), 0) # convert NA to zero
call <- cbind(data[,1:8],OptionType="c") # create call df
put <- cbind(Exp..Date=data$Exp..Date,data[,9:ncol(data)],Strike=data$Strike, OptionType="p") #create put df
colnames(put) <- colnames(call)
data <- rbind(call,put) #combine call and put
data <- data %>% select(Exp..Date,Strike,Open.Int.,OptionType,Bid,Ask)
data <- cbind(data,Underlying=1458.42,Today=as.Date("2020-10-02")) #add underlying and today

#2.2
data <- data %>% mutate(Valuation=Open.Int.*(Bid+Ask)/2)
answer <- data %>% group_by(OptionType) %>% summarize(TotalVal=sum(Valuation)) %>% ungroup()
add <- c("Total", colSums(answer[,2]))
answer <- rbind(answer,add)
answer$TotalVal <- as.numeric(answer$TotalVal)
answer

#2.3
attach(data)
ITM <- ifelse(OptionType=="C",ifelse(Strike<Underlying,1,0),ifelse(Strike>Underlying,1,0))
data <- cbind(data,ITM)
OI <- data %>% group_by(ITM) %>% summarize(TotalOI=sum(Open.Int.))
print(paste("Total OI for ITM option is",OI[2,2]))      

#2.4
names(data)
put <- put %>% rowwise() %>% mutate(Price=ifelse(Strike<1458.42,mean(Bid,Ask),0))
call <- call %>% rowwise() %>% mutate(Price=ifelse(Strike>1458.42,mean(Bid,Ask),0))
data <- cbind(data,cPrice=call$Price,pPrice=put$Price)
data <- data %>% mutate(Px=cPrice+pPrice)

data <- data %>% rowwise() %>% mutate(cVol=GBSVolatility(Px, "c", 1458.42, Strike,
              as.numeric((as.Date("2020-12-18") - as.Date("2020-10-03")))/365,
              r = 0.03, b = 0),pVol=GBSVolatility(Px, "p", 1458.42, Strike,
                                                  as.numeric((as.Date("2020-12-18") - as.Date(Today)))/365,
                                                  r = 0.03, b = 0))
data <- data %>% rowwise() %>% mutate(Vol=ifelse(Strike<Underlying,pVol,cVol))
write.csv(data,"C://Users/teoya/Desktop/Web App/test1.csv")
ggplot(data,aes(Strike,Vol)) + geom_line()
