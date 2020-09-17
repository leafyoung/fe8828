#Assignment 2, Q2: Secretary question

make_choice <- function(N, split_number){
  input_list <- sample(1:N, N)
  eval_best <- max(input_list[1:split_number])  #Best score in evaluation group
  secretary_score <- input_list[N]   #Hire the last candidate after going through all candidates
  for (i in (split_number+1):N) {
    if (input_list[i] > eval_best) {
      secretary_score <- input_list[i]
      break
    }
  }
  return(secretary_score)
}

find_optimal <- function(N){
  if(N == 1){
    return("No need to split since only 1 candidate.")
  }
  
  if(N == 2){
    return("Chance is 50/50.")
  }
  
  list_of_split <- c()
  for (split_number in 1:ceiling(N/2)) {
    success <- 0
    #simulate 5,000 times
    for (n in 1:5000){
      secretary_score <- make_choice(N, split_number)
      if (secretary_score == N){
        success <- success + 1
      }
    }
    list_of_split[split_number] <- success/5000
    #cat(split_number, " ", list_of_split[split_number],"\n")
  }
  #cat(paste0(list_of_split),"\n") 
  return(c(1:ceiling(N/2))[list_of_split == max(list_of_split)])
}

find_optimal(3)
find_optimal(10)
find_optimal(100)
