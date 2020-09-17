genranS <- function(S,sigma) {
  K <- 100
  drift <- 0 
  timestep <- 1 / 250
  N <- 20
  p1 <- (drift - 0.5 * sigma * sigma) * timestep
  p2 <- sigma * sqrt(timestep)
  # ss is the simulated price movement for N days
  ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
  df <- tibble(S = ss, time = rev(1:days))
}

creategreeks <- function(df,S,sigma) {
  opt <- mutate(df,
                price = GBSOption("c", S = S, X = 100, time / 250,
                                  r = 0, b = 0, sigma = sigma)@price,
                delta = GBSGreeks("Delta", "c", S = S, X = 100, 
                                  time / 250, r = 0, b = 0, sigma = sigma),
                gamma = GBSGreeks("Gamma", "c", S = S, X = 100, 
                                  time / 250, r = 0, b = 0, sigma = sigma),
                theta = GBSGreeks("Theta", "c", S = S, X = 100, 
                                  time / 250, r = 0, b = 0, sigma = sigma) / 250)
}