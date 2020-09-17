data <- 10:1

# Vector
v <- c(1,3)
rep(100,10) #repeat m for n times
  #change value
v[1] <- 3
  #find elements - return location
match(c(1, 3), data)
which(1 == data | 3 == data)
data[match(c(1, 3), data)]
  #Check whether element exists - return T/F
all(c(1, 33) %in% 1:3)
any(c(1, 33) %in% 1:3)

# String
substr("The fox jumps.", 6, 6 + 5 - 1) #截取
paste0(1:3, sep = "a") #连接
toupper("big") #大写
tolower("LOWER") #小写
  # Find
grepl("A", "ABC", fixed = TRUE) #精确匹配
grepl("^Start", "Start with me") #beginning
  # Replace
sub("D", "ABC", "DDD", fixed = TRUE) #first
sub("X$", "Z", "XYZ ends with X") #end
gsub("D", "ABC", "DDD", fixed = TRUE) #all
  # Regular Expression
sub("([^\\_]+)\\_.*", "\\1", "USDCNY_M1")
sub("([^\\_]+)\\_(.*)", "\\1 \\2", "USDCNY_M1")
sub("([^\\_]+)\\_([[:alpha:]])([[:digit:]])", "\\1 \\2 \\3", "USDCNY_M1")

# Date
dt1 <- as.Date("2019-11-03")
dt2 <- Sys.Date()
create.calendar(name="MFE_Mini_2", holidays = c(as.Date("2019-10-28")),
                start.date = as.Date("2019-09-10"), end.date = as.Date("2019-10-31"),
                weekdays = c("saturday", "sunday"))
library(lubridate)
 # Transform
ymd(20190910) # String to Date
ymd("20190910")
format(Sys.Date(), format = "%Y/%m/%d") # Date to String
as.Date("2019-Nov-03", format = "%Y-%b-%d")
  # Change
month(dt1) <- 1
day(dt1) <- days_in_month(x) #end of the month
  # Business days
library(bizdays)
bizdays("2019-10-01", "2019-10-31", "weekends")
add.bizdays("2019-10-01", 5, "weekends")
bizseq("2019-10-01", "2019-10-31", cal = "weekends")
# Time
x <- Sys.time()
  # Transform
format(Sys.time(), format = "%H:%M:%S")
ymd_hms("2011-12-31 12:59:59")
  # Change
hour(x) <- 12
minute(x) <- 3

#create a m*n matrix of value x
mat <- matrix(2,3,4)
  #set first row to 4
mat[1, ] <- 4
  #set element(2,2) to 6
mat[2,2] <- 6

#Random
rnorm(3, mean = 10, sd = 3) #Normal distribution
runif(3) # Uniform distribution
sample(1:10, 10, replace = FALSE) #无放回
sample(1:6, 10, replace = TRUE) #放回

# List
l <- list(3, 4)
a <- list(a = 3, b = 4)
list_of_strikes <- list() # blank
list_of_strikes$`65` <- 3
  # access
a[[1]]
a[["a"]]
a$a
is.null(a$c)

# Print
print('This is')
x <- c(Sys.Date(), Sys.Date(), Sys.Date())
cat(paste("Current dates is ", x, ".\n")) # with space
cat(paste0("Current dates is ", x, ".\n")) # without space
cat(paste0("Current dates is ", paste0(x, collapse = ", "), ".\n")) #collapse - print in one line

# Dataframe
'''
常用函数：
str()/View()/head()/tail()
nrow()/ncol()/dim() # returns both nrow and ncol
colnames()/rownames()
'''
library(tibble)
df <- tibble(
  date = seq(as.Date("2019-01-01"), as.Date("2019-01-10"), by = "day"),
  stock = replicate(10, paste0(sample(LETTERS, 3, replace = TRUE), collapse =
                                 "")),
  quantity = round(runif(10) * 10000 ,0))
  # Access
df["date"] # return a data frame
df[["date"]] # return value
df[c(3, 6, 9), , drop = F] #rows
df[c(3, 6, 9), , drop = F] # return value
df[, 1, drop = FALSE] #columns
df[, c("date", "quantity"), drop = FALSE]

# Function
funcname <- function(in1, in2) {
  if (in1 < 0) {
    return(0) # if we have 0 here, it's not the last step before function exits.
  } else {
    res <- in1 + in2
  }
  res <- res * 3
  res
}
  # Anonymous Function
(function(x) { print(x) }) (3)
  # APPLICATION
library(purrr)
    # These two are equivalent.
res1 <- purrr::map(1:10, function(x) { rnorm(x, n = 1000) })
res <- purrr::map(1:10, rnorm, n = 1000)
map_dbl(res, mean) #statistics
  # sapply a bit slower than purrr::map
sapply(1:10, function(x) x ^ 2 )
sapply(1:10, function(x) `^` (x, 2) )

#Objects
  # Create 1
vanilla_option <- setClass("vanilla_option",
                           slots = c(type = "character",
                                     strike = "numeric",
                                     underlying = "numeric"))
opt1 <- vanilla_option(type = "c", strike = 100, underlying = 100)
  # Create 2
opt2 <- new("vanilla_option", type = "c", strike = 100, underlying = 100)
  # Access
opt1@type
slot(opt1, "strike")

# Read/Write data
setwd("C:/TEMP") # set working directory
saveRDS(this_is_var1, file = "C:/TEMP/DATA/data.Rds")
new_loaded <- readRDS(file = "C:/TEMP/DATA/data.Rds")