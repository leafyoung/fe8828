#set.seed(1234)
make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  eval_group <- input_list[1:split_number]
  selc_group <- input_list[split_number+1:(N-split_number)]
  evaluation <- max(eval_group)
  best <- N
  for (i in c(1:(N-split_number))){
    if (selc_group[[i]] > evaluation){
      select_one <- selc_group[[i]]
      break
    }
    else if (i == (N-split_number)){
      select_one <- 0
    }
  }
  if (select_one == best)
    success <- TRUE
  else
    success <- FALSE
  success
}


make_choice_pro <- function(N, split_number){
  sum = 0
  for (i in c(1:10000)){
    if (make_choice(N, split_number) == TRUE){
      sum = sum + 1
    }
  }
  (sum/10000)
}

find_optimal <- function(N){
  max <- 0
  best_number <- 0
  for (split_number in c(1: floor(N/2))){
    if (make_choice_pro(N, split_number) > max){
      max = make_choice_pro(N, split_number)
      best_number = split_number
    }
  }
  best_number
}

# Theoretically should be 1
find_optimal(3)
# Theoretically should be 4
find_optimal(10)
# Theoretically should be 37
find_optimal(100)

