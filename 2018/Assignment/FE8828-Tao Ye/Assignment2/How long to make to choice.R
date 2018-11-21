make_choice <- function(N, split_number){
  
  num_iters <- 1000
  population <- sample(1:N,N,replace=FALSE)
  is_right <- logical(length = num_iters)
  
  for (i in 1:num_iters){
    population <- sample(1:N,N,replace=FALSE)
    optimal_candidate <- max(population)
    max_split_number <- max(population[1:split_number])
    choice_number <- split_number +
      which(population[(split_number+1):N] > max_split_number)[1]
    
    if (is.na(choice_number)){
      choice_number <- N
    } 
    
    is_right[i] <- (population[choice_number] == optimal_candidate)
  }
  
  mean(is_right)
}

N = 100
split_choices <- numeric(length=round(N/2))
for (split_num in 1:round(N/2)){
  split_choices[split_num] <- make_choice(N, split_num)
}

optimal_split_number <- match(max(split_choices), split_choices)
optimal_split_number
