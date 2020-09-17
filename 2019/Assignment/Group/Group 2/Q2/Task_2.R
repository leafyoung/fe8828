library(tidyverse)
library(fOptions)
library(dplyr)

S <- 100
K <- 100
sigma <- 0.3 # realized vol can be 0.3 for [2] or 0.5 for [3]
drift <- 0 # drift = r - q
timestep <- 1 / 250
days <- 20 / 250
N <- days / timestep
tol <- 0.0001
num_simulations <- 1000
pnl_diff_Q1 <- c(rep(0,num_simulations))
pnl_due_gamma_theta_hedging <- c(rep(0,num_simulations))

p1 <- (drift - 0.5 * sigma * sigma) * timestep
p2 <- sigma * sqrt(timestep)

# ss is the simulated price movement for N days
for (i in 1:num_simulations)
{
  ss <- rep(S, N+1) * c(1,cumprod(rlnorm(N, mean = p1, sd = p2)))
  df <- tibble(S = ss, days = 0:N)
  opt <- rowwise(df) %>%
    mutate(price = GBSOption("c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3)@price,
           delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3),
           gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3),
           theta = GBSGreeks("Theta", "c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3)) %>%
    ungroup()
  
  opt1 <- opt %>%
    mutate(stock_price_change = c(0,diff(S)),
           option_pnl = c(0,diff(price)),
           approx_pnl = c(0,head(delta,-1)) * stock_price_change + 
             0.5 * c(0,head(gamma,-1)) * stock_price_change ** 2 + c(0,head(theta,-1)) * 1/250,
           gamma_theta_pnl = 0.5 * c(0,head(gamma,-1)) * stock_price_change ** 2 + c(0,head(theta,-1)) * 1/250) %>%
    mutate(diff_pnl = option_pnl - approx_pnl)
  
  ## part -1
  ## ggplot(opt1) + geom_line(aes(x=days, y=diff_pnl)) +  labs(title = "Diff in Taylor approximation to actual pnl", x = "Date", y = "option pnl - approx pnl")
  ## cat("The sum of difference in pnl due to Taylor approxiamtion  = ", round(sum(opt1$diff_pnl),4),"\n")
  ## cat("The mean of difference in pnl due to Taylor approxiamtion  = ", round(mean(opt1$diff_pnl),4),"\n")
  pnl_diff_Q1[i] <- round(mean(opt1$diff_pnl),4)
  ## part - 2
  # cat("Since realised and implied vols are same, pnl due to gamma and theta hedging over the period is equal to = ",round(sum(opt1$gamma_theta_pnl),4),"\n")
  pnl_due_gamma_theta_hedging[i] <- round(sum(opt1$gamma_theta_pnl),4)
}

hist(pnl_diff_Q1, prob=TRUE)
hist(pnl_due_gamma_theta_hedging, prob=TRUE)

## part -3
sigma <- 0.5
p1 <- (drift - 0.5 * sigma * sigma) * timestep
p2 <- sigma * sqrt(timestep)

pnl_diff_Q3 <- c(rep(0,num_simulations))

for (i in 1:num_simulations) {
  # ss is the simulated price movement for N days
  ss <- rep(S, N+1) * c(1,cumprod(rlnorm(N, mean = p1, sd = p2)))
  df2 <- tibble(S = ss, days = 0:N)
  opt2 <- rowwise(df2) %>%
    mutate(price = GBSOption("c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3)@price,
           delta = GBSGreeks("Delta", "c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3),
           gamma = GBSGreeks("Gamma", "c", S = S, X = 100, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3)) %>%
    ungroup()
  
  realised_vol <- 0.5
  implied_vol <- 0.3
  
  opt2 <- opt2 %>%
    mutate(overall_pnl=(0.5*gamma*(realised_vol**2-implied_vol**2)*(S**2)*timestep),
    # mutate(overall_pnl=(0.5*gamma*(realised_vol**2-implied_vol**2)*(dplyr::lag(S, 1)**2)*timestep),
           stock_price_change = c(0,diff(S)),
           delta_pnl = -c(0,head(delta,-1)) * stock_price_change)
  
  # cat("The Overall PnL of the strategy as calculated from call premium, option payoff and delta pnl is: ", sum(opt2$delta_pnl,na.rm=TRUE)-head(opt2$price,1)+tail(opt2$price,1), "\n")
  # cat("The overall PnL of the strategy as calculated from option hedging is: ", sum(opt2$overall_pnl,na.rm=TRUE),"\n")
  pnl_diff_Q3[i] <- sum(opt2$delta_pnl,na.rm=TRUE)-head(opt2$price,1)+tail(opt2$price,1) - sum(opt2$overall_pnl,na.rm=TRUE)
}

hist(pnl_diff_Q3, prob=TRUE)

mean(pnl_diff_Q3)
