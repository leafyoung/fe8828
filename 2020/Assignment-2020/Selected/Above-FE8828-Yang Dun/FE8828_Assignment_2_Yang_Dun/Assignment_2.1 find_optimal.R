
#find the best split size for N participants that maximizes the probablity of finding N

make_choice <- function(N,split_number)
{
  total_grp <- sample(1:N,N,replace=F)
  eva_grp <- total_grp[1:split_number]
  select_grp <- total_grp[(split_number+1):length(total_grp)]
  
  for(i in seq_along(select_grp))
  {
    if(select_grp[i]>max(eva_grp))
    {
      return(select_grp[i])
    }
  }
  #if max is in the eva group, return the last of select group
  return(select_grp[length(select_grp)])
}

  #find the probability of finding N given split_number
Prob_N <- function(N,split_number,trial)
{
  counter = 0;
  for(i in 1:trial)
  {
    if(make_choice(N,split_number)==N)
    {
      counter = counter+1
    }
  }
  return(counter/trial)
}
  #split size runs from 1 to split_max, each split_size is simulated "trial" times to find the probablity of finding N
  #the function returns a data.frame of best split_size and probability of getting n
find_optimal <- function(N,split_max,trial){
  result <- data.frame()
  for(i in 1:split_max)
  {
  result <- rbind(result,c(i,Prob_N(N,i,trial)))
  }
  colnames(result) <- c("Split_num","prob")
  return(result[which.max(result$prob),])
}

find_optimal(100,40,1000)
