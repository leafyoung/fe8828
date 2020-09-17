#Question 1
library(lubridate)
count_bizday <- function(year) { 
  
  day1 <- 1
  day2 <- 1
  c <- (year-1) %/% 100
  y <- (year-1) %% 100
  w1 <- (1 + y + y%/%4 + c%/%4 +5*c+ 36) %% 7
  w2 <- (w1+1) %% 7
  if(w1 %in% c(1,0)){day1 <- 0}
  if(w2 %in% c(1,0)){day2 <- 0}
  
  if ((year%%4 != 0) | (year%%400 != 0 & year%%100 == 0)){
    day2 <- 0
  }
  
  return(52*5+day1+day2)
}

count_bizday(2005)
count_bizday(2019)

#Question 2: secretary question
library(purrr)
make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  best_selection <- 1
  
  best_evaluation <- input_list[1]
  for (i in 2:split_number) {
    if(best_evaluation < input_list[i]){best_evaluation <- input_list[i]}
  }
  
  found_best <- FALSE
  for (i in (split_number+1):N) {
    if(input_list[i] > best_evaluation){
      best_selection <- input_list[i]
      found_best <- TRUE
      break
    }
  }
  
  # YY: if N appears in the first group, return the last item
  if (!found_best) {
    best_selection <- input_list[N]
  }
  
  best_selection
}

find_optimal <- function(N){
  split_number <- 1:(N%/%2)
  
  prob <- purrr::map(1:(N%/%2), function(x){
    count <- 0
    for (i in 1:400) {
      if(make_choice(N,x)==N){count <- count+1}
    }
    count/400
  })
  prob <- as.vector(unlist(prob))
  split_number[match(max(prob),prob)]
}

find_optimal(3)
find_optimal(10)
find_optimal(100)

#Question 3: Birth ratio question
library(tidyverse)
ratio <- rep(0,1000)

for (i in 1:1000) {
  girl <- 0
  trial <- purrr::map(1:10,function(x){
    sample(c(0,1), 100, replace = TRUE) # 0 represents Female, 1 represents Male
  })
  for (j in 1:10) {
    girl = girl + which(trial[[j]]==1)[1]-1
  }
  ratio[i] <- (girl/(girl+10))
}

hist(ratio)
plot(density(ratio))
