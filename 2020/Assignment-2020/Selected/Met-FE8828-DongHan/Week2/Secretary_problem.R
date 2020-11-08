# generate candidates
candidates <- sample(1:100, 100, replace = FALSE)
candidates

make_choice <- function(N, split_number) {
  input_list <- sample(1:N, replace = FALSE)
  #split into 2 groups
  split <- split(input_list, rep(1:2, c(split_number, N-split_number)))
  eval_group <- split$`1`
  sel_group <- split$`2`
  #find best in eval group and match with selection group
  selected <- -1
  best_eval <- max(eval_group)
  for (i in sel_group) {
    if (i >= best_eval) {
      selected  <- i
      break
    }
  }
  selected
}


simulations <- 10000
prob <- c()

find_optimal <- function(N) {
  for (i in 1:ceiling(N/2)) {
    success <- 0
    for (n in 1:simulations) {
      if (make_choice(N,i)==N) {
        success <- success +1
      }
    }
    #the probability of getting N
    prob[i] <- success/simulations
    cat(i, " ", prob[i], "\n")
  }
  cat("Max Probability: ", max(prob), "\n")
  cat("Optimal Split Size: ", which(prob == max(prob)))
}

find_optimal(3)
# Max Probability:  0.4989 
# Optimal Split Size:  1
find_optimal(10)
# Max Probability:  0.3999 
# Optimal Split Size:  3
find_optimal(100)
# Max Probability:  0.3782 
# Optimal Split Size:  35








