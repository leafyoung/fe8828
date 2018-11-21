bs <- function(spot, strike, maturity, sigma, drift) {
  d1 <- 1/sigma/sqrt(maturity)*(log(spot/strike)+(drift+sigma^2/2)*maturity)
  d2 <- d1 - sigma*sqrt(maturity)
  call <- pnorm(d1)*spot - pnorm(d2)*strike
  put <- pnorm(-d2)*strike*exp(-drift*maturity)-pnorm(-d1)*spot
  result <- c(call)
  names(result) <- c("call")
  result
}

for (strike in seq(50,150,10)) {
  print(bs(100,strike,1,0.15,0.02))
}

bs2 <- function(spot, strike, maturity, sigma, drift) {
  d1 <- 1/sigma/sqrt(maturity)*(log(spot/strike)+(drift+sigma^2/2)*maturity)
  d2 <- d1 - sigma*sqrt(maturity)
  call <- pnorm(d1)*spot - pnorm(d2)*strike
  put <- pnorm(-d2)*strike*exp(-drift*maturity)-pnorm(-d1)*spot
  result <- c(put)
  names(result) <- c("put")
  result
}

for (strike in seq(50,150,10)) {
  print(bs2(100,strike,1,0.15,0.02))
}

strike <- seq(50,150,10)
call <- bs(100,strike,1,0.15,0.02)
put <- bs2(100,strike,1,0.15,0.02)
z<-data.frame(strike,call,put)
print(z)

plot(z[,1],z[,2], pch=2,xlab="Strike",ylab="Option Value",col="red")
points(z[,1],z[,3], pch=3,xlab="Strike",ylab="Option Value",col="blue")
legend("top", c("Call","Put"), pch=2:3, cex=0.7)