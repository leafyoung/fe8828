library(purrr)

#### Step 1

make_choice <- function(N, split_number) {
  input_list = sample(1 : N, N)
  evaluation_group = input_list[1 : split_number]
  selection_group = input_list[(split_number + 1) : N]
  best = max(evaluation_group)
  select = selection_group[which(selection_group >= best)[1]]
  ifelse(is.na(select), 0, select)
}

count <- 0
split = round(runif(1, 1, 50))
n_iter = 1000

#the probability of getting N
length(which(purrr::map(rep(100, n_iter), make_choice, split_number = split) == 100))/n_iter 

#### Step 2

find_optimal <- function(N, n_iter){
  count <- rep(0, N/2)
  for (i in 1:N/2)
    count[i] <- length(which(purrr::map(rep(100, n_iter), make_choice, split_number = i) == 100))/n_iter
  which.max(count)
}

#the optimal value for the split for getting N
find_optimal(100, 5000)
  