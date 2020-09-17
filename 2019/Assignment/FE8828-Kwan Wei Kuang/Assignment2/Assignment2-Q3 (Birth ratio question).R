#Assignment 2, Q3: Birth ratio question

girls_ratio <- function(num_families){
  num_babies <- 0
  num_girls <- 0
  for(i in 1:num_families){
    girl <- sample(c(TRUE, FALSE), 1, prob = c(0.5,0.5))
    num_babies <- num_babies + 1
    #cat("Family ",paste0(i),": \n")
    #cat(paste0(girl),"\n")
    while(girl == TRUE){
      num_girls <- num_girls + 1
      girl <- sample(c(TRUE, FALSE), 1, prob = c(0.5,0.5))
      num_babies <- num_babies + 1
      #cat(paste0(girl),"\n")
    }
    #cat("Number of babies: ", paste0(num_babies)," , Number of girls", paste0(num_girls), "\n")
  }
  return(num_girls/num_babies)
}

#simulate 10,000 times
list_ratio <- c()
for(i in 1:10000){
  list_ratio[i] <- girls_ratio(10)
}
hist(list_ratio,
     main="Histogram of ratio of girls in 10 families", 
     xlab="Ratio")

mean(list_ratio)
