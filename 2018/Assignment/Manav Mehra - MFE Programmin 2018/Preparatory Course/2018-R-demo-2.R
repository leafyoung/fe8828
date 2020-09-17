# for loop

## 1st kind of for loop
vec <- 1:10
sum <- 0
for (i in 1:10) {
  sum <- sum + i
  i <- i + 1 # this doesn't affect the i in for
}

## 2nd kind of for loop
vec <- runif(10)
sum <- 0
for (i in seq_along(vec)) {
  print(vec[i])
}

## 3rd kind of for loop
for (i in vec) {
  i <- i + 1
}

###############################################################################

# mat multiplication
m <- 2
n <- 3
p <- 3
m1 <- matrix(runif(m * n), m, n)
m2 <- matrix(runif(n * p), n, p)

m3 <- matrix(0, m, p)

for (i in 1:m) {
  for (j in 1:p) {
    m3[i, j] <- sum(m1[i, ] * m2[, j])
  }
}

## matrix result test
print(all(abs(as.vector(m1 %*% m2 - m3)) < 1e-8))

###############################################################################

# magic square
found <- FALSE

while(!found) {
  mat <- matrix(sample(1:9, 9, replace = FALSE), 3, 3)
  
  found <- TRUE
  for (i in 2:3) {
    if (sum(mat[i, ]) != sum(mat[i-1,   ]) |
        sum(mat[ ,i]) != sum(mat[   ,i-1])) {
      found <- FALSE
      break
    }
  }
}
print(mat)

###############################################################################

# compare two matrices
m1 <- matrix(1:4, 2, 2)
m2 <- matrix(c(5:8), 2, 2)

equal <- TRUE
for (i in 1:2) {
  for (j in 1:2) {
    if (m1[i, j] != m2[i, j]) {
      equal <- FALSE
      break
    }
  }
  if (!equal) break
}
print(equal)

###############################################################################

# Parametrization: input argument for the function
# Setting default value: if any

generate_magic <- function(n) {
  found <- FALSE
  
  while(!found) {
    mat <- matrix(sample_function(n), n, n)
    
    found <- TRUE
    for (i in 2:n) {
      if (sum(mat[i, ]) != sum(mat[i-1,   ]) |
          sum(mat[ ,i]) != sum(mat[   ,i-1])) {
        found <- FALSE
        break
      }
    }
  }
  mat
}

generate_magic(3)
generate_magic(n = 3)

sample_function <- function(n) {
  sample(1:(n*n), n*n, replace = FALSE)  
}

generate_magic2 <- function(n = 3, sample_function) {
  found <- FALSE
  
  while(!found) {
    mat <- matrix(sample_function(n), n, n)
    
    found <- TRUE
    for (i in 2:n) {
      if (sum(mat[i, ]) != sum(mat[i-1,   ]) |
          sum(mat[ ,i]) != sum(mat[   ,i-1])) {
        found <- FALSE
        break
      }
    }
  }
  
  mat
}

generate_magic2(n = 3, sample_function = sample_function)

###############################################################################

# pass function to another function
payoff_call <- function(price, strike) { max(price - strike, 0) }

payoff_put <- function(price, strike) { max(strike - price, 0) }

# method 1: call different payoff 
payoff <- function(price, strike) {
  if (optiontype == "C") {
    payoff_call(price, strike)
  } else if (optiontype == "P") {
    payoff_put(price, strike)
  }
}

# pass function to another function
unknown_payoff <- function(payoff = payoff_call, strike, price) {
  payoff(price, strike)
}

unknown_payoff(payoff_call, strike, price)
unknown_payoff(payoff_put, strike, price)

###############################################################################

throws <- function(m, n, p) {
  # 1. Guards
  if (class(m) != "numeric" | class(n) != "numeric" | class(p) != "numeric") {
    return(NA)
  }
  
  if (m * n > p | 6 * m * n < p | m <= 0 | n <= 0 | p <= 0 ) {
    # 2. What kind of return to represent invalid result.  
    return(NA)
  }
  
  # core of the function
  i <- 0
  repeat {
    throws <- sample(1:6, m * n, replace = TRUE)
    i <- i + 1
    if (i %% 10000 == 0) { print(i) }
    if (sum(throws) == p) {
      break
    }
  }
  print(i)
}

# this can be done within short period of time, about 1s.
# Average 1 per 46656 times = 1 / (1 / 6) ^ 6
throws(3, 2, 6)

# this will take long period of time.
# Average 1 per 10077696 times = 1 / (1 / 6) ^ 9
# throws(3, 3, 6)

###############################################################################

# when you move logic into a function
# watch carefully for all your input, exclude middle results

# b,c,e are independent, so they become inputs
# d depends on c and b
afun <- function(b, c, e) {
  b <- (b + 1) / 3 + b + b ^ b
  c <- c + b
  d <- c * b
  e <- e + b
  e
}

# function to return multiple results
bfun <- function() {
  list("tonight", 1, 3.14, c(1,3,4))
}

res <- bfun()
res[[1]]
res[[2]]
res[[3]]
res[[4]]

###############################################################################

