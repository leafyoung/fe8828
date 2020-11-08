#Secretary Problem
make_choice <- function(N, split_number){
    
    # built the 'repeat' inside this function to produce the probability as the function's output
    times <- 10000
    GetN <- 0
    for(i in 1:times){
        # generate the sample of integers 1 to N
        input_list <- sample(1:N,N,replace = FALSE)
        # split into 2 groups
        evalgrp <- input_list[1:split_number]
        selectgrp <- input_list[(split_number+1) : N] # by construction, we assume split_number < N
        best_eval <- max(evalgrp) #find the best in evaluation group
        if(best_eval == N){
            # the best is in evaluation group - chosen as 'Criteria' 
            # so will interview all members in selection group until the last since nobody is better than the criteria
            choice <- selectgrp[length(selectgrp)]
        }else{
            choice <- selectgrp[min(which(selectgrp >= best_eval))]     
        }
        if(choice == N){GetN <- GetN + 1}
    }
    GetN/times
}


find_optimal <- function(N){
    ProbGetN = c()
    for(j in 1:(N/2)){
        ProbGetN[j] <- make_choice(N, j)
    }
    ls <- list("split"= match(max(ProbGetN),ProbGetN),"p" = max(ProbGetN))
}

# find the best split and its probability when N=3

lsResult = find_optimal(3)
cat("The best split and its probability when N=3: ", paste0(lsResult,collapse = ", "),".\n")

# find the best split and its probability when N=10
lsResult = find_optimal(10)
cat("The best split and its probability when N=10: ",paste0(lsResult,collapse = ", "),".\n")

# find the best split and its probability when N=100
lsResult = find_optimal(100)
cat("The best split and its probability when N=3: ",paste0(lsResult,collapse = ", "),".\n")

