set.seed(123)
make_choice <- function(N, spilt_number){  # return 1 if the best candidate is found, 0 otherwise
    input_list <- sample(1:N, N, replace = FALSE)
    test_list <- input_list[1:spilt_number]
    select_list <- input_list[(spilt_number+1):N]
    max_test <- max(test_list)
    for(i in 1:length(select_list)){
        if (select_list[i] > max_test){
            result <- select_list[i]
            break
        } else{
            result <- 0
        }
    }
    # YY: if we can't find a better one, we need to return the last element.
    if (result == 0) {
        result <- input_list[N]
    }
    if (result == N){
        return(1)
    }else{
        return(0)
    }
    
}
find_optimal <- function(N){
    if (N %% 2 != 0){
        N <- N + 1
    }
    choice <- numeric(N/2)
    for (i in 1:1000){
        for (j in 1:N/2){
            choice[j] <- make_choice(N, j) + choice[j]   
        } # for each split number, run the function 1000 times and accumulate the counts of successful chioce
    }
    which.max(choice)
}
find_optimal(100)
