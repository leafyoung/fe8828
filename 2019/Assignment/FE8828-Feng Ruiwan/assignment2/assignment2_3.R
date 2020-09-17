library(ggplot2)
library(tidyverse)
prob <- list()
ratio <- list()
for (i in 1:10000){
  r <- sample(0:10,10,replace = TRUE, prob=c(1/2,1/2,1/4,1/8,1/16,1/32,1/64,1/128,1/256,1/512,1/1024))
  g<- sum(r)
  ratio[[i]] <- g/(g+10)
}
Ratio_girlstoboys <- unlist(ratio)
hist(Ratio_girlstoboys, xlab = "girls/boys")
