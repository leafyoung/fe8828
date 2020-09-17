# Author: Bai Haoyu
# Matric Number: G1900411H
# Date: 25-Sept-2019

# Question 1: count number of business days

library(lubridate)
library(bizdays)

Count_BizDays <- function(yr){
  start <- paste0(yr,"-01","-01")
  start <- as.Date(start, format = "%Y-%m-%d")
  end <- paste0(yr,"-12","-31")
  end <- as.Date(end, format = "%Y-%m-%d")
  alldays <- seq(start, end, "days")
  alldays <- weekdays(alldays)
  workingdays <- alldays[alldays != "Saturday"]
  workingdays <- workingdays[workingdays != "Sunday"]
  length(workingdays)
}
Count_BizDays(2000)
Count_BizDays(2005)
Count_BizDays(2019)

# use bizdays for checking, this is not part of my answer
length(bizseq("2019-01-01","2019-12-31", cal = "weekends"))

# Question 2: Secretary Problem

# Step 1
make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  # number of elements in evaluation group = split_number
  evaluation_group <- input_list[0:split_number]
  selection_group <- setdiff(input_list,evaluation_group)
  
  # we can use the max() function on evaluation group but not the selection group
  max_eval = max(evaluation_group)
  # find the first element in selection group that is larger than max_eval
  # if the overall max is in the evaluation group (rejected), we always select the last one in the selection group
  if (max_eval == N) {
    our_choice <- selection_group[length(selection_group)]
  } else {
    our_choice <- selection_group[min(which(selection_group > max_eval))]
  }
  
  # cat(input_list,"\n",evaluation_group,"\n",selection_group,"\n",our_choice)
  return(our_choice)
}

# run the function for 10000 times and find the probability of getting 10 if split_number = 3
result <- replicate(10000, make_choice(10,3))
result
count <- sum(result==10)
count
prob <- (sum(result==10))/10000
prob

# Step 2
# N is the total number of secretaries, we test N = 3, N = 10 and N = 100
find_optimal <- function(N){
  #initialize a list to store probabilities of each split_number
  probs <- list()
  # loop from 1 to floor(N/2), the index of highest probability is the optimal split_number
  for (splits in 1:floor(N/2)){
    # replicate 1000 times and check the probability of getting N
    result <- replicate(1000, make_choice(N,splits))
    # result <- list()
    # for (i in 1:1000){
    #   result <- c(result, make_choice(N,splits))
    # }
    prob <- (sum(result==N))/1000
    probs <- c(probs, prob)
  }
  
  # find the location of the largest prob, which is the optimal split
  optimal <- which(probs==max(unlist(probs)))
  optimal
}

# find the solutions
find_optimal(3)
find_optimal(10)
find_optimal(100)

# sum(unlist(replicate(100, find_optimal(100))))/100

# Question 3: Birth Ratio
b <- 10 # for 10 families, eventually the total number of boys will be 10

# function to simulate the process of 1 fimaly
give_birth <- function(){
  m <- 0 # initial number of girls is 0 in each fimaly
  # assume a boy is born if runif() > 0.5
  while (runif(1) < 0.5)
  {
    m <- m + 1
  }
  m
}

# single simulation for 10 fimalies, calculate the ratio of boys
ratio <- b/(sum(replicate(10, give_birth()))+b)
cat(ratio)

# simulate above calculation 10000 time to get the distribution (histogram)
ratios <- replicate(10000, b/(sum(replicate(10, give_birth()))+b))
hist(ratios)
# from the result, we can see the distribution of the ratio is a right-skewed distriubtion (more dense on left)
# the highest count ratio is 0.5, 
# which means such a policy does not affect the 50-50 ratio as the number of families increase
# also can be proved by mathematics
