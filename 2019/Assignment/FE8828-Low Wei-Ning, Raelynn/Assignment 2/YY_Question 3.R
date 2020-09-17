Gprop <- function() {
  Gcount <- 0
  for (run in 1:10) {
    gender <- sample(c("B","G"),1)
    # YY: old code only allows family to give birth to one baby.
    while (gender == "G") {
      Gcount <- Gcount + 1
      gender <- sample(c("B","G"),1)
    }
  }
  #cat(paste0(Gcount/10))
  return(Gcount/(10 + Gcount))
}

Gproplist <- list()
for (simulation in 1:10000) {
  Gproplist <- c(Gproplist,Gprop())
}
hist(as.numeric(Gproplist),
     main="Histogram for Proportion of Girls in 10,000 simulations", 
     xlab="Proportion of Girls", 
     border="blue", 
     col="lightblue")

