make_choice <- function(N,split_number)
{
  input_list <- sample(1:N,N) #generate a input list
  input_list_e <- input_list[1:split_number]
  input_list_s <- input_list[(split_number+1):N] #split the list
  benchmark <- max(input_list_e)  #the benchmark is the maximum number in the evaluation group
  result <- 0 #inital the result
  for(i in (split_number+1):(N-1)) #selecting from the first member in the selection group
  {
    if(input_list[i] > benchmark)
    {
      result <- input_list[i]
      break
    }
  }
  return(result)
}


# Run this fucntion a few times
# N = 100
# successful_choice =0
# p <- c()
# for(j in 1:100)
# {
#   result <- make_choice(N,110)
#   if(result == N)
#   {
#     successful_choice = successful_choice+1
#   }
# }
# p <- successful_choice/N
# p

#Step 2: 
N <- 100
p <- c()
M <- 10000
average <- c()
for(split_time in 1:(N-1))  #for each split time from 1 to N/2
{
  successful_choice <- 0
  candidate <- c()
  for(j in 1:M) # Simulate 100 times
  {
    candidate[j] <- make_choice(N,split_time)
    if(candidate[j] == N)
    {
      successful_choice <- successful_choice+1
    }
  }
  p[split_time] <- successful_choice/M
  average[split_time] <- mean(candidate)
}

optimal_choice <- which.max(p)
cat(optimal_choice)

plot(1:(N-1), p, type = "l", xlab = "Number Skipped",
     ylab = "Probability of selecting Best One",
     main = "The Princess Problem")

write.table(average)

plot(1:(N-1),average, xlab = "Number Skipped",
     ylab = "Average Result of Each Monte Carlo",
     main = "The Princess Problem")

