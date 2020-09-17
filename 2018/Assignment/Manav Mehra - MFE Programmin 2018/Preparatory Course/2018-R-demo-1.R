# Boolean Algebra

# |, or
TRUE | TRUE == TRUE
TRUE | FALSE == TRUE
FALSE | FALSE == FALSE

# & and
TRUE & TRUE == TRUE
TRUE & FALSE == FALSE
FALSE & FALSE == FALSE

# Test if numeric
is.numeric(1:10) # TRUE
is.numeric(12) # TRUE

# Conversion
as.numeric(12)
## NA, can't understand the character as numeric.
as.numeric("MFE")
is.na(as.numeric("MFE")) # TRUE

# 
is.na(as.numeric("12")) # 12
as.numeric("12") # 12
as.character(12) # "12"
as.numeric(as.character(12)) # 12
## 12.123 is a recognizable number
as.numeric(as.character(12.123))
## !23 is hard to understand
as.numeric(as.character("!23"))

## return today's date
today <- Sys.Date()
## add/substract number of days
today + 1
today - 1
today - 14

# get the time
time <- Sys.time()
# time's class is POSIXct, international standard
class(time)
# "Date"
class(today)
# "numeric"
class(1:20)
# we replicate is.numeric() function
class(1:20) == "numeric" | class(1:20) == "integer"
# == is a comparison operator
1 == 2 # FALSE

# Vector
1:20
# assign to variable "seq1"
seq1 <- 1:20
# TRUE
is.numeric(seq1)
# length of a vector
length(seq1) > 1
length(seq1)

# create a vector of reversed order
20:1

# create a vector from function c(), "combine"
c() # c for combine
someVector <- c(110, 138, 20) # c for combine
someVector
# append
c(someVector, 10)
# prepend
c(10, someVector)

# create a empty vector using vector() function
vector(mode = "numeric", length = 10)
# rep "repeat" 0 for 10 times
rep(0, 10)
# replicate 10 times of 0
replicate(10, 0)
# one-time 10 random numbers in normal distribution
rnorm(10)
# 1-number 10 times
replicate(10, rnorm(1))

# Identical result. rep() doesn't run rnorm 10 times. 
rep(rnorm(1), 10)

# Vectorized operation
1:10 + 1
# re-use the short-length vector to make up for the operation
1:10 + 1:3

# create c(1, 4, 7, 10)
seq(1, 10, by = 3)

# create matrix
matrix(nrow = 2, ncol = 3)

# create a matrix and assign to mat
mat <- matrix(1:6, nrow = 2, ncol = 3)
mat
# getting a value from matrix
mat[1, 2]
# setting a value in a matrix
mat[1, 2] <- 3
mat[1, 3] <- 3
mat

# zero-matrix
matrix(0, 3, 3)
# diagnal matrix
diag(1, 3, 3)
# dimension of a matrix, returns a vector c(2, 3)
dim(mat)
# column-bind
cbind(diag(1, 3, 3), matrix(0, 3, 3))
# row-bind
rbind(diag(1, 3, 3), matrix(0, 3, 3))

# create a matrix of character
matrix("A", 3, 3)
# create a suit of poker
paste0(c("H", "D", "C", "S"), sort(rep(1:13, 4)))
# create a suit of poker - version 2
paste0(c("H", "D", "C", "S"), sort(rep(1,52) * 1:13))

# full suit of poker
c(paste0(c("H", "D", "C", "S"), sort(rep(1:13, 4))), "J", "j")
# check the suit
# unique reduces duplicates.
# length(unique(...)) confirms the number of unique items
length(unique(c(paste0(c("H", "D", "C", "S"), sort(rep(1:13, 4))), "J", "j")))

# sort() sorts a vector
sort(20:1)
sort(rnorm(5))

# assign suit to a variable
suit <- c("H", "D", "C", "S")
suit
# paste0 concatenate multiple variables to characters.
paste0(1, 1, "a")
# paste() with space
paste(1, 1, "a")
# paste0() without space
paste0(1, 1, "a")
# combine a vector into a string
paste0(1:10, collapse = "")

# create a unnamed-list
list(1, 2, "a")
# create a named-list
list(a = 1, b = 2, c = "a")
# assign list to a variable
lstA <- list(a = 1, b = 2, c = "a")
# get the first element from a list
lstA[[1]]
# get the 2nd element from a list
lstA[[2]]
# get the 3rd element from a list
lstA[[3]]
# for a named-list, extract it by its name using [[]]
lstA[["c"]]
lstA[["b"]]
lstA[["a"]]
# using $ to extract the value
lstA$a
lstA$b

# Read the csv file
# Generate this line from menu File->Import Dataset->
TSLA <- read.csv("C:/Users/Professor/Downloads/TSLA.csv")
# "data.frame"
class(TSLA)
# View the data fram inside RStudio
View(TSLA)

# Access column inside a data frame
TSLA[["Date"]]
TSLA[["Open"]]
TSLA[["Low"]]

# 
min(TSLA[["Low"]])
max(TSLA[["Low"]])
mean(TSLA[["Low"]])
sd(TSLA[["Low"]])

# getting the dimensions of the data frame
nrow(TSLA)
ncol(TSLA)
colnames(TSLA)
str(TSLA)

# plot
plot(TSLA$Close)
plot(TSLA$Date, TSLA$Close)

# creat a matrix of 1:4
mat <- matrix("", 1, 4)
mat

# assign elements
mat[1, 1:4] <- suit
mat
# assign elements using reversed order
mat[1, 4:1] <- suit
mat

# assign elements with customized order
mat[1, c(2,3,4,1)] <- suit
mat
# assign elements with customized order
mat[1, c(2,3,3,1)] <- suit
mat

# Extracting element from a vector
seq1
seq1[10]

# getting a few elements from a vector
seq(3, 15, by = 3)
seq1[seq(3, 15, by = 3)]
seq1[ceiling(runif(1) * 20)]

# ceiling()/floor()
ceiling(3.1)
floor(3.1)

# this gives 1 location between 1:20
seq1[ceiling(runif(1) * 20)]
# above line is equivalent to 
sample(1:20, 1, replace = TRUE)

# genrate 10 locations
seq1[ceiling(runif(10) * 20)]

# return the number greater than 10
seq1[ seq1 > 10 ]
# this returns a vector of boolean
seq1 > 10
# [ ] takes this vector of boolean
seq1[ seq1 > 10 ]
# returns numbers on alternative locations.
seq1[ rep(c(TRUE, FALSE), 10)]

# histogram of 1000 random number of normal distribution
hist(rnorm(1000))
a <- rnorm(1000)
# return partial distribution
b <- a[ a > 1]
hist(b)

b <- a[ a > 1 | a < -1]
hist(b)

b <- a[ a > 1 | a < 0.5]
hist(b)

# return the 2nd-half length of a
b <- a[ceiling(length(a)/2):length(a)]
length(b)
# return the exactly 2nd-half length of a
b <- a[(ceiling(length(a)/2)+1):length(a)]
length(b)

# setting the values of a vector at certain location
seq1
seq1[ seq1 > 10] <- 1
seq1

# subsetting from a data frame.
TSLA
# row 1
TSLA[1, ]
# row 1:10
TSLA[1:10, ]
# row 1:10 with column 1
TSLA[1:10, 1]
# row 1:10 with column 1, 3, 7
TSLA[1:10, c(1, 3, 7)]
# row 1:10 with column "Date", "Close"
TSLA[1:10, c("Date", "Close")]
# re-arrange the order
TSLA[1:10, c("Close", "Date")]

# returns the ordering order, in decreasing order
order(1:10, decreasing = TRUE)
order(runif(10), decreasing = TRUE)
sort(runif(10), decreasing = TRUE)
order(runif(10), decreasing = TRUE)

# example for order()
a <- c(1, 4, 3, 2)
order(a)
a[order(a)]
sort
sort(a)
a[order(a, decreasing = TRUE)]
sort(a, decreasing = TRUE)

# [,] returns itself
TSLA[,]
# returns a data frame, sorted by the Close price, high to low
TSLA[order(TSLA$Close, decreasing = TRUE),]

# 
save.image("C:/Users/Professor/Downloads/201800705-class-R.RData")
load("C:/Users/Professor/Downloads/201800705-class-R.RData")
save(TSLA, a, b, file = "C:/Users/Professor/Downloads/TSLA.RData")

# matrix
matrix(1:9, 3, 3)
m <- matrix(1:9, 3, 3)
m
# matrix element-wise operations
m + m
m - m
m * m
m / m
# matrix multiplication
m %*% m

# Extracting a column as a vector from a data frame
tsla_close <- TSLA$Close
# log-return vector
log(tsla_close[-1] / tsla_close[-length(tsla_close)])
# volatility = standard deviation of log-return vector
sd(log(tsla_close[-1] / tsla_close[-length(tsla_close)]))

# remove element from a vector
(1:20)[c(-1, -2)]
(1:20)[c(-5, -15)]

# drops the 1st element
tsla_close[-1]
tsla_close
# drops the last element
tsla_close[-length(tsla_close)]

# annualize the volatility by multiplying sqrt(250)
sd(log(tsla_close[-1] / tsla_close[-length(tsla_close)])) * sqrt(250)
# multiply volatility with current price range
sd(log(tsla_close[-1] / tsla_close[-length(tsla_close)])) * sqrt(250) * 300

# cumsum
c(31, 28, 31, 30)
cumsum(c(31, 28, 31, 30))
