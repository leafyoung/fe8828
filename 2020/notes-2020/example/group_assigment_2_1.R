# Answer
library(tidyverse)
library(fOptions) # Note there are conflicts in name for functions like "filter()"

S <- 100
K <- 100
sigma <- 0.3 # realized vol can be 0.3 for [1] or 0.5 for [2]
drift <- 0 # drift = r - q
timestep <- 1 / 250
days <- 20 / 250
N <- days / timestep

p1 <- (drift - 0.5 * sigma * sigma) * timestep
p2 <- sigma * sqrt(timestep)

single_result <- replicate(500, {
  # ss is the simulated price movement for N days
  ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
  
  df <- tibble(S = ss, days = (N-1):0)
  opt <- rowwise(df) %>% mutate(
    # Below is end-of-day calculations
    price = GBSOption("c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3)@price,
    delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3),
    gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3),
    theta = GBSGreeks("Theta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3) / 250) %>%
    ungroup() %>%
    mutate(delta_S = S - dplyr::lag(S))

  sd((log(opt$S / lag(opt$S))[-1])) / sqrt(1 / 250)
  
  # print(sum(opt$theta, na.rm = TRUE))
  # print(sum(0.5 * opt$gamma * (dplyr::lead(opt$delta_S) ** 2), na.rm = TRUE))
  c(sum(opt$theta, na.rm = TRUE),
    sum(0.5 * opt$gamma * (dplyr::lead(opt$delta_S) ** 2), na.rm = TRUE))
}) 

hist(single_result[1, ])
hist(single_result[2, ])
colSums(single_result)