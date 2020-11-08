make_choice <- function(N, split_number) {
  input_list <- sample(1:N, N, replace=FALSE)
  eval_group <- input_list[1:split_number]
  selc_group <- input_list[-(1:split_number)]
  
  best <- max(eval_group)
  
  for (i in selc_group) {
    if (i>best) {
      return(i)
    }
  }
  return(0)
}

make_choice_repeat <- function(N, split_number, M) {
  count <- 0
  for (i in 1:M) {
    if (make_choice(N, split_number)==N) {
      count <- count + 1
    }
  }
  return(count/M)
}

find_optimal <- function(N, M) {
  optimal <- 0
  optimal_prob <- 0
  for (split_number in 1:floor(N/2)) {
    prob <- make_choice_repeat(N, split_number, M)
    if (prob > optimal_prob) {
      optimal_prob <- prob
      optimal <- split_number
    }
  }
  return(list(optimal, optimal_prob))
}

result = find_optimal(3, 10000)
cat( "Optimal split when N=3 is ", result[[1]], ". Optimal probability is ", result[[2]], '\n' )
result = find_optimal(10, 10000)
cat( "Optimal split when N=10 is ", result[[1]], ". Optimal probability is ", result[[2]], '\n' )
result = find_optimal(100, 10000)
cat( "Optimal split when N=100 is ", result[[1]], ". Optimal probability is ", result[[2]], '\n' )