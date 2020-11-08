# Step 1: create function make_choice <- function(N, split_number)
# 1. Generate a list input_list of N long with integer 1 to N at random position
# 2. Split the list input_list into two: evaluation group and selection group.
# 3. Remember the best number from evaluation group and match the first number in selection group, >= than best. Return it.
make_choice <- function(N, split_number) {
  candidate_scores <- sample(1:N, N)
  evaluation_group <- candidate_scores[1:split_number]
  selection_group  <- candidate_scores[(split_number+1):N]
  evaluation_max   <- max(evaluation_group)
  for(i in (split_number+1):N) {
    if(candidate_scores[i] > evaluation_max) {
      return(candidate_scores[i])
      break
    }
  }
}

# 4. Run this function for a few (hundred) times and find the probability of getting N.
simulation_count <- 10
N <- 100
split_number <- 30

simulation_results <- replicate(simulation_count, make_choice(N, split_number))
sum(unlist(simulation_results) == N)/simulation_count

# Step 2: create function find_optimal(), calls make_choice for each of the split number from 1 to N/2. So we can find the optimal value for the split for the N.

find_optimal <- function(N) {
  prob = c()
  for (i in 1:(N/2)) {
    simulation_count <- 10000
    simulation_results <- replicate(simulation_count, make_choice(N, i))
    prob[i] <- sum(unlist(simulation_results) == N)/simulation_count
  }
  optimum_split <- which(prob == max(prob))
  return(optimum_split)
}


# Step 3: Find the solution for N = 3, then, N = 10, then move on to N = 100. 

# We are simulating 10,000 times in line 31.

find_optimal(3)
find_optimal(10)
find_optimal(100)



