
x=c()

for(cc in 1:1000) {
  girls<- 0
  for (f in 1:10)
  {
    gender <- sample(0:1, 1, replace=TRUE)
    # YY: change i to gender
    while(gender < 1)
    {
      girls = girls + 1      
      gender <- sample(0:1, 1, replace=TRUE)
    }
    f <- f+1
  }
  ratio <- girls/(girls+10) #girls/boys
  x<-c(x,ratio)
}

hist(x)



