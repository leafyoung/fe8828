make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  eva_group <- input_list[1:split_number]
  sel_group <- input_list[(split_number+1):N]
  best <- max(eva_group)
  flag <- 0
  for (s in sel_group){
    if(s > best){
      choice <- s 
      flag <- 1
      choice
      break
    }
  }
  if(!flag) 
    choice <- sel_group[length(sel_group)]
    choice
}

find_optimal <- function(N){
  prob <- list()
  for (i in 1:(N %/% 2 + 1)){
    count = 0
    for (n in 1:100){
      choice <- make_choice(N,i)
      if(choice == N)
        count = count + 1
    }
    prob[[i]] <- (count/100)
  }
  split_optimal <- match(max(unlist(prob)),unlist(prob))
  split_optimal
}

split <- find_optimal(100)


