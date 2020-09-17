#Assignment2-1
library(lubridate)
Bizdays <- function(year){
  start <- dmy(paste0("01-01", year))
  end <- dmy(paste0("31-12", year))
  date <- seq(start, end, "days")
  working_days <- sum(wday(date) > 1 & wday(date) < 7)
  print(working_days)
}
Bizdays("2018")
Bizdays("2005")

#####################################################################3
#Assignment2-2
#Step 1
make_choice <- function(N, split_number){
  input_list <- sample(1 : N, N)
  evaluation_group = input_list[1 : split_number]
  selection_group = input_list[(split_number+1):N]
  best_number = max(evaluation_group)
  match_number = selection_group[which(selection_group >= best_number)[1]]
  
  # YY: If we can't find a better number, we end up with the last item.
  if(is.na(match_number)) return(input_list[N])
  else return(match_number)
}

count <- 0
split = round(runif(1, 1, 50))
for(i in 1:10000){
  if(make_choice(100, split) == 100){
    count <- count + 1}
}
count/10000

#Step2
find_optimal <- function(N){
  count <- rep(0, N/2)
  for (i in 1: (N/2)) {
    for (j in 1 : 1000) {
      if (make_choice(N, i)== 100)
        {count[i] <- count[i]+1}
    }
  }
  which.max(count)
}
find_optimal(100)

#############################################################
#Assignment 2-3
library(lattice)
#Thanks my classmate taught me another visualization method.

## 1 = boy; 0 = girl
birth_ratio <- function(N) { #1st round
  gender <- c(sample(0:1, N, replace = T))
  A <- sum(gender == 0)
  girl_total = A
  boy_total = N - A
  while(A != 0){ #next n round until girl = 0
    gender <- c(sample(0:1, A, replace = T))
    B <- sum(gender == 0)
    boy_total = boy_total + A - B
    girl_total = girl_total + B
    A = B
  }
  return(girl_total/boy_total)
}

#count the avg ratio
sum <- 0
K <- rep(0, 1000)
for(i in 1 : 1000){
  K[i] <- birth_ratio(10)
}
sum <- sum(K)
mean <- sum/1000

#find the distribution
densityplot(K, xlab = 'Total_Girls / Total_Boys')

