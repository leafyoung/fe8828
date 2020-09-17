# 12-birthday problem

# Below generator function is not right, it gives result of 25.
# Its algorithm:
# Once it can't satisfy the conditions, it finds more new friends of (sample_n + 1).
# If still fails, it tries to finds more new friends of (sample_n + 2)...

# What's wrong?
# When conditions are satisified, the total number of friends that we have known is:
# sample_n + (sample_n + 1) + (sample_n + 2) + ...
# It's more than (sample_n + X).
# If we average over (sample_n + X), we are short in counting.
# That's why it's less than 37, which is the answer given below.

gen_bday <- function() {
  sample_n <- 0
  
  found <- FALSE
  while(!found) {
    spl <- sample(1:12, sample_n, replace = TRUE)
    if (length(unique(spl)) == 12) {
      found <- TRUE
    } else {
      sample_n <- sample_n + 1
    }
  }
  sample_n
}

sapply(1:1000, function(x) gen_bday()) -> res1
print(mean(res1))

# This is the correct version.
gen_bday2 <- function() {
  sample_n <- 12
  
  spl <- sample(1:12, sample_n, replace = TRUE)
  found <- length(unique(spl)) == 12
  while(!found) {
    # Know one more friend
    # combine existing known people
    spl <- c(spl, sample(1:12, 1))
    sample_n <- sample_n + 1
    # found is a boolean
    found <- length(unique(spl)) == 12
  }
  sample_n
}

sapply(1:10000, function(x) gen_bday2()) -> res2
print(mean(res2))
