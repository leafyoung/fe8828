
make_choice<-function(N,split_number){
      
  #Generate input list. Define number of secretaries here
  input_list <- sample(1:N, N)
  #Define the best in the first chosen split_number as benchmark
  init_best <- max(input_list[1:split_number])
  candidate_score = -1
  
  #loop the remaining secretary outside of benchmark
  for (i in (split_number+1):(N-1)) {
    if (input_list[i] > init_best) {
      candidate_score <- input_list[i]
      break
    }
  }
  # YY: Need to add below code to deal the case that 100 is in the first group.
  if (candidate_score == -1) {
    candidate_score <- input_list[N]
  }
  
  #success criteria
  if (candidate_score == N)
      return(TRUE)
  else
      return(FALSE)
}

find_optimal<-function(){
  
  N<-100
  #define variable to store probability of success
  p <- c()
  p[1] <- 0
  
  #define number of simulation for each split_number.
  sims <- 10000
  for (k in 2:(N/2)) {
    success <- 0
    for (n in 1:sims) {
      if (make_choice(N,k)==TRUE)
        success=success+1
    }
    
  p[k]=success/sims
  cat(paste(k,"completed\n"))
    
  }

  plot(1:(N/2), p, type = "l", xlab = "Candidates Skipped",
       ylab = "Probability of selecting Best Candidate",
       main = "The Secretary Problem")
  
  cat(which(p==max(p))/N)
  
}

find_optimal()
#optimal results at around 0.36-0.37

