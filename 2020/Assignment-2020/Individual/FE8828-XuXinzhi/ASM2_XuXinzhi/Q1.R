make_choice <- function(N, split_number){
  inputlist <- sample(1:N,N,replace = T)
  sub1 <- inputlist[1:split_number] #evaluation group
  sub2 <- inputlist[(split_number+1):N] #selection group
  max_eva <- max(sub1)
  is_success <- FALSE
  for(i in 1:(N-split_number)){
    if(sub2[i] >= max_eva)
      break
  }
  if(sub2[i] == max(inputlist))
    is_success <- TRUE
  return(is_success)
}
  
find_optimal <- function(N){
  recorder <- c()
  for(i in 1:round(N/2)){ #split_number
    count <- 0
    for(j in 1:10000){  #running times
      if(make_choice(N,i))
        count <- count+1  #sum up successful times for each split_number
    }
    recorder <- c(recorder,count)  
  }
  return(which(recorder == max(recorder)))
}

#solution for N = 3
cat(paste0("The optimal split of ", 3," candidates is ", find_optimal(3),".\n"))
cat(paste0("The probability of picking the best one is ",find_optimal(3)/3,".\n"))

col <- 0
for(N in 10:100){ 
  res <- find_optimal(N)
  prob <- res/N
  cat(paste0("The optimal split of ", N, " candidates is ", res, ".\n"))
  cat(paste0("The probability of picking the best one is ", prob, ".\n"))
  col <- col+prob
}

#Then we can calculate the overall mean of probability of picking the best
print(col/91)

