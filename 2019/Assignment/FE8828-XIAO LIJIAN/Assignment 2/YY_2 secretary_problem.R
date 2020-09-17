##Step_1
select_secretary <- function(N, split_number){
  #create a list of N people
  input_list <- sample(1:N, N, replace = FALSE)
  
  #split into two groups
  evaluation_group <- input_list[1:split_number]
  selection_group <- input_list[(split_number+1):N]
  
  #find the best one in evaluation group
  mx <- max(evaluation_group)
  
  #find the first good one in the selection group and return this candidate
  for (i in selection_group) {
    if (i > mx)
      return(final_result <- i)
  }
  # YY: This should be moved here
  return(final_result <- input_list[N])
}

#calculate the prob of getting the best of candidates
step_1 <- function(test1){
count <- 0
for(k in 1:500){
  #reminder for myself: output must be outputted!
  fr <- select_secretary(100, test1)
  if(fr == 100)
    count <- count + 1
}
print(a <- count/500)  #if set split_number as 30, prob is around 0.02
return(a)
}

step_1(37)

##Step_2
find_optimal <- function(){
  all_test <- c()
  #set split_number from 1 to 50
  for (i in 1:50) {
    each_test <- c()
    # for each split_number, run 200 times to get the mean of all the 200 simulations
    # YY: there is 500 in the test. No need to run another 200
    # run 10
    for (j in 1:10)
      each_test <- c(step_1(i), each_test)
    m <- mean(each_test)
    # YY: Reverse the order, not (m, all_test)
    all_test <- c(all_test, m)
  }
  print(all_test)
  x <- 1:50
  plot(x, all_test)
  return(all_test)
}

# from the result, when split_number is 18, the prob is highest, i.e. 0.02066
find_optimal()
