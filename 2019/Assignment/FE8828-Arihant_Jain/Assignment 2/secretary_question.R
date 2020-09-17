# 1 denote best rank and N denote worst
make_choice <- function(N, split_number)
{
  input_list<-sample(c(1:N))
  evaluation<-c(input_list[1:split_number])
  selection<-c(input_list[(split_number+1):N])
  
  best_in_evaluation_group<-min(evaluation)
  
  for(i in 1:(N-split_number))
  {
    current_rank<-selection[i]
    if(current_rank < best_in_evaluation_group)
    {
      return(current_rank)
    }	
  }
  return(N)
}

find_optimal<-function(N)
{
  part_1_iterations<-100
  part_2_iteration <- 100
  optimum_split <- 0
  count_for_best_candidate_seclection <- 0
  for(ii in 1:part_2_iteration)
  {
    count_vec<-c(rep(0,N))
    for(i in 1:ceiling(N/2))
    {
      for(j in 1:part_1_iterations)
      {
        output<-make_choice(N,i)
        if(output==1)
        {
          count_vec[i]<-count_vec[i]+1
        }
      }
    }
    optimum_split<-optimum_split+which.max(count_vec)
    count_for_best_candidate_seclection <- count_for_best_candidate_seclection + sum(count_vec)
  }
  cat(paste("Probablility for selecting best candidate when N = ",N," is ",count_for_best_candidate_seclection/(part_2_iteration*part_1_iterations*ceiling(N/2)),"\n"))
  cat(paste("Optimum Split for N = ",N," is ",optimum_split/part_2_iteration,"\n"))
}

find_optimal(3)
find_optimal(10)
find_optimal(100)
