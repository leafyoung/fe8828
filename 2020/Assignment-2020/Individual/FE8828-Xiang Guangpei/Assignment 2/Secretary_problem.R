make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  evaluation_group <- input_list[1:split_number]
  selection_group <- input_list[split_number+1:N]
  best_in_evaluation <- max(evaluation_group)
  best <- N
  
  for (i in 1:(N-split_number)){
    if (selection_group[[i]] >= best_in_evaluation){
      choosen <- selection_group[[i]]
      break
    }
    else if (i == (N-split_number)){
      return(FALSE)
    }
  }
  if (choosen == best)
    return(TRUE) 
  else
    return(FALSE) 
}


find_possibility <- function(N, split_number){
  sum = 0
  for (i in 1:test_number){
    if (make_choice(N, split_number) == TRUE){
      sum = sum + 1
    }
  }
  return(sum/test_number)
}

find_optimal <- function(N){
  max_p <- 0
  optimal_value <- 0
  for (i in 1: (N/2)){
    if (find_possibility(N, i) > max_p){
      max_p = find_possibility(N, i)
      optimal_value = i
    }
  }
  return(optimal_value)
}

test_number <-20000
find_optimal(3)
find_optimal(10)
find_optimal(100)