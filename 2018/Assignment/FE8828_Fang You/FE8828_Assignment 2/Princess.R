##pg 44 of 102 equivalent to princess marriage problem (ans ~37)

#function for counting the min number in selection group that is >= evluation group
make_choice <- function(N, split_number)
{
  input_list <- sample(1:N,N,replace =FALSE) #replace = FALSE because every prince is unique
  # cat(paste0(input_list, collapse = ", "), "\n")
  
  #create evaluation vector and populate
  # Yang: replace code below
  if (FALSE) {
    evaluation <- vector(mode = "integer", split_number)
    for (i in 1:split_number)
    {
      evaluation[i] <- input_list[i]
    }
  } else{
    evaluation <- input_list[1:split_number]
  }
  
  #find max of evaluation group
  max_eval <- max(evaluation)
  
  # Yang: replace code below
  if (FALSE) {
    #create selection vector and populate
    selection <- vector(mode = "integer",N-split_number)
    j <- 1
    for (i in (split_number+1):N)
    {
      selection[j] <- input_list[i]
      j <- j+1
    }
  } else {
    selection <- input_list[(split_number+1):N]
  }
  
  #find index of first element >= max_eval
  # Yang: >= can be just =. But I see for the zero-split-number case, it requires >=
  index <- min(which(selection >= max_eval))
  
  if (index > (N-split_number))
  {
    return(selection[N-split_number]) #if no better prince can be found from the selection group, princess settles for the last guy she meets
  } else
  {
    return(selection[index]) 
  }
}

N <- 3 #no. of princes the princess will meet in her lifetime
M <- 1000 #no. of model trials at each split_number
score0 <- vector(mode = "integer",M) #create vector to store the score of the prince that was chosen at each model trial
score1 <- vector(mode = "integer",M) #create vector to store the score of the prince that was chosen at each model trial
score2 <- vector(mode = "integer",M)

#find probability of marrying the prince with the highest score, N
split_number <- 0 #vary this to try split number = 0,1 or 2
for (i in 1:M)
{
  score0[i] <- make_choice(N,0)
  score1[i] <- make_choice(N,1)
  score2[i] <- make_choice(N,2)
}

# Yang: rewrite with three statements.
prob_get_N <- sum(score0 == N)/M 
cat(paste0("prob_get_N for 0: ", prob_get_N, "\n"))

prob_get_N <- sum(score1 == N)/M 
cat(paste0("prob_get_N for 1: ", prob_get_N, "\n"))

prob_get_N <- sum(score2 == N)/M 
cat(paste0("prob_get_N for 2: ", prob_get_N, "\n"))

#ans
#probability of marrying prince with score N is approx. 0.5 when N=3, split_number = 1
#probability of marrying prince with score N is approx. 0.33 when N=3, split_number = 2

#finding optimal split_number to marry the prince with the highest score, N
N <- 100 #no. of princes the princess will meet in her lifetime
M <- 1000 #no. of model trials at each split_number
K <- 100

score <- vector(mode = "numeric", length = M)
prob_get_N <- vector(mode = "numeric", length = ceiling(N/2))
optimal_split <- vector(mode = "numeric", length = K)

for (k in 1:K)
{
  for (j in 1:ceiling(N/2)) #j is the trial split_number
  {
    split_number <- j
    
    for (i in 1:M) #for each split_number, execute M times model trial
    {
      score[i] <- make_choice(N,split_number)
    }
    
    #probability of marrying prince with highest score
    prob_get_N[j] <- sum(score == N)/M 
  }
  
  optimal_split[k] <- which(prob_get_N == max(prob_get_N)) # creates vector recording the optimal split numbers
}

avg_optimal_split <- mean(optimal_split)
cat(paste0("avg_optimal_split: ", avg_optimal_split, "\n"))

#average optimal split number is 36.43 with N=100