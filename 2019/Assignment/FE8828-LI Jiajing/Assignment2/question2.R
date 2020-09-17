make_choice <- function(N, split_number){
  input_list <- sample(1:N, size = N, replace = FALSE, prob = NULL)
  eva <- input_list[1:split_number]
  sel <- input_list[(split_number+1):N]
  max <- max(eva)
  best <- 0
  for(i in sel){
    if(i >= max){
      best <- i
      break
    }
  }
  if (best == 0)
    best <- sel[[N - split_number]]
  best
}


find_optimal <- function(N,M){
  prob <- list()
  for(i in 1:(N/2)){
    n <- 0
    for(j in 1:M){
      best <- make_choice(N, i)
      if(best == N)
        n <- n+1
    }
    prob[[i]] <- n/M
  }
  optimal_prob <- 0
  for(i in 1:(N/2)){
    if(optimal_prob <= prob[[i]])
      optimal_prob <- prob[[i]]
  }
  for(k in 1:(N/2)){
    if(prob[k] == optimal_prob)
      break
  }
  cat("optimal split is", k,"\n")
  cat("optimal probability is", optimal_prob)
}

find_optimal(100, 1000)


