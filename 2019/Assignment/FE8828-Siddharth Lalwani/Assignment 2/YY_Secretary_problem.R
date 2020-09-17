#Secretary problem
make_choice <- function(N,split_number)
{
  input_list<- sample(1:N,N,replace=FALSE)
  mx<- -1
  eval_group <- input_list[1:split_number]
  for(i in eval_group)
  {
    if(i>mx)
    {
      mx <- i
    }
  }
  selection_group <- input_list[(split_number+1):N]
  for(i1 in selection_group)
  {
    
    if(i1>mx)
    {
      return(i1)
    }
  }
  # If no one better than selection criteria,we return -1
  # YY: we have to select one, so the last item become our choice.
  return(input_list[N])
  # YY: return(-1)
}

find_optimal <- function(N)
{
  mx <- -1
  optimal_split <- -1
  for(split_number in 1:(N/2))
  {
    K <- 5000 #We repeat the process K times
    count <- 0 # No. of times we get N (100)
    for(j in 1:K)
    {
      if(make_choice(N,split_number)==N)
      {
        count <- count+1
      }
    }
    if(count>mx)
    {
      mx<-count
      optimal_split <- split_number
    }
    #cat(paste0(count," ",split_number,"\n"))
    }
  
  return(optimal_split)
}


#Driver Code
N <- 100 #We consider the case of hundred secretaries
cat(paste0("Optimal split for N=100 will be at ",find_optimal(100)))
