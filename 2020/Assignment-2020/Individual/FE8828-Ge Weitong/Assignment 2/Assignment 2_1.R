make_choice <- function(N, split_number)
  {
  input_list <- sample(1:N, N, replace = FALSE)
  eva_group <- input_list[1:split_number]  #split
  sel_group <- input_list[(split_number+1):N]
  best <- max(eva_group)  
  success <- 0
  for (x in sel_group){
    if(x > best){
      choice <- x 
      success <- 1  #find the best candidate
      choice   
      break
    }
  }
  if(!success) 
    choice <- sel_group[length(sel_group)]
  choice
}

find_optimal <- function(N){
  prob <- list()
  for (i in 1:(N %/% 2 + 1)){
    count = 0
    for (n in 1:10000){    #simulate 10000 times
      choice <- make_choice(N,i)
      if(choice == N)
        count = count + 1
    }
    prob[[i]] <- (count/10000) #100
  }
  split_optimal <- match(max(unlist(prob)),unlist(prob))
  print(split_optimal)

}

split <- find_optimal(100) #call
split <- find_optimal(3)

