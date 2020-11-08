make_choice <- function(N, split_number){
  
  loops <- 0
  success <- 0
  
  while(loops < N){
    input_list <- sample(1:N, N, replace = FALSE)
    evaluation <- input_list[1:split_number]
    x <- split_number + 1
    selection <- input_list[x:length(input_list)]
    best_evaluation <- max(evaluation[1:split_number])
  
    for(i in 1:length(selection)){
      if(selection[i] > best_evaluation){
        score <- selection[i]
        number <- i
        break
      }
      else {
        score <- 0
      }
    }
  
    if(score == N){
      success <- success + 1
    }
  
    loops <- loops + 1
  }
  
  prob <- success/N
  #print(best_evaluation)
  return(prob)
}

find_optimal <- function(N){
  y <- 0
  optimal <- 0
  temp <- vector()
  for(j in 1:(N/2)){
    temp[j] <- make_choice(N, j)
    if(temp[j] > y){
      y <- temp[j]
      optimal <- j
    }
  }
  return(optimal)
}

find_optimal(3)
find_optimal(10)
find_optimal(100)






