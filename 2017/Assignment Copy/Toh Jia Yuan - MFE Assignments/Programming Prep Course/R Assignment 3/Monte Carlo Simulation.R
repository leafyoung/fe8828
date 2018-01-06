payoff_call <- function(price, strike) {
  max(price - strike, 0)
}

payoff_put <- function(price, strike) {
  max(strike - price,0)
}

mc1 <- function(payoff_f, N, spot, strike, maturity, sigma, drift) {
  timestep <- 1/250
  steps <- round(maturity/timestep)
  
  p1 <- (drift-0.5*sigma*sigma)*timestep
  p2 <- sigma*sqrt(timestep)
  
  ss <- replicate(N, spot)
  step <- 1
  repeat {
    ss <- ss*rlnorm(N,p1,p2)
    step <- step + 1
    if (step>steps) {break;}
  }
  payoff <- sapply(ss, payoff_f, strike)
  result <- exp(-drift*maturity)*mean(payoff)
  result
}

print(mc1(payoff_call,100,100,100,1,0.15,0.02))


call <- function(N){
  callpayoff <- mc1(payoff_call, N, 100, 100, 1, 0.12, 0.02)
}

put <- function(N){
  putpayoff <- mc1(payoff_put, N, 100, 100, 1, 0.12, 0.02)
}


Callresult  <- sapply(1:1000,call)
plot(1:1000, Callresult, col="blue",xlab="N",ylab="",main="Call Option Value")
par(new=F)

Putresult  <- sapply(1:1000,put)
plot(1:1000, Putresult,col="red",xlab="N",ylab="",main="Put Option Value")
par(new=F)

