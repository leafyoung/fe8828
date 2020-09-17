boys <- list()
girls <- list()
ratioboygirl <- list()

for (ii in 1:10000) {
  boys[[ii]] <- 0
  girls[[ii]] <- 0
  N <- 10
  while (N>=1) {
    boyorgirl <- sample(c("boy", "girl"), N, replace = TRUE)
    boys[[ii]] <- boys[[ii]] + length(which(boyorgirl=="boy"))
    girls[[ii]] <- girls[[ii]] + length(which(boyorgirl=="girl"))
    N <- length(which(boyorgirl=="girl"))
  }
  ratioboygirl[[ii]] <- boys [[ii]] / (boys [[ii]] + girls [[ii]])
}

ratioboygirl_out<- unlist(ratioboygirl)
ratioboygirl_out
hist(ratioboygirl_out)
mean(ratioboygirl_out)

# When family size is set as 10, and this test is run for 10000 times, 
# the mean ratio of boys to (boys+girls) is 0.526. this means there will be
# slightly more boys than girls. when family size, N, is set to a much higher number,
# like 1000, the mean ratio of boys to (boys+girls) is 0.500, which is evenly split
