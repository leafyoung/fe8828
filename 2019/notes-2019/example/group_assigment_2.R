S <- 95
K <- 100
sigma <- 0.5 # realized vol can be 0.3 for [1] or 0.5 for [2]
drift <- 0 # drift = r - q
timestep <- 1 / 250
days <- 20 / 250
N <- days / timestep

p1 <- (drift - 0.5 * sigma * sigma) * timestep
p2 <- sigma * sqrt(timestep)

# ss is the simulated price movement for N days
ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))

df <- tibble(S = ss, days = (N-1):0)
opt <- mutate(df,
              delta_S = S - lag(S),
              # Below is end-of-day calculations
              price = GBSOption("c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3)@price,
              delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3),
              gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3),
              theta = GBSGreeks("Theta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3) / 250)

sd((log(opt$S / lag(opt$S))[-1])) / sqrt(1 / 250)

pnl1 <- sum(-1 * round(opt$delta, 2) * lead(opt$delta_S), na.rm = TRUE) - opt$price[1] + opt$price[20]
pnl2 <- sum(0.5 * opt$gamma * (0.5 ** 2 - 0.3 ** 2) * timestep * lead(opt$S) * lead(opt$S), na.rm = TRUE)

sum(opt$theta * timestep, na.rm = TRUE)
sum(0.5 * opt$gamma * (lead(opt$delta_S) ** 2) * timestep, na.rm = TRUE)

res <- replicate(5000, {
  ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
  
  df <- tibble(S = ss, days = (N-1):0)
  opt <- mutate(df,
                delta_S = S - lag(S),
                # Below is end-of-day calculations
                price = GBSOption("c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3)@price,
                delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3),
                gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3),
                theta = GBSGreeks("Theta", "c", S = S, X = 100, Time = days / 250, r = 0, b = 0, sigma = 0.3) / 250)
  
  sd((log(opt$S / lag(opt$S))[-1])) / sqrt(1 / 250)
  
  pnl1 <- sum(-1 * round(opt$delta, 2) * lead(opt$delta_S), na.rm = TRUE) - opt$price[1] + opt$price[20]
  pnl2 <- sum(0.5 * opt$gamma * (0.5 ** 2 - 0.3 ** 2) * timestep * lead(opt$S) * lead(opt$S), na.rm = TRUE)
  pnl1 - pnl2
})

hist(res)
