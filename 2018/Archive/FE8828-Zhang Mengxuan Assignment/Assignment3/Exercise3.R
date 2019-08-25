#Exercise 3
library(fOptions)
library(dplyr)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)
View(df)
df2 <- mutate(df,value= GBSOption(TypeFlag = type, S = underlying, X = strike,
                            Time = Time, r = r, b = b, sigma = sigma)@price) 

group_by(df2) %>% summarize(`Sum of Portfolio`=sum(value))

#Assignment 1

##  Question 2 Assignment 1
# 1. find 10 findings
# age gender distribution
# do 1-2 very advanced level

## Question 3 Assignment 2
# price is $1066.15 as of what time
# use market price = (bid + ask)/2
# 1. copy data from nasdaq, to excel
# jump to second page, options expires on dec 14th c
# 
# 2.store into df formate, R studio, import from Excel
# rename the column
# 
# 3. 1.4 use out of money options