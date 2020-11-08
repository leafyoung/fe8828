
make_choice <- function(N, split_number){

  a <- sample(1:N,N,replace = FALSE)
  input_list <- list()
  for(i in 1:N){
    input_list[[i]] <- a[i]
  }
  
  eval_grp <- list()
  sele_grp <- list()
  for (i in 1:split_number){
    eval_grp[[i]] <- input_list[[i]] 
  }  
    Ns <- N - split_number
  for (i in 1:Ns){
    sele_grp[[i]] = input_list[[split_number + i]]  
  } 
    
  emax <- 1
  for (i in 1:length(eval_grp)){
    if (eval_grp[[i]] > emax)
      emax <- eval_grp[[i]]
  }
  
  for (i in 1:length(sele_grp)){
    if (sele_grp[[i]] > emax)
      emax <- sele_grp[[i]]
    break
  }
  
  return (emax)
}

# m is the repeated times to calculate the probability of choosing the best
p_true <- function(m,N,split_number){
  count <- 0
  for (i in 1:m){
    if(make_choice(N,split_number) == N)
      count <- count + 1
  }
  p <- count/m
  return (p)
}

#Get the optimal split number
find_optimal <- function(m,N){
  prob <- c(p_true(m,N,1))
  opt_split <- 1  
  
  for (i in 2:round(N/2)){
    prob[i] <- p_true(m,N,i) # i as the variable for different split numbers
    if (prob[i] > prob[opt_split])
      opt_split <- i
  }
  return (opt_split)
}

find_optimal(1000,3)
find_optimal(1000,10)
find_optimal(1000,100)

## Running result: 2, 5, 10.  
## The result is close to N/2. When I test and run, I think that based on this strategy, if we don't set the split number
## below N/2, actually the optimal numbers should very close to N.(Just a guess:)).


