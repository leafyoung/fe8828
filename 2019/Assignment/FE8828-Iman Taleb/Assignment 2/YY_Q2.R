make_choice <-function(N,split_number) {
  # YY: no need to convert to list
  # input_list <- list((sample(1:N,N,replace=FALSE)))
  input_list <- sample(1:N,N,replace=FALSE)
  
  # YY: stop at the split number 
  # evaluation <- input_list[1:(N/split_number)]
  # selection <- input_list[((N/split_number) + 1):N]
  evaluation <- input_list[1:(split_number)]
  selection <- input_list[((split_number) + 1):N]
  # best <- max(unlist(evaluation))
  best <- max(evaluation)
  
  i <- 1
  while (i<length(selection))
  {
    # YY: selection is a vector, use [], not [[]]
    if (selection[i]>=best)
    {
      # YY: selection is a vector, use [], not [[]]
      return(selection[i])
      # YY: We return to out of function after we find the better one than max.
    }
    i <- i + 1
  }
  # YY: If N is in the evaluation group, we won't find a better one in selection group.
  # We will choose the last item.
  return(input_list[N])
}

make_choice(100, 30)
make_choice(100, 30)

find_optimal <- function(N)
{
  # YY: c is a function. use another name cc
  # c <-1
  cc <- 1

  # YY: P1 is to store the probabilites
  P1 <- c()
  while(cc <= (N/2))
  {
    # YY: initialize sum for every cc
    sum <- 0
    # YY: use vector
    # L1<-list()
    L1 <- c()
    p <- 1
    while(p <= 1000) #run function 100 times to find probability of getting N
    {
      # YY: to add a new element to vector, use c()
      # L1$new_elem <- make_choice(N,c)
      L1 <- c(L1, make_choice(N, cc))
      p <- p + 1
    }
    # YY: Use [] for vector
    prob <- sum(L1 == N)/1000
    P1 <- c(P1, prob)
    cc <- cc + 1
  }
  
  # YY: return the index of the element of the max probability
  return(which(P1 == max(P1)))
}

cat(paste0("Optimal split is: ", find_optimal(100), "\n"))




