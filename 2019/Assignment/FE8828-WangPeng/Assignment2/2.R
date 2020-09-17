make_choice <- function(N, split_number){
  choice <- 0
  input_list <- sample(1:N,N, replace = FALSE)
  mx <- max(input_list[1:split_number])
  for(mm in (split_number+1) : N){
    if(mx <= input_list[mm]){
     choice <- input_list[mm]
     return(choice)
    }
  }
  # YY: return last item
  return(input_list[N])
}

find_optimal<- function(N){
  probability <- rep(0,N%/%2,replace =FALSE)
  
  for(ii in 1:N%/%2){
  choice_simulation <- sapply(1:500, function(x){make_choice(N,split_number = ii)})
  perfect_choice <- 0
  for(jj in 1:500){
    if(choice_simulation[jj] == N){
      perfect_choice <- perfect_choice + 1
    }
  }
  probability[ii] <- perfect_choice / 500
  }
  return(which(max(probability) == probability))
}

find_optimal(100)
