
set.seed(1000)

make_choice<-function(n, split_number)
{
  best<-list()
  
  trials<-500
  
  for(nn in 1:trials)
  {
    group<-sample(c(1:n), split_number, replace=FALSE)
    tot<-sample(c(1:n),n, replace=FALSE)
    new_tot<-tot[!tot %in% group]
    found <- FALSE
    for(zz in new_tot)
    {
      if(zz>max(group))
      {
        best<-c(best, zz)
        found <- TRUE
        break
      }
    }
    # if (!found) {
    #  best<-c(best, last(new_tot))
    # }
  }
  
  count<-0
  for(zz in best)
  {
    if(zz==n)
    {
      count<-count+1
    }
  }
  best_split_percentage<-(count/trials)
  return(best_split_percentage)
  
}

find_optimal<-function()
{
  optimal_split<-list()
  #plug the total number of candidates
  n <- 100
  split_number<-n%/%2
  for(split_num in c(1:split_number))
  {
    optimal_split<-c(optimal_split, make_choice(n, split_num))
  }
  
  cat(paste("The optimal split is: ", which.max(optimal_split), "chance of succeeding: ", max(unlist(optimal_split))))
}

find_optimal()

