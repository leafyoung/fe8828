library(tidyverse)
library(fOptions) 
library(Hmisc)
library(dplyr)

#define function to generate random stock prices and calculate greeks
genranS <- function(S,sigma) {
  K <- 100
  drift <- 0 
  timestep <- 1 / 250
  days<-20
  N <- 20

  p1 <- (drift - 0.5 * sigma * sigma) * timestep
  p2 <- sigma * sqrt(timestep)
  # ss is the simulated price movement for N days
  ss <- rep(S, N) * c(1, cumprod(rlnorm(N - 1, mean = p1, sd = p2)))
  
  df <- tibble(S = ss, time = rev(1:days))
  return(df)
}

creategreeks <- function(df,IV) {
  opt <- df %>% mutate(
                premium = GBSOption("c", S = S, X = 100, time/250,
                                  r = 0, b = 0, sigma = IV)@price,
                delta = GBSGreeks("Delta", "c", S = S, X = 100, 
                                  time/250, r = 0, b = 0, sigma = IV),
                gamma = GBSGreeks("Gamma", "c", S = S, X = 100, 
                                  time/250, r = 0, b = 0, sigma = IV),
                theta = GBSGreeks("Theta", "c", S = S, X = 100, 
                                  time/250, r = 0, b = 0, sigma = IV) ) 
  return(opt)
}

#Define variables
  b <- 0
  r <- 0
  S <- 100
  sigma <- 0.3
  days<-20
  dt<-1/250
  
  #Part 1
  diffvec <- vector()
  
  for (run in 1:1000) {
    df <- genranS(S,sigma)
    opt1 <- creategreeks(df,sigma)%>%
     mutate(option_pnl = ifelse(time==20,0, premium-dplyr::lag(premium)),
            approx_pnl = ifelse(time==20,0,dplyr::lag(delta) * (S - dplyr::lag(S)) + 0.5 * dplyr::lag(gamma) * 
                   (S - dplyr::lag(S)) ** 2 + dplyr::lag(theta)*dt),
           difference = option_pnl-approx_pnl)
    diffvec <- c(diffvec,meandiff=mean(opt1$difference))
  }
             
  #Conclusion
  hist(as.numeric(diffvec),
       main="Histogram for Error in Approximation \n in 1,000 simulations", 
       xlab="Error in Approximation of 20 day PnL", 
       col="lightblue")
  cat(paste0("Taylor's approximation is close to actual PnL, ", 
             "with an average difference of ", mean(as.numeric(diffvec))))
  
  #Part 2
  sumvec <- vector()
  for (run in 1:1000) {
    df2 <- genranS(S,sigma)
    opt2 <- creategreeks(df2,sigma) %>%
      mutate(gammaterm = 0.5 * gamma * ((S - dplyr::lag(S))^2),
             thetaterm = theta*dt,
             sum=gammaterm+thetaterm)
    sumvec <- c(sumvec,mean(opt2$sum,na.rm=TRUE))
  }
  
  #Conclusion
  hist(as.numeric(sumvec),
       main="Histogram for Neutralisation \n of Gamma and Theta
       in 1,000 simulations", 
       xlab="Sum of Gamma term and Theta term in 20 days", 
       col="lightgreen")
  cat(paste0("Gamma and Theta can neutralise each other, ",
             "with an average sum of ", mean(as.numeric(sumvec))))
  
  #Part 3
  #Consider strategy of long call option and shorting stocks
  realizedVol <- 0.5
  numOptions <- 100
  premium0Vec<-vector()
  deltaPnlvec <- vector()
  finalstockvaluevec <- vector()
  finalpayoffvec <- vector()
  apnlvec <- vector()
  
  for (run in 1:1000) {
    #prices are generated using realised volatility 0.5
    df3 <- genranS(S,realizedVol)
    
    #Option table generated using implied volatility 0.3
    opt3 <- creategreeks(df3,sigma) %>%
      mutate(shareHedge = -numOptions * delta,
             DoD_PnL = ifelse(time == .$time[1],  -S * shareHedge, 
                                      -S * (shareHedge - Lag(shareHedge))),             
             approxpnl = numOptions*(0.5 * gamma * S^2 * dt  * (realizedVol^2 - sigma^2))
      )

      premium0Vec <-c(premium0Vec,-opt3$premium[1]*numOptions) 
      finalpayoffvec <- c(finalpayoffvec, numOptions*max(opt3$S[[days]]-100,0))
      
      deltaPnlvec <- c(deltaPnlvec, sum(opt3$DoD_PnL))
      finalstockvaluevec <- c(finalstockvaluevec,opt3$shareHedge[[days]]*opt3$S[[days]])
      
      apnlvec <- c(apnlvec,sum(opt3$approxpnl,na.rm = TRUE))
  }
  
  overallpnl <- (as.numeric(premium0Vec) + as.numeric(finalpayoffvec) + as.numeric(deltaPnlvec)+ as.numeric(finalstockvaluevec))
  
  aoverallpnl <- as.numeric(apnlvec)
  
  pnldiff <- overallpnl - aoverallpnl
  
  #Conclusion
  hist(as.numeric(pnldiff),
       main="Histogram for Error in Approximation \n of Overall PnL
       in 1,000 simulations", 
       xlab="Error in Approximation in 20 day PnL", 
       col="yellow")
  cat(paste0("The overall pnl can be approximated by the formula, ",
             "with an average error of ", mean(pnldiff)))

  