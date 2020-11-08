make_choice <- function(N, split_number){
  list_input <- sample(1:N, N, replace = FALSE)
  flag <- 0   # flag marks whether find a better one in selection froup
  if (split_number == 1){
    evaluation_group <- list_input[1]
  }
  else{
    evaluation_group <- list_input[c(1:split_number)]
  }
  t <- split_number+1
  selection_group <- list_input[t:N]

  best_evaluation <- max(evaluation_group)
  best <- best_evaluation
  
  for (i in selection_group){
    if (i >= best){
      best <- i
      flag <- (1)
      break
    }
  }
  if (flag == 1){
    return(best)
  }
  else{
    return(0)
  }
}


# Find the possibility of finding the best with N and split number
find_possibility <- function(N, split_number){
  success <- 0
  for (i in 1:simulation_time){
    best <- make_choice(N,split_number)
    if (best == N){
      success <- success + 1
    }
  }
  return(success/simulation_time)
}


find_optimal <- function(N){
  max_p <- 0
  for (i in 1:(N/2)){
    p <- find_possibility(N, i)
    if (p > max_p){
      best_split <- i
      max_p <-  p
    }
  }
  cat("For N=",N)
  cat(", the best split number is ",best_split)
  cat(", with probability of getting N around ",max_p)
}

# 2000 times of simulations
simulation_time <- 2000

# N=3, the answer is 1
# N=10, the answer is ranges from 3 to 5
# N=100, the answer is ranges from 30 - 40

sprintf("After %s times of simulation: ",simulation_time)

find_optimal(3)    
find_optimal(10)   
find_optimal(100)  

