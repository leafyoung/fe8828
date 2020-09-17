sex_ratio<-function(n, trials)
{
  probl<-list()
  for(x in c(1:n))
  {
    probl<-c(probl, (0.5)^x)
  }
  distribution<-list()
  
  for(k in 1:trials)
  {
    kids<-c(1:n)
    tot<-list()
    for(nn in c(1:n))
    {
      sam <- sample(c(1:n), 1, replace=FALSE,probl)
      tot<-c(tot, sam)
    }
    total<-sum(unlist(tot))
    girls<-total-n
    # boys2girls <- n/girls
    boys2girls <- n/girls
    distribution<-c(distribution, boys2girls)
  }
  
  x<-unlist(distribution)
  hist(x, main="sex_ratio",xlab="ratio",
              xlim=c(0,2),
              col="darkmagenta",
              freq=FALSE, breaks=50)
}

#plots the distribution
sex_ratio(10,1000)
