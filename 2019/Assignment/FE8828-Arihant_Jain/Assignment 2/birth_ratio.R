birth_ratio<-function(N)
{
  iterations <- 10000
  num_of_girls <- c(rep(0,iterations))
  girls_prcnt <- c(rep(0,iterations))
  for (i in 1:iterations)
  {
    count_children_in_family <- c(rep(0,N))
    for (j in 1:N)
    {
      # considering 0 as girl and 1 as boy
      while(TRUE)
      {
        gender <- sample(c(0:1),1)
        count_children_in_family[j] <- count_children_in_family[j] + 1
        if (gender==1)
        {
          break
        }
      }
    }
    num_of_girls[i] <- sum(count_children_in_family) - N
    girls_prcnt[i] <- num_of_girls[i]/sum(count_children_in_family)
  }
  girls_to_boys_ratio <- num_of_girls/N
  cat("Expected girls percentage = ",round(100*mean(girls_prcnt),2),"%\n")
  cat("Mean of ratio = ", round(mean(girls_to_boys_ratio),4),"\n")
  cat("Std. Dev. of ratio = ", round(sd(girls_to_boys_ratio),4),"\n")
  hist(girls_to_boys_ratio, prob=TRUE)
  lines(density(girls_to_boys_ratio))
}

birth_ratio(10)
