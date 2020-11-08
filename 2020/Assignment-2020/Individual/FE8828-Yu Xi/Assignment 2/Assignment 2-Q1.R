#Assign the size of N (try N = 3, 10, 100)
N <- 100

#Initialize probability vector p
p <- c()
p[1] <- 0

#Loop for the 2nd to the last candidate
#Use "success" to denote the number of cases in which we successfully picked up the best
for (k in 2:N-1) {
  success <- 0
  #Generate a list of N random numbers and use EvaluationGrpBest to denote the highest score in the evaluation group
  for (n in 1:N) {
    x <- sample(1:N, N)
    EvaluationGrpBest <- max(x[1:k])
    #Use the criteria established in the evaluation group to to filter the selection group
    CandidateScore = -1
    for (i in (k+1):N) {
      if (x[i] > EvaluationGrpBest) {
        CandidateScore <- x[i]
        break
      }
    }
    #Check if the candidate with the highest scores has been selected
    if (CandidateScore == N)
      success <- success + 1
  }
  
  #Calculate the successful probability
  p[k] <- success/N
  
  #For progress checking only
  cat(k, " complete \n")
}

#Plot the graph and estimate the most appropriate k based on the highest P
plot(1:N, p, type = "l", xlab = "Split Value",
     ylab = "Successful Probability")



#Based on the plot, the split should be around 37 and the corresponding probability is around 0.38

