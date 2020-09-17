library(fOptions)
library(ggplot2)

#1
goog <- read.csv("D:/A/NTU-MFE/courses/MT2/FE8828 Programming Web Applications in Finance (E)/assignment/Assignment4/Assignment4/goog.csv", sep=",")

#2
totalvaluation_call <- 0
totalvaluation_put <- 0
totalvaluation_candp <- 0

for(i in 1:80)
  totalvaluation_call <- totalvaluation_call + goog$Open.Interest[i] * (goog$Bid[i] + goog$Ask[i]) / 2
for(i in 81:162)
  totalvaluation_put <- totalvaluation_put + goog$Open.Interest[i] * (goog$Bid[i] + goog$Ask[i]) / 2
for(i in 1:162)
  totalvaluation_candp <- totalvaluation_candp + goog$Open.Interest[i] * (goog$Bid[i] + goog$Ask[i]) / 2

cat("total valuation of call alone = ", totalvaluation_call,'\n')
cat("total valuation of put alone = ", totalvaluation_put,'\n')
cat("total valuation of call and put = ", totalvaluation_candp,'\n')

#3
OpenInterest_call <- 0
OpenInterest_put <- 0
OpenInterest <- 0
for(i in 1:80) {
  if(goog$Strike[i] < goog$Underlying[i])
    OpenInterest_call <- OpenInterest_call + goog$Open.Interest[i]
}
for(i in 81:162)
{
  if(goog$Strike[i] > goog$Underlying[i])
    OpenInterest_put <- OpenInterest_put + goog$Open.Interest[i]
}
OpenInterest <- OpenInterest_call + OpenInterest_put
cat("total open interest of those in the money = ", OpenInterest,'\n')


#4
vol <- c()
stri <- c()
j <- 1
for(i in 81:162)
{
  if(goog$Strike[i] < goog$Underlying[i])
  {
    vol[j] <- GBSVolatility((goog$Bid[i] + goog$Ask[i])/2, "p", 1202.31, goog$Strike[i],
                            as.numeric((as.Date("2019-12-20") - as.Date("2019-10-10")))/365,
                            r = 0.03, b = 0)
    stri[j] <- goog$Strike[i]
    j <- j+1
  }
}
for(i in 1:80)
{
  if(goog$Strike[i] > goog$Underlying[i])
  {
    vol[j] <- GBSVolatility((goog$Bid[i] + goog$Ask[i])/2, "c", 1202.31, goog$Strike[i],
                            as.numeric((as.Date("2019-12-20") - as.Date("2019-10-10")))/365,
                            r = 0.03, b = 0)
    stri[j] <- goog$Strike[i]
    j <- j+1
  }
}
volcurve <- data.frame(vol, stri)
ggplot(volcurve, aes(stri, vol)) + 
  geom_point()

