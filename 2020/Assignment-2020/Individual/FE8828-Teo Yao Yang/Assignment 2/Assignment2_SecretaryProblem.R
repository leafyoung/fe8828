library(tidyverse)

make_choice <- function(N, split_number){
  samp <- sample.int(N, N)
  eval <- samp[1:split_number]
  split= split_number+1
  select <- samp[split:length(samp)]
  best <- max(eval)
  return(select[which.max(select> best)])
}

find_optimal <- function (N){
  x <- c(1:200) # repeat 200 times
  y <- c(1:N/2)
  maxprob <- 0
  optimal <-0
  
  for (j in y){
    count <- 0
    for (i in x){
      if(make_choice(N,j)==N)
        count = count +1
    }
    
    prob <- count/200
    if(prob > maxprob)
    {
      maxprob <- prob
      optimal <- j
    }
      
  }
  return(optimal)
}

make_choice(10, 4)

solution <- vector()
z <- c(3:100)
for (i in z){
  solution[i] <- find_optimal(i)
}

solution <- solution %>% na.omit()
length(solution)

answer <- data.frame("N"=c(3:100),"solution"=solution)
answer <- answer %>% mutate(percent=solution/N)
answer
mean(answer$percent)

