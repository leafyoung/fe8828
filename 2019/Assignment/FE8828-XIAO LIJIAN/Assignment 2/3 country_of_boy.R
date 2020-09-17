boy_country <- function(){
#creat a list of 10 families
family <- list(length = 10)

#generate 10 babies use sample function, use 1 to denote boy, 0 to girl
for (i in 1:10) {
  family[[i]] <- c(sample(0:1, 1))
}

#continue creating babies untill every family get a boy
##too cruel, for one test I found a family got their boy at the 11th birth
while((sum(family[[1]]) + sum(family[[2]]) + sum(family[[3]]) + sum(family[[4]])
      + sum(family[[5]]) + sum(family[[6]]) + sum(family[[7]])
      + sum(family[[8]]) + sum(family[[9]]) + sum(family[[10]])) != 10){
for(i in 1:10){
  if(sum(family[[i]]) == 0){
    family[[i]] <- c(family[[i]], sample(0:1, 1))
  }
}
}

#use count_boy and count_girl to count the number of babies
count_boy <- 10
count_girl <- 0
for (i in 1:10) {
  count_girl <- count_girl + length(family[[i]]) - 1
}
all_baby <- count_boy + count_girl

#use plot to show the distribution10
return(count_girl/all_baby)
}

ratio <- c()
for(i in 1:1000){
  ratio <- c(ratio, boy_country())
}
#simulation for 100 times, ratio is of all girls. In theory, it should be 0.5
hist(ratio)
mean(ratio)
