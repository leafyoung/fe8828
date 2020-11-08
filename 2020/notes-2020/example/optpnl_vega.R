PnL_actual <- c(1:100)
PnL_taylor <- c(1:100)
PnL_vega <- c(1:100)
vega_term <- c(1:100)
gamma_theta <- c(1:100)
impliedVol<-vector(mode="numeric",length=23)

for (i in 1:100) {
  
  S <- 100
  X <- 100
  sigma <- 0.5 # realized vol can be 0.3 for [1] or 0.5 for [2]
  drift <- 0 # drift = r - q
  N <- 22 # no. of trading days in a month
  timestep <- 1 / 250 #in years
  
  
  # ss is the simulated price movement for N days
  p1 <- (drift - 0.5 * sigma * sigma) * timestep
  p2 <- sigma * sqrt(timestep)
  ss <- rep(S, N) * cumprod(rlnorm(N, mean = p1, sd = p2))
  ss[23] <- 0
  ss <- dplyr::lag(ss,n=1L)
  ss[1] <- S
  
  # create a lag vector to calculate change in stock price, dS
  ss_lag <- dplyr::lag(ss, n=1L)
  ss_lag[1] <- S
  dS <- ss-ss_lag
  
  # calculate option price and greeks under implied volatility
  df <- tibble(S = ss,dS=dS, days = 0:N)
  opt <- mutate(df,
                opt_price = GBSOption("c", S = S, X = X, Time = (N-days) / 250, r = 0, b = 0, sigma = 0.3)@price, #calculate option price at 0.3 implied volatility
                delta = GBSGreeks("Delta", "c", S = S, X = X, Time = (N-days)/ 250, r = 0, b = 0, sigma = 0.3),
                gamma = GBSGreeks("Gamma", "c", S = S, X = X, Time = (N-days)/ 250, r = 0, b = 0, sigma = 0.3),
                vega = GBSGreeks("Vega", "c", S = S, X = X, Time = (N-days)/ 250, r = 0, b = 0, sigma = 0.3),
                theta = GBSGreeks("Theta", "c", S = S, X = X, Time = (N-days)/ 250, r = 0, b = 0, sigma = 0.3)
  )
  
  # #back calculate implied volatility
  #  for(j in 1:23){
  #     impliedVol[j] <- GBSVolatility(opt$opt_price[j],"c",S=opt$S[j],X=X,Time = (N-opt$days[j])/250, r = 0, b = 0,tol=0.01,maxiter=10000)
  #     }
  
  #generate daily PnL of underlying stock position
  S_position_lag <- dplyr::lag(opt$delta*-1,n=1L)
  PnL_S <- S_position_lag*dS
  
  opt <- mutate(opt,
                delta_term = dplyr::lag(opt$delta,n=1L)*dS,
                gamma_term = 0.5*dplyr::lag(opt$gamma,n=1L)*dS^2,
                #vega_term = dplyr::lag(opt$vega,n=1L)*(0.5-0.3)/250,
                theta_term = dplyr::lag(opt$theta,n=1L)/250,
                dV_taylor = dplyr::lag(opt$delta,n=1L)*dS + 0.5*dplyr::lag(opt$gamma,n=1L)*dS^2 + dplyr::lag(opt$theta,n=1L)/250,
                PnL_S = PnL_S
                #PnL_daily = PnL_opt + PnL_S
                #PnL_daily = delta*dS + 0.5*gamma*dS**2 + theta*1/250 + PnL_S
  )
  
  PnL_actual[i] <- sum(opt$PnL_S[2:23]) + opt$opt_price[23] - opt$opt_price[1] #actual PnL of the strategy
  PnL_taylor[i] <- sum(opt$dV_taylor[2:23]) + sum(opt$PnL_S[2:23]) #PnL predicted by taylor expansion approximation
  vega_term[i] <- (0.5-0.3)*sum(opt$vega)*1/250 #overall PnL predicted by vega term
  #gamma_theta[i] <- sum(opt$gamma_theta_terms[2:23])
  
  result <- tibble(PnL_actual, PnL_taylor, vega_term)
}

result <- mutate(result,
                 remainder = PnL_taylor-PnL_actual,
                 vega_err = (vega_term-PnL_actual)/PnL_actual,
                 remainder_err = (remainder-PnL_actual)/PnL_actual
)

result