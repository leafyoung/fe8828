#Step 1
make_choice <- function (N, split_number) {
  count <- 0
  n_trials <- 1000
  for (nn in 1:n_trials) {
    input_list <- sample(1:N)
    evagrp <- input_list [1:split_number]
    ## YY: (split_number+1):N, not split_number+1:N
    selgrp <- input_list [(split_number+1):N]
    ## YY: this condition is not right. E.g. we have 3 elements: 1, 2, 3.
    # selgrp: 1
    # evagrp: 3, 2
    # pass = 2. but we can find the best secretary.
    pass <- which(selgrp>=max(evagrp))
    if (length(pass) == 1) {
      count <- count + 1
      # YY: shall use next
      next
      # break
    }
  }
  return (count/n_trials)
}

# YY: the loop is already in the make_choice() function.
# aa <- mean(replicate(1000, make_choice(100, 50)))
# aa
make_choice(100, 50)

# Running the function for 10K times, aa = 25.2103 . When we split the evaluation and selection groups evenly by two, 
# there is ~25.21% chance to get N (where N = 100 = best secretary)

#Step 2

f <- function (N) {
  number <- list()
  n_trials <- 1000
  for (mm in 1:N) {
    count <- 0
    for (nn in 1:n_trials) {
      a <- sample(1:N)
      b <- a [1:mm] 
      c <- a [(mm+1):N]
      pass <- which(c>=max(b))
      ##: YY also not correct.
      if (length(pass) == 1) {
        count <- count + 1
      }
    }
    number[mm] <- count / n_trials
  }
  number
}

ddd <- f(100)
plot(unlist(ddd))

ddd <- replicate(1000, f(100))
# repeat the function 1000 times when the splitting is based on 1 to N/2
# we now have a matrix of 50 rows (test scenarios) and 1000 columns (1000 trials per scenario)
m <- matrix(unlist(ddd), nrow(ddd), dimnames = dimnames(ddd))
plot(rowMeans(m))
# get mean result for each row to see which row (test scenario) is the best
# last few scenarios yield: [43]24.684 [44]24.999 [45]25.012 [46]25.121 [47]25.199 [48]25.110 [49]25.296 [50]25.116
# setting evaluation group as 49 seems the optimal value for splitting N=100 secretaries

