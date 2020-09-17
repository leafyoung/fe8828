library(tidyverse)
library(fOptions)
library(RND)

S0 <- 100
K <- 100
sigma <- 0.3 # realized vol
sigma2 <- 0.5
drift <- 0 # drift = r - q
timestep <- 1 / 250
days <- 22 / 250
N <- days / timestep
p1 <- (drift - 0.5 * sigma * sigma) * timestep
p1_2 <- (drift - 0.5 * sigma2 * sigma2) * timestep
p2 <- sigma * sqrt(timestep)
p2_2 <- sigma2 * sqrt(timestep)
diff <- list()
maxdiff <- 0
sum_neu <- 0
neu_number <- 0 #number of two volatility close to each other
sum_approx_pnl <- 0
sum_overall_pnl <- 0
stddiff <- list()
meandiff <- list()
for (nn in 1:500){
  # ss is the simulated price movement for N days
  N <- days / timestep
  ss <- rep(S0, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
  ss2 <- rep(S0, N) * c(1, cumprod(rlnorm(N - 1, mean = p1_2, sd = p2_2)))
  df <- tibble(S = ss, day = 1:(days*250))
  df2 <- tibble(S = ss2, day = 1:(days*250))

  opt <- rowwise(df) %>% mutate(
    price = GBSOption("c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma)@price,
    vega = GBSGreeks("Vega", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma),
    delta = GBSGreeks("Delta", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma),
    gamma = GBSGreeks("Gamma", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma),
    theta = GBSGreeks("Theta", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma),
    vol = GBSVolatility(price, "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, tol = 0.01, maxiter = 10000)
  )
  opt<-opt[-nrow(opt),]  #drop last NAN row
  N <- N-1
  
  #[1] Please show how good Taylor??s approximation to actual PnL.
  actual_pnl <- opt["price"][2:N,] - opt["price"][1: (N-1),]
  approx_pnl <- opt["delta"][1: (N-1),] * (opt["S"][2: N,] - opt["S"][1: (N-1),]) + 0.5 * opt["gamma"][1: (N-1),] * 
    (opt["S"][2: N,] - opt["S"][1: (N-1),]) ** 2 + opt["vega"][1: (N-1),] * 0 + opt["theta"][1: (N-1),] * timestep
  diff[i] <- actual_pnl - approx_pnl
  maxdiff <- max(maxdiff, mean(diff[[i]]))  #show the average level of diff
  
  #[2] If realized volatility and implied volatility are the same, Gamma and Theta can neutralize each other
  gamma <- (abs(opt$vol - sigma) < 1e-05) * opt$gamma #when difference between realized and implied vol smaller than 10^-6, see as the same
  theta <- (abs(opt$vol - sigma) < 1e-05) * opt$theta
  sum_neu <- sum_neu + sum(0.5 * gamma * (opt["S"][2: N,] - opt["S"][1: (N-1),]) ** 2 + theta*timestep)
  neu_number<-neu_number + sum(abs(opt$vol - 0.3) < 1e-05) #number of two volatility close to each other
  
  #[3] If realized volatility > implied volatility
  opt2 <- rowwise(df2) %>% mutate(
    price = GBSOption("c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma2)@price,
    vega = GBSGreeks("Vega", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma2),
    delta = GBSGreeks("Delta", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma2),
    gamma = GBSGreeks("Gamma", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma2),
    theta = GBSGreeks("Theta", "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, sigma2),
    vol = GBSVolatility(price, "c", S = S, X = K, Time = (days*250-day)/250, r = 0, b = 0, tol = 0.01, maxiter = 10000)
  )
  
  hedging_pnl <- list()
  hedging_pnl[1] <- 0
  #temp <- (-1) * opt2["delta"][1: N,] * (opt2["price"][2:(N+1),] - opt2["price"][1: N,])
  temp <- (-1) * opt2["delta"][1: N,] * (opt2["S"][2:(N+1),] - opt2["S"][1: N,])
  for (i in 1:N){hedging_pnl[i+1]=temp[i,]}
  #option_pnl <- list()
  #option_pnl[1] <- (-1) * opt2["price"][1,]
  #temp <- (opt2["price"][2:(N+1),] - opt2["price"][1: N,])
  #for (i in 1:N){option_pnl[i+1]=temp[i,]}
  #delta_pnl = unlist(unlist(hedging_pnl)+unlist(option_pnl))
  delta_pnl = cumsum(unlist(hedging_pnl))
  opt2 <- opt2 %>% mutate(deltapnl = 0)
  for (i in 1:(N+1)){opt2$deltapnl[i]=delta_pnl[i]}
  opt2 <- opt2[-nrow(opt2),] 
  
  approx <- cumsum(0.5 * opt2$gamma * (sigma2 ** 2 - opt2$vol ** 2) * timestep * opt2$S ** 2)
  overall <- opt2$deltapnl - sum(opt2["price"][1,]) + opt2$price
  
  stddiff[nn] <- stdev(abs(approx-overall), na.rm = TRUE)
  meandiff[nn] <- mean(abs(approx-overall), na.rm = TRUE)  
}

cat(paste0("The max average level of difference between actual and approximated pnl is: ", maxdiff))
cat(paste0("The sum of gamma term + theta term in which realized =~ implied vol is: ", sum_neu, " with the number of term is: ", neu_number))
cat(paste0("Sample of mean of difference betweeen approximate and overall pnl: "))
unlist(head(meandiff))
cat(paste0("Sample of std of difference betweeen approximate and overall pnl: "))
unlist(head(stddiff))

hist(unlist(meandiff))
hist(unlist(stddiff))

