
make_choice <- function(N, split_number){
  success <- 0
  for (t in 1:1000){
    input_list <- sample(1:N,N,FALSE)
    e <- input_list[c(1:split_number-1)]
    s <- input_list[c(split_number:N)]
    benchmark <- max(e)
    choice_num <- 0
    for (i in 1:length(s)){
      if (s[i] >= benchmark){
        choice_num <- s[i]
        break
      }
    }
    if (choice_num == N){
      success <- success + 1
    }
  }
  probability <- success/1000
  return(probability)
}

find_optimal <- function(N){
  results <- seq(1,N/2)
  for(i in 1:(N/2)){
    results[[i]] <- make_choice(N, i)
  }
  return(which.max(results))
}

find_optimal(3)
find_optimal(10)
find_optimal(100)
