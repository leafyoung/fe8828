make_choice <- function(N, split_number){
  
  num_iters <- 1000
  population <- sample(1:N,N,replace=FALSE)
  is_right <- logical(length = num_iters)
  
  for (i in 1:num_iters){
    population <- sample(1:N,N,replace=FALSE)
    # YY: Below can be replaced by. optimal_candidate <- N
    optimal_candidate <- max(population)
    max_split_number <- max(population[1:split_number])
    # YY: okay. Below line looks right, a bit lengthy.
    choice_number <- split_number +
      which(population[(split_number+1):N] > max_split_number)[1]
    
    # YY: Good way to handle the not-found case.
    if (is.na(choice_number)){
      choice_number <- N
    } 
    
    is_right[i] <- (population[choice_number] == optimal_candidate)
  }
  
  mean(is_right)
}

N = 100
# YY: better split round number from N.
n_round <- 5000
split_choices <- numeric(length=n_round)
for (split_num in 1:n_round){
  split_choices[split_num] <- make_choice(N, split_num)
}

optimal_split_number <- match(max(split_choices), split_choices)
optimal_split_number
# YY: now I get 37.