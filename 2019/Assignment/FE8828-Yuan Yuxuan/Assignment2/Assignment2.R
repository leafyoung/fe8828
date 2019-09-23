#Question: Secretary Problem

#Step1
make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  evaluation_group <- input_list[0:split_number]
  selection_group <- input_list[(split_number+1):(length(input_list))]
  max_score <- 0
  for(e in evaluation_group){
    if(e>max_score){
      max_score <- e
    }
  }
  
  for(s in selection_group){
    if(s >= max_score){
      return(s)
    }
  }
}

getProbability <- function(N, iteration, split_number){
  nGetN <- 0
  for(i in 0:iteration){
    res <- make_choice(N, split_number)
    if(!is.null(res)){
      if(res == N){
        nGetN <- nGetN+1
      }
    }
  }
  return(nGetN/N)
}

#Step2
#What does the optimal result should get from? Maximum probability to get N or maximum the expected score?
find_optimal <- function(N){
  maxProb <- 0 
  optima_split <- 0
  iteration <- 100 #In fact, hundreds iteration is not enough because the result is not constant throughout the running
  for(i in 1:round((N/2), 0)){
    current_prob <- getProbability(N, iteration, i)
    if(current_prob > maxProb){
      maxProb <- current_prob
      optima_split <- i
    }
  }
  return(optima_split)
}

#Final Solution (Hint)
result <- list() #key is N, value is the corresponding optimal solution
for(i in 3:100){
  result[[i]] <- find_optimal(i)
}

