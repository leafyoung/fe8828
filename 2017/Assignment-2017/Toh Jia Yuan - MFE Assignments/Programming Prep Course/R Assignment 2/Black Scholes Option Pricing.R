bs <- function(spot, strike, maturity, sigma, drift) {
  d1 <- 1/sigma/sqrt(maturity)*(log(spot/strike)+(drift+sigma^2/2)*maturity)
  d2 <- d1 - sigma*sqrt(maturity)
  call <- pnorm(d1)*spot - pnorm(d2)*strike
  put <- pnorm(-d2)*strike*exp(-drift*maturity)-pnorm(-d1)*spot
  result <- c(strike,call,put)
  names(result) <- c("strike","call","put")
  result
}

for (strike in seq(50,150,10)) {
  print(bs(100,strike,1,0.15,0.02))
}

strike <- seq(50,150,10)
y <- bs(100,strike,1,0.15,0.02)
dim(y) <- c(length(strike),3)
print(y)
plot(y[,1],y[,2], pch=1,xlab="Strike",ylab="Call Option Value",col="red")
points(y[,1],y[,3], pch=3,xlab="Strike",ylab="Put Option Value",col="blue")