# Gamma for larger realized vol
S <- 100
K <- 110
sigma <- 0.4 # realized vol can be 0.1 for [1] or 0.5 for [2]
implied_sigma <- 0.5
drift <- 0 # drift = r - q
timestep <- 1 / 250
days <- 20 / 250
N <- days / timestep

p1 <- (drift - 0.5 * sigma * sigma) * timestep
p2 <- sigma * sqrt(timestep)

# ss is the simulated price movement for N days
ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
ss

df <- tibble(S = ss, days = (N-1):0)
opt <- rowwise(df) %>% mutate(
  # Below is end-of-day calculations
  price = GBSOption("c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma)@price,
  delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma),
  gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma),
  theta = GBSGreeks("Theta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma) / 250
  ) %>%
  ungroup() %>%
  mutate(delta_S = S - dplyr::lag(S))

sd((log(opt$S / lag(opt$S))[-1])) / sqrt(1 / 250)

sum(opt$delta * lead(opt$delta_S), na.rm = TRUE) - opt$price[1] + opt$price[20]
sum(0.5 * opt$gamma * (sigma ** 2 - implied_sigma ** 2) * timestep * timestep * opt$price * opt$price, na.rm = TRUE)

large_vol_result <- replicate(500, {
  ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
  
  df <- tibble(S = ss, days = (N-1):0)
  opt <- rowwise(df) %>% mutate(
    # Below is end-of-day calculations
    price = GBSOption("c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma)@price,
    delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma),
    gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma),
    theta = GBSGreeks("Theta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = implied_sigma) / 250
    ) %>%
    ungroup() %>%
    mutate(delta_S = S - dplyr::lag(S))
  
  sd((log(opt$S / lag(opt$S))[-1])) / sqrt(1 / 250)
  
  pnl1 <- sum(-1 * round(opt$delta, 2) * lead(opt$delta_S), na.rm = TRUE) - opt$price[1] + opt$price[20]
  pnl2 <- sum(0.5 * opt$gamma * (sigma ** 2 - implied_sigma ** 2) * timestep * lead(opt$S) * lead(opt$S), na.rm = TRUE)
  c(pnl1, pnl2, pnl1 - pnl2)
})

hist(large_vol_result[3, ] * 100)
mean(large_vol_result[3, ] * 100)

hist(large_vol_result[1, ])
mean(large_vol_result[1, ])

hist(large_vol_result[2, ])
mean(large_vol_result[2, ])

