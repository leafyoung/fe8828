library(timeDate)
library(timeSeries)
library(fBasics)
library(fOptions)
library(dplyr)

df <- data.frame(type = sample(c("c","p"), 100, replace=TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time=1,
                 r=0.01,
                 b=0,
                 sigma=0.3)

df1 <- mutate(df,value= GBSOption(TypeFlag = type, S = underlying, X = strike,
                                  Time = Time, r = r, b = b, sigma = sigma)@price) 

sum(df1$value)

