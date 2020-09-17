make_choice <- function(N, split_number) {
  input_sample <-sample(N,N,replace=FALSE)
  input_list <- list(0)
  count =0
  for (i in input_sample) {
    count = count +1
    input_list[count]=i
  }
  
  evaluation <- input_list[1:split_number]
  selection <-input_list[split_number+1:N]
  bestnumber <- max(unlist(evaluation))
  
  selected <- -1
  if (bestnumber == N) {
    return(FALSE)
  } else {
    for (i in selection){
      if (i > bestnumber){
        selected <-i
        break
      }
    }
  }
  
  # YY: consider the case that N appears in the evaluation group, so no item in selection is better than.
  # We end with choosing the last item.
  if (selected == -1) {
    selected <- input_list[N]
  }
  if (selected == N){
    return(TRUE)
  }else {
    return(FALSE)
  }
}

find_optimal <- function(N,calls) {
  count =0
  optimalN = 0
  for(i in 1:as.integer(N/2)) {
    foundN = 0
    for(j in 1:calls){
      if (make_choice(N,i)==TRUE){
        foundN = foundN +1
      }
      
    }
    if (foundN > count) {
      count <- foundN
      optimalN <- i
    }
  }
  return(optimalN)
}

#finding for N = 100, with 500 calls for each number:
find_optimal(100,500)
