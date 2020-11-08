make_choice <- function(N, split_number)
{
  sum <- 0
  for(k in 1:100000)
  {
    sec <- list(c(sample(1:N,N,replace=F)))
    best <- 0
    for (i in 1:split_number)
    {
      if(sec[[1]][i]>best)
      {
        best<-sec[[1]][i]
      }
    }
    for (j in (split_number+1):N)
    {
      if(sec[[1]][j]>best)
      {
        best<-sec[[1]][j]
        break
      }
    }
    if(j==N)
    {
      best<-sec[[1]][N]
    }
    if(best==N)
    {
      sum <- sum + 1
    }
  }
  return(psum/100000)
}

find_optimal<-function(N)
{
  prob <- 0
  for(spl in 1:(N/2))
  {
    tent=make_choice(N,spl)
    if(tent>prob)
    {
      prob<-tent
      OptSpl<-spl
    }
  }
  return(OptSpl)
}

find_optimal(100)